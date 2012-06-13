(function() {

  window.Backbone.StackTrace = {
    tracer: new printStackTrace.implementation(),
    maxDepth: 128,
    verbose: false,
    oldtrigger: Backbone.Events.trigger,
    trigger: function() {
      var stack, trigger, _base;
      (_base = Backbone.StackTrace).stack || (_base.stack = []);
      stack = Backbone.StackTrace.tracer.run();
      trigger = arguments[0];
      Backbone.StackTrace.stack.push(stack[3]);
      if (Backbone.StackTrace.verbose === true) {
        console.log("" + trigger + ": " + stack[3] + " (" + Backbone.StackTrace.stack.length + ")");
      }
      if (Backbone.StackTrace.stack.length >= Backbone.StackTrace.maxDepth) {
        _.each(Backbone.StackTrace.stack, function(item, index) {
          return console.log("" + trigger + ": " + item + " (" + index + ")");
        });
        console.log("Backbone.StackTrace: stack too deep (" + Backbone.StackTrace.stack.length + ")");
        throw "Backbone.StackTrace: stack too deep (" + Backbone.StackTrace.stack.length + ")";
      } else {
        Backbone.StackTrace.oldtrigger.apply(this, arguments);
      }
      return Backbone.StackTrace.stack.pop();
    }
  };

  window.Backbone.Events.trigger = Backbone.StackTrace.trigger;

  window.Backbone.Collection.prototype.trigger = Backbone.StackTrace.trigger;

  window.Backbone.Model.prototype.trigger = Backbone.StackTrace.trigger;

  window.Backbone.View.prototype.trigger = Backbone.StackTrace.trigger;

  window.Backbone.Router.prototype.trigger = Backbone.StackTrace.trigger;

  window.Backbone.History.prototype.trigger = Backbone.StackTrace.trigger;

}).call(this);
