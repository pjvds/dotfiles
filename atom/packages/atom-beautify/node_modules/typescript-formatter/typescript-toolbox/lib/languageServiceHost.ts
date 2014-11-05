import TypeScript = require("../typescript/tss");

export class FileInfo {
	fileName:string;
	version:number;
	open:boolean;
	byteOrderMark:TypeScript.ByteOrderMark;
	snapshot:TypeScript.IScriptSnapshot;
}

export class LanguageServiceHostImpl implements TypeScript.Services.ILanguageServiceHost {
	compilationSettings = new TypeScript.CompilationSettings();
	diagnostics:TypeScript.Services.ILanguageServicesDiagnostics = {
		log: (content:string) => console.log(content)
	};
	fileInfos:{ [fileName: string]: FileInfo } = {};

	// for ILanguageServiceHost impl

	getCompilationSettings():TypeScript.CompilationSettings {
		return this.compilationSettings;
	}

	getScriptFileNames():string[] {
		return Object.getOwnPropertyNames(this.fileInfos);
	}

	getScriptVersion(fileName:string):number {
		return this.fileInfos[fileName].version;
	}

	getScriptIsOpen(fileName:string):boolean {
		return this.fileInfos[fileName].open;
	}

	getScriptByteOrderMark(fileName:string):TypeScript.ByteOrderMark {
		return this.fileInfos[fileName].byteOrderMark;
	}

	getScriptSnapshot(fileName:string):TypeScript.IScriptSnapshot {
		return this.fileInfos[fileName].snapshot;
	}

	getDiagnosticsObject():TypeScript.Services.ILanguageServicesDiagnostics {
		return this.diagnostics;
	}

	getLocalizedDiagnosticMessages():any {
		return null;
	}

	// for ILogger impl

	information():boolean {
		return false;
	}

	debug():boolean {
		return false;
	}

	warning():boolean {
		return false;
	}

	error():boolean {
		return false;
	}

	fatal():boolean {
		return false;
	}

	log(s:string):void {
		// console.log(s);
	}

	// for IReferenceResolverHost impl

	resolveRelativePath(path:string, directory:string):string {
		console.log("resolveRelativePath", path, directory);
		return path;
	}

	fileExists(path:string):boolean {
		console.log("fileExists", path);
		var fs = require("fs");
		return fs.existsSync(path);
	}

	directoryExists(path:string):boolean {
		console.log("directoryExists", path);
		var fs = require("fs");
		return fs.existsSync(path);
	}

	getParentDirectory(path:string):string {
		console.log("getParentDirectory", path);
		return path;
	}

	// original
	addFile(file:FileInfo) {
		this.fileInfos[file.fileName] = file;
	}

	setCompilationSettings(compilationSettings:TypeScript.CompilationSettings):void {
		this.compilationSettings = compilationSettings;
	}
}
