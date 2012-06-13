(function() {

  jasmine.Matchers.prototype.toThrowMessageMatching = function(expected) {
    var error, n, result;
    if (typeof this.actual !== 'function') {
      throw new Error('Actual is not a function');
    }
    error = result = null;
    try {
      this.actual();
    } catch (e) {
      error = e;
    }
    if (error != null) {
      if (error.message != null) {
        result = error.message.match(expected) != null;
      } else {
        result = error.match(expected) != null;
      }
    }
    n = this.isNot ? "not " : "";
    if (!result) {
      if (error != null) {
        this.message = function() {
          return "Expected function " + n + ("to throw a message matching " + expected + ", was '" + error + "'");
        };
      } else {
        this.message = function() {
          return "Expected function to throw an exception.";
        };
      }
    }
    return result;
  };

  describe('Backbone.StackTrace', function() {
    beforeEach(function() {
      this.item = new Backbone.Model;
      this.item.trigger_infinite = function() {
        return this.trigger('infinite');
      };
      this.item.on('infinite', function() {
        return this.trigger_infinite();
      });
      this.item.spy = function() {};
      return this.item.on('works', function() {
        return this.spy();
      });
    });
    it('should exist', function() {
      return expect(window.Backbone.StackTrace != null).toEqual(true);
    });
    it('should allow triggers to keep working', function() {
      spyOn(this.item, 'spy');
      this.item.trigger('works');
      return expect(this.item.spy).toHaveBeenCalled();
    });
    return it('should raise an error for an infinite trigger loop', function() {
      var item;
      item = this.item;
      return expect(function() {
        return item.trigger('infinite');
      }).toThrowMessageMatching(/Backbone.StackTrace/);
    });
  });

}).call(this);
