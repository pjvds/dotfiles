var typescriptVersion = "1.0.1";

var vm = require("vm");
var fs = require("fs");

var fileName = __dirname + "/" + typescriptVersion + "/typescriptServices.js";
var typescriptServicesCode = fs.readFileSync(fileName, {encoding: "utf-8"});

var sandbox = {};
vm.runInNewContext(typescriptServicesCode, sandbox, "typescriptServices.js");
module.exports = sandbox.TypeScript;
