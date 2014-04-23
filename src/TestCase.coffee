#include TestComponent.coffee
#include TestResult.coffee

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