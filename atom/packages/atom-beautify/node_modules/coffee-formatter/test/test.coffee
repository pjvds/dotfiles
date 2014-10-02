# The test suite should be run with Mocha.

# To install Mocha:

#     sudo npm install mocha -g

# Then run `mocha` in the base directory.

formatter = require '../formatter'
assert = require 'assert'

describe 'formatter', ->
describe '#shortenSpaces()', ->
  it 'should shorten all consecutive spaces into one', ->
    originalLine = 'hello   derek how is  it going?'
    formattedLine = formatter.shortenSpaces originalLine
    assert.strictEqual 'hello derek how is it going?',
      formattedLine

  it 'should work with strings', ->
    originalLine = 'for c, i in "Hello  World!"'
    formattedLine = formatter.shortenSpaces originalLine
    assert.strictEqual originalLine,
      formattedLine

  it 'should not shorten indentations', ->
    originalLine = '    for c, i  in "Hello  World"'
    formattedLine = formatter.shortenSpaces originalLine
    assert.strictEqual '    for c, i in "Hello  World"',
      formattedLine

describe '#formatTwoSpaceOperator()', ->
  it 'should make it so that there is only
    one space before and after a binary operator', ->
    originalLine = 'k = 1+1-  2>=3<=  4>5   <6'
    formattedLine = formatter.formatTwoSpaceOperator originalLine
    assert.strictEqual 'k = 1 + 1 - 2 >= 3 <= 4 > 5 < 6',
      formattedLine

describe '#formatOneSpaceOperator()', ->
  it 'should make it so that there is only
    one space after certain operators', ->
    originalLine = 'k = (a,b)-> if b?  return a'
    formattedLine = formatter.formatOneSpaceOperator originalLine
    assert.strictEqual 'k = (a, b) -> if b? return a',
      formattedLine

  it 'should make it so that there is no space between ")["', ->
    originalLine = 'f  =  b()[0]'
    formattedLine = formatter.formatOneSpaceOperator originalLine
    assert.strictEqual 'f = b()[0]',
      formattedLine

  it 'should make it so that there is no space between "))"', ->
    originalLine = 'f(b())'
    formattedLine = formatter.formatOneSpaceOperator originalLine
    assert.strictEqual 'f(b())',
      formattedLine

describe '#notInStringOrComment()', ->
  it 'should detect if a char is in a string', ->
    originalLine = 'for c, i in "Hello World"'
    inStringIndex = originalLine.indexOf('Hello')
    # console.log inStringIndex
    assert.strictEqual (formatter.notInStringOrComment inStringIndex, originalLine) ,
      false
