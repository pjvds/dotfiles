var editorconfig = require("editorconfig");

function makeFormatCodeOptions(fileName, options) {
    var config = editorconfig.parse(fileName);
    if (Object.keys(config).length === 0) {
        return options;
    }

    if (config.indent_style === "tab") {
        options.ConvertTabsToSpaces = false;
    } else if (typeof config.indent_size === "number") {
        options.ConvertTabsToSpaces = true;
        options.IndentSize = config.indent_size;
    }
    if (config.end_of_line === "lf") {
        options.NewLineCharacter = "\n";
    } else if (config.end_of_line === "cr") {
        options.NewLineCharacter = "\r";
    } else if (config.end_of_line === "crlf") {
        options.NewLineCharacter = "\r\n";
    }

    return options;
}
exports.makeFormatCodeOptions = makeFormatCodeOptions;
