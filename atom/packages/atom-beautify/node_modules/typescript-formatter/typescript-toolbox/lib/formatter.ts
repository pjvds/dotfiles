import TypeScript = require("../typescript/tss");

import lsh = require("./languageServiceHost");

export function createDefaultFormatCodeOptions() {
	return new TypeScript.Services.FormatCodeOptions();
}

export function applyFormatterToContent(content:string, formatCodeOptions = createDefaultFormatCodeOptions()):string {
	var languageServiceHost = new lsh.LanguageServiceHostImpl();
	var filePath = "tmp.ts";

	languageServiceHost.addFile({
		fileName: filePath,
		version: 0,
		open: false,
		byteOrderMark: TypeScript.ByteOrderMark.None,
		snapshot: TypeScript.ScriptSnapshot.fromString(content)
	});
	var languageService = new TypeScript.Services.LanguageService(languageServiceHost);
	var textEdits = languageService.getFormattingEditsForRange(filePath, 0, content.length, formatCodeOptions);

	return applyTextEdit(content, textEdits);
}

export function applyTextEdit(content:string, textEdits:TypeScript.Services.TextEdit[]):string {
	for (var i = textEdits.length - 1; 0 <= i; i--) {
		var textEdit = textEdits[i];
		var b = content.substring(0, textEdit.minChar);
		var a = content.substring(textEdit.limChar);
		content = b + textEdit.text + a;
	}
	return content;
}
