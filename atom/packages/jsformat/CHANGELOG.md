# [0.7.8](140ace97c44f2b3343dd80a8fa34ed5437c121a2)

* Added `end_with_newline` setting.

# [0.7.7](357ee8761a801f505305fadd475a13255eb18b73)

* Fixed regression where closing a tab would throw an error

# [0.7.6](212aace57a36176386dd9891a2a23e7de712bb5f)

* Updated JS-Beautify to 1.5.4
* Better descriptions in the config page
* More tests

# [0.7.5](330b5cbc654618e142713a95c0147b0ca117fa68)

* Better config page
* More tests

# [0.7.4](b42275f887278b6df0566811056e989007cdc645)

* Fixed error in tests, all current tests should pass

# [0.7.3](edf6256095dcc340511375cb60abd369767aa279)

* Made retrieving package config simpler and faster

# [0.7.2](4df0961a82b4b3f9c6c5da41f51a0d7716520869)

* Updated JS-Beautify to 1.5.3

# [0.7.1](feec74e518a1cee789d3b3131c493e3786fecd19)

* Added support for JS-Beautify's `space_after_anon_function` option.

# [0.7.0](30d27619df09947825944d17ed3fa8bd5ea373ec)

* Switched to Atom's new v0.133.0 config schema

# [0.6.7](52339804cd2690f9d2279b1bd93ca459490d38f3)

* Fixed Observer class not being exported  
* Started working on using the Observer class

# [0.6.6](9a61e537c06e2ffe19a83a86299f2b043c89a7da)

* Moved to workspace model API to prevent deprecation warnings about workspaceView API

# [0.6.5](6c9e291b8a1c923c86973168f44412d9dcf38064)

* Cursor repositioning now works a lot better

# [0.6.4](98df7a37ad25dd059f61014efa53e9e7a7386fc6)

* Fixed error in cursor position fix

# [0.6.3](68cfca3693b1d88c584aba7a862c45ea43de3974)

* Started working spec files

# [0.6.2](ecfb6b13b58afdabb7e676d3842c2a098f6eab64)

* Updated CHANGELOG.md

# [0.6.0](958e3503d57ad9edc95cdccec57c84b025912038)

* Cursor position is now positioned more accurately by using its location before formatting the file/selection  
* Added a CHANGELOG.md file with all the versions  
* Updated README.md with `format_on_save` setting information  

# [0.3.2](fcf5a60ad6979fee7a11c5f49d3590171e7b6aa4)

* Fixed issue where closing a file would cause Atom to freeze because of extra subscribers from format on save

# [0.3.0](9583bd2e5e249e3b02e41c5237b53c6ed0f56601)

* Format on save functionality added

# [0.2.1](1d4e6c2b3242da7330149c2fbb78a8ee6c514635)

* Uses editor's tablength to format text

# [0.2.0](f7b17bb86146d8df9d354fbe70aa8304fd550f0d)

* Added the ability to format currently selected text
* Now using file's grammar (which can be manually set by user) to decide whether or not to format the selection/file

# [0.1.0](00a665c9f0f24d3841851b5fb01ecc66b7f71eeb)

* Added a lot more settings and configuration options

# [0.0.6](453f4c64fbc18df17a9c0425001878b8be3c8835)

* Fixed issue when no editors are open
* Fixed not supported view message

# [0.0.5](2ae80654323d1e5a8eeee3f1d93e75c07043f922)

* Improved the readme

# [0.0.4](39d733ffdb379b4aeb9b114015172ea5a698b7b9)

* No changes, test publish

# [0.0.3](607832d0df3a5377820e6d76910f00afa66cbbdd)

* Fixed package.json formatting

# [0.0.2](ef80454a596dca78db3eb36c5cd2766e4e3206c3)

* Added keywords to package.json to make package easier to find

# [0.0.1](d71190e08ec13bc74413db8f3cb31904d49a472c)

* Initial JSFormat plugin
