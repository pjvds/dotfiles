# include event-kit to make use of CompositeDisposable
{CompositeDisposable} = require 'event-kit'

module.exports =
class Observer
 constructor: () ->
   @subscriptions = new CompositeDisposable()

 addSubscription: (disposableSubscription) ->
   @subscriptions.add disposableSubscription

 dispose: ->
   @subscriptions.dispose() # Dispose of all subscriptions at once
