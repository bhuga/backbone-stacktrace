window.Backbone.StackTrace =
  tracer: new printStackTrace.implementation()

  maxDepth: 128
  verbose: false

  oldtrigger: Backbone.Events.trigger

  trigger: ->
    Backbone.StackTrace.stack ||= []
    stack = Backbone.StackTrace.tracer.run()
    trigger = arguments[0]

    Backbone.StackTrace.stack.push stack[3]

    if Backbone.StackTrace.verbose == true
      console.log "#{trigger}: #{stack[3]} (#{Backbone.StackTrace.stack.length})"

    if Backbone.StackTrace.stack.length >= Backbone.StackTrace.maxDepth
      _.each Backbone.StackTrace.stack, (item, index) ->
        console.log "#{trigger}: #{item} (#{index})"
      console.log "Backbone.StackTrace: stack too deep (#{Backbone.StackTrace.stack.length})"
      throw "Backbone.StackTrace: stack too deep (#{Backbone.StackTrace.stack.length})"
    else
      Backbone.StackTrace.oldtrigger.apply(@, arguments)

    Backbone.StackTrace.stack.pop()

window.Backbone.Events.trigger = Backbone.StackTrace.trigger
window.Backbone.Collection::trigger = Backbone.StackTrace.trigger
window.Backbone.Model::trigger = Backbone.StackTrace.trigger
window.Backbone.View::trigger = Backbone.StackTrace.trigger
window.Backbone.Router::trigger = Backbone.StackTrace.trigger
window.Backbone.History::trigger = Backbone.StackTrace.trigger
