class Result
  constructor:(@passed,@message)->
###
  This class is the {TestResult} of when a {TestCase} is run. This is stored inside {TestCase.result}
###
class TestResult

  ###
    @nodoc
  ###
  constructor:(@testClass,@name,@message,@result,@position)->
    @['class']=@testClass

  ###
    @property [String] The Object name that extended the TestCase Class
  ###
  testClass:null

  ###
    @property [String] The name of the method that was being tested
  ###
  name:null

  ###
    @property [String] The message from the result of the Test
  ###
  message:null

  ###
    @property [Integer] The type of the Result
    @see {TestCase.passed}, {TestCase.warning}, {TestCase.failed}
  ###
  result:null

  ###
  @property [Integer] The position of the assert Function for the specific method being tested
  ###
  position:null

if typeof module isnt "undefined"
  if typeof module.exports isnt "undefined"
    module.exports.TestResult=TestResult


class TestComponent
  constructor:()->



  _trueTest:(a)->
    unless a is true
      new Result(false,"failed to assert that #{@stringObject(a)} is true")
    else
      new Result(true,"#{@stringObject(a)} is equal to true")

  _same:(a,b)->
    if a is b
      new Result(true,"asserted that #{@stringObject(a)} is #{@stringObject(b)}")
    else
      new Result(false,"failed to assert that #{@stringObject(a)} is #{@stringObject(b)}")

  _equals:(a,b)->
    if a instanceof Array and b instanceof Array
      return @_arrayEquals(a,b)

    return @_same(a,b)

  _arrayEquals:(a,b)->
    if a.length is b.length
      for k,v of a
        unless ((result=@_equals(v,b[k])) and result.passed)
          return new Result(false,"failed to assert [#{@stringObject(a)}] is equal to [#{@stringObject(b)}] because property[#{@stringObject(k)}] is not equal")
    return new Result(true,"asserted that [#{@stringObject(a)}] is equal to [#{@stringObject(b)}]")


  _isFunction:(f)->
    if typeof f is "function"
      new Result(true,"assert that #{@stringObject(f)} is a function")
    else
      new Result(false,"failed to assert that #{@stringObject(f)} is a function")






  ###
    This method will test if the value is equal to true
    @param value [Boolean]
  ###
  assertTrue:(value)->
    result=@_trueTest(value)
    if result.passed
      TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,"passed",TestCase.passed,TestCase.testAssert++)
    else
      TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,result.message,TestCase.failed,TestCase.testAssert++)

  ###
    This will test if a value is null
    @param value [Object,String,Number,Boolean]
  ###
  assertNull:(value)->
    if value is null
      TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,"passed",TestCase.passed,TestCase.testAssert++)
    else
      TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,"failed to assert #{value} as null",TestCase.failed,TestCase.testAssert++)


  ###
  This will test if an Object is not null
  @param value [Object,String,Number,Boolean]
  ###
  assertNotNull:(value)->
    if value isnt null
      TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,"passed",TestCase.passed,TestCase.testAssert++)
    else
      TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,"failed to assert #{value} as not null",TestCase.failed,TestCase.testAssert++)



  ###
    This will test if two values are equal.
    This will do a deep Object Comparison on Objects and Arrays.
    Be careful of Objects that might contain circular references.
    The Application will handle it just fine but it will result in a warning.
    These Object will not neccesarily be equal

    @param test [Object,String,Number,Boolean]
    @param value [Object,String,Number,Boolean]
  ###
  assertEquals:(test,value)->
    if test instanceof Array and value instanceof Array
      return @assertArrayEquals(test,value)

    if test instanceof Object and value instanceof Object
      return @assertObjectEquals(test,value)

    if test is value
      TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,"passed",TestCase.passed,TestCase.testAssert++)
    else
      TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,"failed to assert \"#{test}\" equal to \"#{value}\"",TestCase.failed,TestCase.testAssert++)


  ###
    This will test if two arrays are equal. This will not do a deep object test on the array. It will only check the first level of the array
    @param array1 [Array]
    @param array2 [Array]
  ###
  assertArrayEquals:(array1,array2)->
    result=@_arrayEquals(array1,array2)
    unless result.passed
      TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,result.message,TestCase.failed,TestCase.testAssert++)
    else
      TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,result.message,TestCase.passed,TestCase.testAssert++)



  ###
    This will check if a value is a function. This can be useful with callbacks testing.
    @param func [Function]
  ###
  assertFunction:(func)->
    result=@_isFunction(func)
    if result.passed
      TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,result.message,TestCase.passed,TestCase.testAssert++)
    else
      TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,result.message,TestCase.failed,TestCase.testAssert++)





  ###
    This is essential the same as {TestCase#assertEquals}.
    This is just a more reader friendly form that is better at documenting your intention.
    @param obj1 [Object]
    @param obj2 [Object]
  ###
  assertObjectEquals:(obj1,obj2)->
    try
      result=@deepObjectCompare(obj1,obj2)
    catch e
      if e instanceof RangeError
        TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,"Warning - Object may have circular reference, may or may not be equal",TestCase.warning,TestCase.testAssert++)
        return
      else
        TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,e.message,TestCase.failed,TestCase.testAssert++)
        return
    unless result.passed
      TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,"failed to assert property[#{result.key}] is equal, \"#{result.value.test}\" not \"#{result.value.value}\"",TestCase.failed,TestCase.testAssert++)
      return
    else
      TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,"passed",TestCase.passed,TestCase.testAssert++)
      return



  ###
    @nodoc
  ###
  deepObjectCompare:(test,value)->
    result={};
    cmp=[]
    for key of test
      cmp[key]=key
    for key of value
      cmp[key]=key
    for key of cmp
      result.key=key
      result.value={"test":test[key],"value":value[key]}
      if typeof test[key] is "object" and typeof value[key] is "object"
        unless @deepObjectCompare(test[key],value[key]).passed
          result.passed=false
          return result
      else if typeof test[key] is "object" and typeof value[key] is "object"
        unless @deepObjectCompare(test[key],value[key]).passed
          result.passed=false
          return result
      else unless test[key] is value[key]
        result.passed=false
        return result
    result.passed=true
    return result



  ###
    This will test if two values are similar. This is mainly for primitive values when comparing a string and a number.
    When used on a object it is essentially the same as {TestCase#assertSame}.
    This will also ignore casing when comparing strings
    @example
      5=='5' #true
      'PizzaMan' == 'pizzaman' #true
    @param test [Object,String,Number,Boolean]
    @param value [Object,String,Number,Boolean]
  ###
  assertSimilar:(test,value)->
    if typeof test is "string" and typeof value is "string"
      if test.toLowerCase() is value.toLowerCase()
        TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,"passed",TestCase.passed,TestCase.testAssert++)
      else
        TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,"failed to assert \"#{test}\" of type [#{typeof test}] is similar to \"#{value}\" of type [#{typeof value}]",TestCase.failed,TestCase.testAssert++)
      return

    if `test == value`
      TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,"passed",TestCase.passed,TestCase.testAssert++)
    else
      TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,"failed to assert \"#{test}\" of type [#{typeof test}] is similar to \"#{value}\" of type [#{typeof value}]",TestCase.failed,TestCase.testAssert++)


  ###
    This will check if two objects are the same objects. It will also test if two primitives are equal.
    @param test [Object,String,Number,Boolean]
    @param value [Object,String,Number,Boolean]
  ###
  assertSame:(test,value)->
    if test is value
      TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,"passed",TestCase.passed,TestCase.testAssert++)
    else
      TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,"failed to assert \"#{test}\" is the exact same \"#{value}\"",TestCase.failed,TestCase.testAssert++)


  stringObject:(o)->
    str=""
    strpack=[]
    if o instanceof Array
      if o.length<10
        for element in o
          strpack.push("#{@stringObject(element)}")
        str=strpack.join(", ")
      else
        str="Array#{0}...#{o.length}"
      str="[#{str}]"
    else if o instanceof Object
      str="[#{o.constructor.name}: properties:#{o.length}]"
    else if typeof o is "string"
      str="\"#{o}\""
    else if typeof o is "number"
      str="#{o}"
    else if typeof o is "function"
      str="[#{f.name}: arguments #{f.length}]"
    else
      str="#{o.toString()}"

    return str



