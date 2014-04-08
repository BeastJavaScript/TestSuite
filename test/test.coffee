ts=require("../bin/beast.testsuite.js")
TestCase=ts.TestCase



new (class ArrayTest extends TestCase
  constructor:->
    super()

  base:->
    ar1=[1,[1,2,3],3]
    ar2=[1,[1,2,3],3]
    [ar1,ar2]


  testEquals:(one,two)->
    @assertEquals(one,two)
    @assertEquals(new slkdfsldfkj,two)

  testObject:(one,two)->
    @assertObjectEquals(one,two)
)


class Person
  constructor:(@name,@age)->



new class ObjectTest extends TestCase
  constructor:()->
    super()

  base:->
    [new Person("tom",25),new Person("tom",25)]


  testObject:(p1,p2)->
    @assertEquals(p1,p2)

    p2.age=26
    @assertEquals(p1,p2)

console.log ts.TestCase.getResult()