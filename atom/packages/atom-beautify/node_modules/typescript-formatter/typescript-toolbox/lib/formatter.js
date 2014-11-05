var TypeScript = require("../typescript/tss");

var lsh = require("./languageServiceHost");

function createDefaultFormatCodeOptions() {
    return new TypeScript.Services.FormatCodeOptions();
}
exports.createDefaultFormatCodeOptions = createDefaultFormatCodeOptions;

function applyFormatterToContent(content, formatCodeOptions) {
    if (typeof formatCodeOptions === "undefined") { formatCodeOptions = exports.createDefaultFormatCodeOptions(); }
    var languageServiceHost = new lsh.LanguageServiceHostImpl();
    var filePath = "tmp.ts";

    languageServiceHost.addFile({
        fileName: filePath,
        version: 0,
        open: false,
        byteOrderMark: 0 /* None */,
        snapshot: TypeScript.ScriptSnapshot.fromString(content)
    });
    var languageService = new TypeScript.Services.LanguageService(languageServiceHost);
    var textEdits = languageService.getFormattingEditsForRange(filePath, 0, content.length, formatCodeOptions);

    return exports.applyTextEdit(content, textEdits);
}
exports.applyFormatterToContent = applyFormatterToContent;

function applyTextEdit(content, textEdits) {
    for (var i = textEdits.length - 1; 0 <= i; i--) {
        var textEdit = textEdits[i];
        var b = content.substring(0, textEdit.minChar);
        var a = content.substring(textEdit.limChar);
        content = b + textEdit.text + a;
    }
    return content;
}
exports.applyTextEdit = applyTextEdit;
