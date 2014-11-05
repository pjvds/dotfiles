# JsFormat

JavaScript + JSON formatting/beautification for the Atom text editor.

#### Keybinding
`ctrl+alt+f`

#### Command Palette
`Jsformat: Format`

#### Settings
JsFormat uses whatever tab/indent settings are configured with the standard ```Tab Length``` Atom settings.  

The ```Preferred Line Length``` Atom setting is only respected when the ```Soft Wrap At Preferred Line Length``` Atom setting is enabled.  

By default, JSFormat's Format on save is set to true.

The following **JsBeautifier** settings are available through the JsFormat settings panel (defaults shown below). Check out the official [jsbeautifier documentation](https://github.com/einars/js-beautify#options) for more details on the options:

* Indent with tabs: false
* End with newline: true
* Max preserve newlines: 4
* Preserve newlines: true
* Space in parentheses: false
* JSLint happy: false
* Brace style: "collapse"
* Keep array indentation: false
* Keep function indentation: false
* Space after anonymous functions: false
* Space before conditional: true
* Evaluate code: false
* Unescape strings: false
* Break Chained Methods: false
* e4x style: false
