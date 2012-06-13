jasmine.Matchers::toThrowMessageMatching = (expected) ->
  if typeof @actual != 'function'
    throw new Error('Actual is not a function')

  error = result = null
  try
    @actual()
  catch e
    error = e

  if error?
    if error.message?
      result = error.message.match(expected)?
    else
      result = error.match(expected)?


  n = if @isNot then "not " else ""

  if !result
    if error?
      @message = -> ("Expected function " + n + "to throw a message matching #{expected}, was '#{error}'")
    else
      @message = -> ("Expected function to throw an exception.")

  result


describe 'Backbone.StackTrace', ->
  beforeEach ->
    @item = new Backbone.Model
    @item.trigger_infinite = ->
      @trigger 'infinite'

    @item.on 'infinite', ->
      @trigger_infinite()

    @item.spy = ->

    @item.on 'works', ->
      @spy()

  it 'should exist', ->
    expect(window.Backbone.StackTrace?).toEqual true

  it 'should allow triggers to keep working', ->
    spyOn @item, 'spy'
    @item.trigger 'works'
    expect(@item.spy).toHaveBeenCalled()

  it 'should raise an error for an infinite trigger loop', ->
    item = @item
    expect( ->
      item.trigger 'infinite'
    ).toThrowMessageMatching(/Backbone.StackTrace/)

