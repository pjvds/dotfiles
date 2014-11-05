import TypeScript = require("../typescript/tss");

import lsh = require("./languageServiceHost");

export function createDefaultFormatCodeOptions() {
	return new TypeScript.Services.FormatCodeOptions();
}

export function getSyntaxTreeByContent(content:string, compilationSettings?:TypeScript.CompilationSettings):TypeScript.SyntaxTree {
	var languageServiceHost = new lsh.LanguageServiceHostImpl();
	var filePath = "tmp.ts";

	languageServiceHost.addFile({
		fileName: filePath,
		version: 0,
		open: false,
		byteOrderMark: TypeScript.ByteOrderMark.None,
		snapshot: TypeScript.ScriptSnapshot.fromString(content)
	});
	if (compilationSettings) {
		languageServiceHost.setCompilationSettings(compilationSettings);
	}
	var languageService = new TypeScript.Services.LanguageService(languageServiceHost);
	return languageService.getSyntaxTree(filePath);
}

export function getAstByContent(content:string, compilationSettings?:TypeScript.CompilationSettings):TypeScript.SourceUnit {
	var syntaxTree = getSyntaxTreeByContent(content, compilationSettings);
	var immutableSettings = TypeScript.ImmutableCompilationSettings.fromCompilationSettings(compilationSettings);

	return TypeScript.SyntaxTreeToAstVisitor.visit(syntaxTree, "tmp.ts", immutableSettings, false);
}