###
  This class provides an extremely readable testing framework for testing with CoffeeScript and Javascript in General.
  It was built using CoffeeScript.

  You must keep this header in all copy of this Source Code.
  @author Shavauhn Gabay
###
class TestCase extends TestComponent
  ready=false
  ###
    @param auto [Boolean] if set to false test will not automatically run. Test can be run with the {TestCase#run} method
    @return [TestCase]
  ###
  constructor:(@auto=true)->
    TestCase.count++
    if @auto
      @run()

  TestCase.count=0
  TestCase.result=[]

  ###
  @nodoc
  ###
  prepare:->
    for property of @
      if property is "base"
        ready=true
    for property of @
      if property is "reset" and typeof @[reset] is "function"
          ready= ready and true
  ###
    This method is used to run the Test. The test will be executed and the results will be stored inside {TestCase.result} array.
  ###
  run:->
    if typeof TestCase.start_t is "undefined"
      TestCase.start_t= Date.now()
    else
      TestCase.start_t= Math.min(Date.now(),TestCase.start_t)

    @prepare()
    if not ready
      return

    for property of @
      if (property[0..4]).toLowerCase() is "_test" or (property[0..3]).toLowerCase() is "test"
        TestCase.testAssert=1
        TestCase.currentClassName=@.constructor.name
        TestCase.currentName=property

        try
          @base()
        catch e
          TestCase.result.push new TestResult(TestCase.currentClassName,"base","Exception #{e.constructor.name}: #{e.message}",TestCase.failed,0)
          break;

        try
          if @base() instanceof Array
            @[property].apply(@,@base())
          else
            @[property].call(@,@base())
        catch e
          if e instanceof RangeError
            TestCase.result.push new TestResult(TestCase.currentClassName,TestCase.currentName,"Exception #{e.constructor.name}: #{e.message}",TestCase.failed,TestCase.testAssert)
          else
            throw e
          continue

    TestCase.end_t=Date.now()

  ###
    This will symbolize that a test has passed
  ###
  @passed = 1

  ###
    This will symbolize that a test has passed but with a warning
  ###
  @warning = 0

  ###
    This will symbolize that a test has failed
  ###
  @failed = (-1)

  ###
    This can be used to get the HTML Summary of the Results
    @return [String]
  ###
  @getHTMLResult=->
    TestCase.nl="<br/>"
    TestCase.tab="&nbsp;&nbsp;&nbsp;"
    TestCase.print()

  ###
    This will get the result but without any HTML code inside the string
    @return [String]
  ###
  @getResult=->
    TestCase.nl="\n"
    TestCase.tab="\t"
    TestCase.print()

  ###
   This is used in the print format of {TestCase.getResult} and {TestCase.getHTMLResult}. This value is overwritten each time those functions are run. If you want to add your own spacing for need to overwrite and then call {TestCase.print}
  ###
  @nl="\n"

  ###
   This is used in the print format of {TestCase.getResult} and {TestCase.getHTMLResult}. This value is overwritten each time those functions are run. If you want to add your own spacing for need to overwrite and then call {TestCase.print}
  ###
  @tab="\t"


  ###
    This will contain all of the results, after a test has been run
  ###
  @result=[]

  ###
   You can create your own custom print by overwriting {TestCase.format} and changing the {TestCase.nl} and {TestCase.tab} and calling {TestCase.print}
  ###
  @print=->
    failCount=0
    warningCount=0
    passedCount=0
    string=""
    for result in TestCase.result
      if result.result is TestCase.passed
        passedCount++
      else if result.result is TestCase.warning
        warningCount++
        string+=TestCase.format(result)
      else if result.result is TestCase.failed
        failCount++
        string+=TestCase.format(result)

    TestCase.total_t=TestCase.end_t-TestCase.start_t
    TestCase.seconds= parseInt(TestCase.total_t/1000)
    TestCase.ms= TestCase.total_t % 1000
    string+="Test Complete #{passedCount}/#{TestCase.result.length} passed, #{warningCount}/#{TestCase.result.length} warnings, #{failCount}/#{TestCase.result.length} failed#{TestCase.nl}Total time #{TestCase.seconds}s #{TestCase.ms}ms"

  ###
    This method is used to format the code that is generated from the results. You can override this method to create a different format if you want to.
    @param result [TestResult]
    @return [String]
  ###
  @format=(result)->
    nl=TestCase.nl
    tab=TestCase.tab
    if result.result is TestCase.passed
      return ""
    else if result.result is TestCase.warning
      return "#{result.class}@#{result.name}#{nl}#{tab}#{result.message}, on assert # #{result.position}#{nl}#{nl}"
    else if result.result is TestCase.failed
      return "#{result.class}@#{result.name}#{nl}#{tab}#{result.message}, on assert # #{result.position}#{nl}#{nl}"

if typeof module isnt "undefined"
  if typeof module.exports isnt "undefined"
    module.exports.TestCase=TestCase
