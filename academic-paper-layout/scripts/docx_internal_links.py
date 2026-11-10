"""Add explicitly mapped internal DOCX links without rewriting manuscript content."""
from __future__ import annotations
import argparse
from copy import copy, deepcopy
import hashlib
import json
from pathlib import Path
import re
import sys
from zipfile import ZipFile
from lxml import etree as ET

W = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'
M = 'http://schemas.openxmlformats.org/officeDocument/2006/math'
NS = {'w': W, 'm': M}
XML_SPACE = '{http://www.w3.org/XML/1998/namespace}space'

def w(tag):
    return '{' + W + '}' + tag

def visible_text(element):
    pieces = []
    for node in element.iter():
        if node.tag in (w('t'), '{' + M + '}t'):
            pieces.append(node.text or '')
        elif node.tag == w('tab'):
            pieces.append('\t')
        elif node.tag in (w('br'), w('cr')):
            pieces.append('\n')
    return ''.join(pieces)

def load(path):
    with ZipFile(path) as archive:
        infos = archive.infolist()
        payloads = {info.filename: archive.read(info.filename) for info in infos}
    parser = ET.XMLParser(resolve_entities=False, no_network=True)
    root = ET.fromstring(payloads['word/document.xml'], parser)
    paragraphs = root.xpath('//w:body//w:p', namespaces=NS)
    return infos, payloads, root, paragraphs

