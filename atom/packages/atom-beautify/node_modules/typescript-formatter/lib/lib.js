var formatter = require("../typescript-toolbox/lib/formatter");

var fs = require("fs");

var base = require("./provider/base");
var editorconfig = require("./provider/editorconfig");
var tslintjson = require("./provider/tslintjson");

var providers = [];

function processFiles(files, opts) {
    var result = {};
    files.forEach(function (fileName) {
        if (!fs.existsSync(fileName)) {
            console.error(fileName + " is not exists. process abort.");
            process.exit(1);
            return;
        }
        var content = fs.readFileSync(fileName).toString();

        var options = formatter.createDefaultFormatCodeOptions();
        if (opts.tsfmt) {
            providers.push(base);
        }
        if (opts.editorconfig) {
            providers.push(editorconfig);
        }
        if (opts.tslint) {
            providers.push(tslintjson);
        }
        providers.forEach(function (provider) {
            return provider.makeFormatCodeOptions(fileName, options);
        });

        var formattedCode = formatter.applyFormatterToContent(content, options);

        if (opts && opts.replace) {
            if (content !== formattedCode) {
                fs.writeFileSync(fileName, formattedCode);
                console.log("replaced " + fileName);
            }
        } else if (opts && !opts.dryRun) {
            console.log(formattedCode);
        }
        result[fileName] = {
            fileName: fileName,
            options: options,
            src: content,
            dest: formattedCode
        };
    });
    return result;
}
exports.processFiles = processFiles;
