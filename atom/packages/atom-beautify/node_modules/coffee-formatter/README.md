# Coffee-Formatter

A formatter for CoffeeScript

## Status

The first version of this project is completed.  I will publish it on npm ASAP.

## Usage

	node formatter.js [Your Files]

Or if you want to use `coffee`

	coffee formatter.litcoffee [Your Files]

Example:

	coffee formatter.litcoffee sample/vdvc.coffee

## Things to note

This project is written in Literate CoffeeScript (extension '.litcoffee'), which isn't syntax-highlighted by Github at this moment.

To read the code, it's suggested to go to `docs/` folder.  For example, `docs/formatter.html` contains properly highlighted code for `formatter.litcoffee`.

To run the test suite, install [Mocha](https://github.com/visionmedia/mocha) and run `mocha` in the base directory.

## TODO

1. Get rid of external dependencies.
2. Make a build script.


## License

[WTFPL](http://www.wtfpl.net/about/).