def sha256(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def dump(path, value):
    path = Path(path)
    if path.exists():
        raise ValueError(f'Refusing to overwrite existing report: {path}')
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open('x', encoding='utf-8') as stream:
        json.dump(value, stream, ensure_ascii=False, indent=2)

def inventory(input_path, output_path):
    _, _, root, paragraphs = load(input_path)
    rows = []
    for index, paragraph in enumerate(paragraphs):
        styles = paragraph.xpath('./w:pPr/w:pStyle/@w:val', namespaces=NS)
        rows.append({'paragraph': index, 'text': visible_text(paragraph),
                     'style': styles[0] if styles else None,
                     'has_nested_paragraph': bool(paragraph.xpath('.//w:p', namespaces=NS)),
                     'hyperlinks': paragraph.xpath('.//w:hyperlink/@w:anchor', namespaces=NS)})
    result = {'source': str(Path(input_path).resolve()), 'source_sha256': sha256(input_path),
              'paragraphs': rows,
              'bookmarks': root.xpath('//w:bookmarkStart/@w:name', namespaces=NS),
              'scope': 'word/document.xml body and table paragraphs; other story parts are not edited'}
    dump(output_path, result)
    return {'paragraphs': len(rows), 'inventory': str(output_path)}

def apply(input_path, manifest_path, output_path, audit_path):
    source, output = Path(input_path).resolve(), Path(output_path).resolve()
    audit = Path(audit_path).resolve()
    if len({source, output, audit, Path(manifest_path).resolve()}) != 4:
        raise ValueError('Source, output, manifest and audit must use distinct paths')
    if output.exists() or audit.exists():
        raise ValueError('Output or audit exists; choose new output paths')
    manifest = json.loads(Path(manifest_path).read_text(encoding='utf-8-sig'))
    digest = sha256(source)
    if manifest.get('source_sha256') != digest:
        raise ValueError('Source hash mismatch; regenerate inventory and manifest')
    infos, payloads, root, paragraphs = load(source)
    if any(name.startswith('_xmlsignatures/') for name in payloads):
        raise ValueError('Signed DOCX requires a signature-aware editing workflow')
    before = [visible_text(p) for p in paragraphs]
    names = set(root.xpath('//w:bookmarkStart/@w:name', namespaces=NS))
    existing_ids = root.xpath('//w:bookmarkStart/@w:id | //w:bookmarkEnd/@w:id', namespaces=NS)
    next_id = max([int(i) for i in existing_ids if i.isdigit()] + [-1]) + 1
    targets = {}
    for target in manifest.get('targets', []):
        key = target['key']
        if not re.fullmatch(r'[A-Za-z][A-Za-z0-9_]{0,27}', key) or key in targets:
            raise ValueError(f'Invalid or duplicate target key: {key}')
        index = target['paragraph']
        if not isinstance(index, int) or not 0 <= index < len(paragraphs):
            raise ValueError(f'Target paragraph out of range: {index}')
        if target['expected_text'] != before[index]:
            raise ValueError(f'Target text mismatch at paragraph {index}')
        if paragraphs[index].xpath('.//w:p', namespaces=NS):
            raise ValueError('Nested text-box paragraph targets need a dedicated editor')
        name = 'APL_' + key
        suffix = 1
        while name in names:
            name = 'APL_' + key + '_' + str(suffix)
            suffix += 1
        names.add(name)
        targets[key] = {**target, 'bookmark': name, 'id': str(next_id)}
        next_id += 1
    if not targets:
        raise ValueError('Manifest has no targets')
    groups = {}
    for link in manifest.get('links', []):
        index, start, end = link['paragraph'], link['start'], link['end']
        if not all(isinstance(value, int) for value in (index, start, end)):
            raise ValueError('Link paragraph and offsets must be integers')
        if not 0 <= index < len(paragraphs) or not 0 <= start < end <= len(before[index]):
            raise ValueError(f'Link range out of bounds: {link}')
        if before[index][start:end] != link['expected_text']:
            raise ValueError(f'Link text mismatch at paragraph {index}, {start}:{end}')
        if link['target'] not in targets:
            raise ValueError(f'Unknown target: {link["target"]}')
        groups.setdefault(index, []).append(link)
    if not groups:
        raise ValueError('Manifest has no links')
    hyperlink_nodes = 0
    for index, links in groups.items():
        paragraph = paragraphs[index]
        if paragraph.xpath('.//w:p | .//w:fldChar | .//w:instrText | .//w:fldSimple | .//w:ins | .//w:del', namespaces=NS):
            raise ValueError(f'Complex paragraph {index}; use a field/revision-aware editor')
        links.sort(key=lambda value: value['start'])
        if any(a['end'] > b['start'] for a, b in zip(links, links[1:])):
            raise ValueError(f'Overlapping link ranges in paragraph {index}')
        offset = 0
        for run in list(paragraph):
            text = visible_text(run)
            run_end = offset + len(text)
            hits = [link for link in links if link['start'] < run_end and link['end'] > offset]
            if hits:
                if run.tag != w('r') or any(child.tag not in (w('rPr'), w('t')) for child in run):
                    raise ValueError(f'Link overlaps a complex node in paragraph {index}')
                cuts = sorted({0, len(text)} | {max(0, h['start'] - offset) for h in hits} |
                              {min(len(text), h['end'] - offset) for h in hits})
                position = paragraph.index(run)
                for left, right in zip(cuts, cuts[1:]):
                    part = deepcopy(run)
                    for child in list(part):
                        if child.tag != w('rPr'):
                            part.remove(child)
                    text_node = ET.SubElement(part, w('t'))
                    text_node.text = text[left:right]
                    if text_node.text[:1].isspace() or text_node.text[-1:].isspace():
                        text_node.set(XML_SPACE, 'preserve')
                    hit = next((h for h in hits if h['start'] <= offset + left and offset + right <= h['end']), None)
                    if hit:
                        target = targets[hit['target']]
                        node = ET.Element(w('hyperlink'), {w('anchor'): target['bookmark'], w('history'): '1',
                                          w('tooltip'): '跳转至 ' + target['expected_text'][:150]})
                        node.append(part)
                        hyperlink_nodes += 1
                    else:
                        node = part
                    paragraph.insert(position, node)
                    position += 1
                paragraph.remove(run)
            offset = run_end
    for target in targets.values():
        paragraph = paragraphs[target['paragraph']]
        start = ET.Element(w('bookmarkStart'), {w('id'): target['id'], w('name'): target['bookmark']})
        end = ET.Element(w('bookmarkEnd'), {w('id'): target['id']})
        paragraph.insert(1 if paragraph.find(w('pPr')) is not None else 0, start)
        paragraph.append(end)
    after = [visible_text(p) for p in paragraphs]
    if before != after:
        raise ValueError('Content preservation check failed; no output was written')
    xml = ET.tostring(root, encoding='UTF-8', xml_declaration=True, standalone=True)
    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open('xb') as stream, ZipFile(stream, 'w') as archive:
        for info in infos:
            archive.writestr(copy(info), xml if info.filename == 'word/document.xml' else payloads[info.filename])
    with ZipFile(output) as archive:
        changed = [name for name, value in payloads.items() if archive.read(name) != value]
    if changed != ['word/document.xml']:
        raise ValueError(f'Unexpected package changes: {changed}')
    result = {'source': str(source), 'output': str(output), 'source_sha256': digest,
              'output_sha256': sha256(output), 'paragraph_text_identical': True,
              'changed_parts': changed, 'logical_links': sum(map(len, groups.values())),
              'new_hyperlink_nodes': hyperlink_nodes, 'targets': list(targets.values()),
              'links': [link for links in groups.values() for link in links],
              'validation_scope': 'OOXML content and anchors; Word navigation and PDF export still require verification'}
    dump(audit, result)
    return {'output': str(output), 'targets': len(targets), 'logical_links': result['logical_links'],
            'new_hyperlink_nodes': hyperlink_nodes, 'paragraph_text_identical': True}

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='command', required=True)
    inv = sub.add_parser('inventory')
    inv.add_argument('--input', required=True)
    inv.add_argument('--output', required=True)
    edit = sub.add_parser('apply')
    for name in ('input', 'manifest', 'output', 'audit'):
        edit.add_argument('--' + name, required=True)
    args = parser.parse_args()
    try:
        result = inventory(args.input, args.output) if args.command == 'inventory' else apply(args.input, args.manifest, args.output, args.audit)
    except (ValueError, KeyError, IndexError, OSError, ET.XMLSyntaxError) as error:
        print(json.dumps({'ok': False, 'error': str(error)}, ensure_ascii=False), file=sys.stderr)
        return 1
    print(json.dumps({'ok': True, **result}, ensure_ascii=False, indent=2))
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
