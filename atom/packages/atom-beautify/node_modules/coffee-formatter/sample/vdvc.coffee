# Adopted from: https://github.com/dansdom/extend
# Translated using js2coffee

extend = ->
  options = undefined
  name = undefined
  src = undefined
  copy = undefined
  copyIsArray = undefined
  clone = undefined
  target = arguments[0] or {}
  i = 1
  length = arguments.length
  deep = false
  objectHelper =

    # helper which replicates the jquery internal functions
    hasOwn: Object::hasOwnProperty
    class2type: {}
    type: (obj) ->
      (if not obj? then String(obj) else objectHelper.class2type[Object::toString.call(obj) ] or "object")

    isPlainObject: (obj) ->
      return false if not obj or objectHelper.type(obj) isnt "object" or obj.nodeType or objectHelper.isWindow(obj)
      try
        return false if obj.constructor and not objectHelper.hasOwn.call(obj, "constructor") and not objectHelper.hasOwn.call(obj.constructor::, "isPrototypeOf")
      catch e
        return false
      key = undefined
      for key of obj
        {}

      key is `undefined` or objectHelper.hasOwn.call(obj, key)

    isArray: Array.isArray or (obj) ->
      objectHelper.type(obj) is "array"

    isFunction: (obj) ->
      objectHelper.type(obj) is "function"

    isWindow: (obj) ->
      obj? and obj is obj.window

  # end of objectHelper

  # Handle a deep copy situation
  if typeof target is "boolean"
    deep = target
    target = arguments[1] or {}

    # skip the boolean and the target
    i = 2

  # Handle case when target is a string or something (possible in deep copy)
  target = {} if typeof target isnt "object" and not objectHelper.isFunction(target)

  # If no second argument is used then this can extend an object that is using this method
  if length is i
    target = this
    --i
  while i < length

    # Only deal with non-null/undefined values
    if (options = arguments[i])?

      # extend the base object
      for name of options
        src = target[name]
        copy = options[name]

        # Prevent never-ending loop
        continue if target is copy

        # Recurse if we're merging plain objects or arrays
        if deep and copy and (objectHelper.isPlainObject(copy) or (copyIsArray = objectHelper.isArray(copy) ) )
          if copyIsArray
            copyIsArray = false
            clone = (if src and objectHelper.isArray(src) then src else [])
          else
            clone = (if src and objectHelper.isPlainObject(src) then src else {} )

          # Never move original objects, clone them
          target[name] = extend(deep, clone, copy)

        # Don't bring in undefined values
        else target[name] = copy if copy isnt `undefined`
    i++

  # Return the modified object
  target

class Manager
  constructor: () ->
    # Private fields
    next_id = 0

    # Temporary buffer for holding
    # added but not commited objects
    buffer = {}

    # Storing all tracked objects
    store = {}

    # Private methods
    getObjectArr = (obj) ->
      return store[objectId(obj) ]

    objectId = (obj) ->
      if not obj?
        return null
      else
        if not obj.__id?
          obj.__id = next_id++
        return obj.__id

    # Privileged methods

    # Delete two properties from the given object:
    # `__id` and `__commitId`.  These two properties
    # are appened to the object by VDVC.
    @makeClean = (obj) ->
      delete obj.__id
      delete obj.__commitId

    # Return a deeply cloned copy of the given object
    @clone = (obj) ->
      return extend(true, {} , obj)

    # Add objects to be ready for commit
    @add = (objects...) ->
      for obj in objects
        buffer[objectId(obj) ] = @clone(obj)

    # Commit all changes
    @commit = () ->
      for key, value of buffer
        if store[key]?
          store[key].push(value)
        else
          store[key] = [value]
        value.__commitId = store[key].length - 1
      buffer = {}

    # Return the previous commit
    @prev = (obj) ->
      objectArr = getObjectArr obj
      if objectArr
        if obj.__commitId?
          if obj.__commitId == 0
            throw "It's already the earliest version"
          else
            return objectArr[obj.__commitId - 1]
        else
          # If no commitId, then it's the latest version
          # Second to last element would be the previous version
          return objectArr[objectArr.length - 2]
      else
        throw "Object not versioned"

    # Return the next commit
    @next = (obj) ->
      objectArr = getObjectArr obj
      if objectArr
        if not obj.__commitId? or obj.__commitId == objectArr.length - 1
          throw "It's already the latest version"
        else
          return objectArr[obj.__commitId + 1]
      else
        throw "Object not versioned"

    # Cancel uncommitted but added changes
    @reset = () ->
      buffer = {}

    # Return to a particular commit
    @getVersion = (obj, commitId) ->
      objectArr = getObjectArr obj
      if 0 <= commitId < objectArr.length
        return objectArr[commitId]
      else
        throw "Invalid commit id"

    # Has the same effect as `getVersion()`, except that it will
    # return a clean version that will actually be
    # deeply equal to the previous version.  However,
    # if you version the returned object again, it
    # will be treated as a new object.  The returned object
    # also won't work with prev or next.
    # When in doubt, you should just use `getVersion()`
    @getCleanVersion = (obj, commitId) ->
      anotherObj = @getVersion obj, commitId
      makeClean(anotherObj)
      return anotherObj

module.exports.new = () ->
