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


if typeof module.exports isnt "undefined"
  module.exports.TestResult=TestResult