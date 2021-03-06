// Generated by CoffeeScript 1.7.1
(function() {
  var ArrayTest, ArrayTest2, ArrayTest3, ObjectTest, Person, TestCase, ts,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  ts = require("../bin/beast.testsuite.js");

  TestCase = ts.TestCase;

  new (ArrayTest = (function(_super) {
    __extends(ArrayTest, _super);

    function ArrayTest() {
      ArrayTest.__super__.constructor.call(this);
    }

    ArrayTest.prototype.base = function() {
      var ar0, ar1, ar2;
      ar0 = [1, 2, 3];
      ar1 = [1, ar0, 3];
      ar2 = [1, ar0, 3];
      return [ar1, ar2];
    };

    ArrayTest.prototype.testEquals = function(one, two) {
      return this.assertEquals(one, two);
    };

    ArrayTest.prototype.testObject = function(one, two) {
      this.assertObjectEquals(one, two);
      return this.assertObjectEquals(one, two);
    };

    return ArrayTest;

  })(TestCase));

  Person = (function() {
    function Person(name, age) {
      this.name = name;
      this.age = age;
    }

    return Person;

  })();

  new (ObjectTest = (function(_super) {
    __extends(ObjectTest, _super);

    function ObjectTest() {
      ObjectTest.__super__.constructor.call(this);
    }

    ObjectTest.prototype.base = function() {
      return [new Person("tom", 25), new Person("tom", 25)];
    };

    ObjectTest.prototype.testObject = function(p1, p2) {
      this.assertEquals(p1, p2);
      p2.age = 25;
      return this.assertEquals(p1, p2);
    };

    ObjectTest.prototype.testLiteral = function() {
      return this.assertEquals({
        "name": "tom",
        age: 25
      }, {
        "name": "tom",
        age: 25
      });
    };

    return ObjectTest;

  })(TestCase));

  new (ArrayTest2 = (function(_super) {
    __extends(ArrayTest2, _super);

    function ArrayTest2() {
      ArrayTest2.__super__.constructor.call(this);
    }

    ArrayTest2.prototype.base = function() {
      var array, array2;
      array = [1, [3, 2, 3], 3];
      array2 = [1, [1, 2, 3], 3];
      return [array, array2];
    };

    ArrayTest2.prototype.testArrayAsObject = function(p1, p2) {
      return this.assertObjectEquals(p1, p2);
    };

    return ArrayTest2;

  })(TestCase));

  new (ArrayTest3 = (function(_super) {
    __extends(ArrayTest3, _super);

    function ArrayTest3() {
      ArrayTest3.__super__.constructor.call(this);
    }

    ArrayTest3.prototype.base = function() {
      var array, array2;
      array = [1, [3, 2, 3], 3];
      array2 = [1, [1, 2, 3], 3];
      return [array, array2];
    };

    ArrayTest3.prototype.testArrayAsArray = function(p1, p2) {
      return this.assertArrayEquals(p1, p2);
    };

    return ArrayTest3;

  })(TestCase));

  console.log(ts.TestCase.getResult());

}).call(this);
