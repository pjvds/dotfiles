var TypeScript = require("../typescript/tss");

var FileInfo = (function () {
    function FileInfo() {
    }
    return FileInfo;
})();
exports.FileInfo = FileInfo;

var LanguageServiceHostImpl = (function () {
    function LanguageServiceHostImpl() {
        this.compilationSettings = new TypeScript.CompilationSettings();
        this.diagnostics = {
            log: function (content) {
                return console.log(content);
            }
        };
        this.fileInfos = {};
    }
    LanguageServiceHostImpl.prototype.getCompilationSettings = function () {
        return this.compilationSettings;
    };

    LanguageServiceHostImpl.prototype.getScriptFileNames = function () {
        return Object.getOwnPropertyNames(this.fileInfos);
    };

    LanguageServiceHostImpl.prototype.getScriptVersion = function (fileName) {
        return this.fileInfos[fileName].version;
    };

    LanguageServiceHostImpl.prototype.getScriptIsOpen = function (fileName) {
        return this.fileInfos[fileName].open;
    };

    LanguageServiceHostImpl.prototype.getScriptByteOrderMark = function (fileName) {
        return this.fileInfos[fileName].byteOrderMark;
    };

    LanguageServiceHostImpl.prototype.getScriptSnapshot = function (fileName) {
        return this.fileInfos[fileName].snapshot;
    };

    LanguageServiceHostImpl.prototype.getDiagnosticsObject = function () {
        return this.diagnostics;
    };

    LanguageServiceHostImpl.prototype.getLocalizedDiagnosticMessages = function () {
        return null;
    };

    LanguageServiceHostImpl.prototype.information = function () {
        return false;
    };

    LanguageServiceHostImpl.prototype.debug = function () {
        return false;
    };

    LanguageServiceHostImpl.prototype.warning = function () {
        return false;
    };

    LanguageServiceHostImpl.prototype.error = function () {
        return false;
    };

    LanguageServiceHostImpl.prototype.fatal = function () {
        return false;
    };

    LanguageServiceHostImpl.prototype.log = function (s) {
    };

    LanguageServiceHostImpl.prototype.resolveRelativePath = function (path, directory) {
        console.log("resolveRelativePath", path, directory);
        return path;
    };

    LanguageServiceHostImpl.prototype.fileExists = function (path) {
        console.log("fileExists", path);
        var fs = require("fs");
        return fs.existsSync(path);
    };

    LanguageServiceHostImpl.prototype.directoryExists = function (path) {
        console.log("directoryExists", path);
        var fs = require("fs");
        return fs.existsSync(path);
    };

    LanguageServiceHostImpl.prototype.getParentDirectory = function (path) {
        console.log("getParentDirectory", path);
        return path;
    };

    LanguageServiceHostImpl.prototype.addFile = function (file) {
        this.fileInfos[file.fileName] = file;
    };

    LanguageServiceHostImpl.prototype.setCompilationSettings = function (compilationSettings) {
        this.compilationSettings = compilationSettings;
    };
    return LanguageServiceHostImpl;
})();
exports.LanguageServiceHostImpl = LanguageServiceHostImpl;
