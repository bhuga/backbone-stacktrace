Stack Traces for Backbone.Events triggers
========================================

A quick little snippet of Javascript to debug Backbone.Event.trigger stack
traces. On trigger loops, it provides a much easier to read stack trace of
calls to `trigger` as opposed to every line of JavaScript.

## Usage

Just use backbone events as normal. When you see a loop, things will be better.

    item.trigger_infinite = function() {
      this.trigger 'infinite'
    }
    item.on('infinite', function() {
      this.trigger_infinite()
    })
    item.trigger('infinite')

Instead of a browser using 100% of your processor, you'll see this in your
console:

    .... snip ....
    [object Object].trigger_infinite (file://localhost/<...>/spec/spec/Backbone.StackTraceSpec.js:40:21) 126
    [object Object].trigger_infinite (file://localhost/<...>/spec/spec/Backbone.StackTraceSpec.js:40:21) 127
    Backbone.StackTrace: stack too deep (128) 

You can set the max stack depth like so:

    window.Backbone.StackTrace.maxDepth = 256;

## Installation 

To use the stack tracer, include it after backbone. It has a single dependency,
a stack tracer, available from
<https://github.com/eriwen/javascript-stacktrace>. A copy of the stack tracer
is also available in the spec directory if you're lazy.

It's not recommended for production use. Shoot, I'm too lazy to even minify
this stuff.

    <script src=backbone-min.js></script>
    <script src="stacktrace.js"></script>
    <script src=Backbone.StackTrace.js></script>

That's it, you're done.

#### Paperwork

This is unencumbered code entered into the public domain, suitable for
copy-pasting into some other project of your own. See the attached UNLICENSE
file for more information.

Use the github page to file issues or pull requests.

Open spec/SpecRunner.html to run the tests, such as they are.
