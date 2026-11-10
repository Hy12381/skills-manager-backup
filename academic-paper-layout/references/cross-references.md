# 建立与验证内部引用

## 选择维护机制

- 初稿/持续修订：如可用，保留文献管理器字段；图表用序号域和带超链接的交叉引用域，例如 `REF FigureBookmark \h`。引用字段更新后必须重新核对显示文字与目标。
- 已定稿只缺跳转：书签加 `w:hyperlink w:anchor="..."`。此方式保留现有显示文字，不实现自动编号。
- 仅要求文献内部跳转，不自动给每个文后URL增加外链。不要将普通文本数字误识别为引用。

## 可复用工具

`scripts/docx_internal_links.py` 使用标准库与 lxml，不需要 Word 进行 XML 编辑；使用当前工作区的 Python 运行。它有意要求明确映射，不在稿件上盲目按正则自动绑定。

```text
python scripts/docx_internal_links.py inventory --input source.docx --output inventory.json
python scripts/docx_internal_links.py apply --input source.docx --manifest links.json --output linked.docx --audit audit.json
```

inventory 返回文件哈希及所有正文/表格段落的索引、文字、样式、已有书签与链接信息。根据真实稿件编写 manifest，字符区间按 Python Unicode 字符索引，`start` 含、`end` 不含：

```json
{
  "source_sha256": "从inventory复制的完整哈希",
  "targets": [{"key": "Ref_1", "paragraph": 12, "expected_text": "[1] 对应的完整参考文献文字"}],
  "links": [{"paragraph": 3, "start": 6, "end": 9, "expected_text": "[1]", "target": "Ref_1"}]
}
```

上例索引只演示结构，必须换成该稿件的真实索引、文字和哈希。正文标记跨多个普通文字 run 时工具保留各段字体、上标等属性，并生成必要的链接片段；表格段落也在清单中。

应用前工具拒绝旧哈希、重复目标、越界或重叠区间、文字不符、未知目标、已存在文件的覆盖，以及与既有超链接/字段/修订等复杂结构相交的操作。遇到拒绝应改用 Word 原生接口或设计兼容编辑，不能删除合法复杂结构来让脚本通过。

目标书签跨该段完整文字，ID和名称避开现有书签。源文件不改。除 `word/document.xml` 外其他 ZIP 条目必须内容一致；ZIP 元数据复制后再写，不能直接复用并修改输入 `ZipInfo`，否则源 ZIP 对象的偏移信息可能被污染。

## 映射注意事项

- `[3]2-3` 中只有 `[3]` 是参考文献标记，后面的 `2-3` 是引文页码。
- `[3,8-9]` 可分为三个可点击区间，分别连到3、8、9；中间未显示的文献不生成伪数字。保留括号、连接号和上标。
- 参考文献目标由编号和条目身份共同确认；图表目标由题注类型、编号和标题确认。附录或分章编号显式定义目标。
- 遍历包含表格的所有段落，不只 `document.paragraphs`。注意文本框、脚注、尾注另有部件；本工具不编辑这些部件，若任务包含这些位置应另行处理并标记验证范围。
- caption/bookmark不是链接来源的默认替代品；需要的是正文的图表称引到目标，不能只给题注链接到自身。

## Word 实测

Windows安装 Word 时，可从工作目录运行：

```powershell
& scripts/verify_word_navigation.ps1 -InputDocx 'linked.docx' -OutputPdf 'linked.pdf' -AuditPath 'word-check.json'
```

脚本在独立 Word 实例只读打开文稿，逐个检查 anchor、书签以及 `Follow()` 后实际选区位置，再导出 PDF；不保存DOCX，不改Word选项。只验证主文档 `Hyperlinks` 集合，外部链接跳过并记录。任何不能实际 Follow 的结果不得计为通过。

脚本不会自动更新原稿所有域，以免修改既有引用的显示结果。任务确需更新域时先在副本更新，再重新执行本验证。

## PDF 与视觉验证

1. 使用 PyMuPDF 等枚举每页的 `get_links()`，要求预期内部链接为 GoTo、目标页有效。
2. 将 Word 验证所得的 anchor/目标页与 PDF 目标页及落点附近的题注/文献文字对应。多个跨行点击区域可以对应同一个逻辑链接；不能强行要求 PDF annotation 数等于 Word Hyperlinks 数。
3. 渲染PDF全部页面并看缩略图，放大检查发生变化的页面。核对字色、上标、图表位置、分页和引用换行。只做文本提取不能证明版式正确。
4. 程序检查不替代实际阅读器行为；可实际点选时选文献、同页图表、跨页图表和组合引用各做代表性验证。若用 Word 对全部内部链接 Follow，说明是实际跳转检查。
5. Word 编辑模式一般 Ctrl+单击，PDF一般单击；不为改变此习惯修改用户全局安全或编辑选项。
