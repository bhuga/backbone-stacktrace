window.Backbone.StackTrace =
  tracer: new printStackTrace.implementation()

  maxDepth: 128
  verbose: false

  oldtrigger: Backbone.Events.trigger

  logString: (item, depth, trigger, context) ->
    className = id = null
    if context? && context.constructor?
      matches = className = context.constructor.toString().match /function\s+(\w+)/
      className = matches[1]

    idString = if context? && context.id? then "##{context.id}" else ''

    contextString = if className? then "#{className}#{idString}: " else ''

    console.log "#{contextString} #{trigger}: #{item} (#{depth})"


  trigger: ->
    Backbone.StackTrace.stack ||= []
    stack = Backbone.StackTrace.tracer.run()
    trigger = arguments[0]

    Backbone.StackTrace.stack.push stack[3]

    if Backbone.StackTrace.verbose == true
      Backbone.StackTrace.logString stack[3], Backbone.StackTrace.stack.length, trigger, @

    if Backbone.StackTrace.stack.length >= Backbone.StackTrace.maxDepth
      _.each Backbone.StackTrace.stack, (item, index) ->
        Backbone.StackTrace.logString item, index, trigger
        #console.log "#{trigger}: #{item} (#{index})"
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
