ts=require("../bin/beast.testsuite.js")
TestCase=ts.TestCase



new (class ArrayTest extends TestCase
  constructor:->
    super()

  base:->
    ar0=[1,2,3]
    ar1=[1,ar0,3]
    ar2=[1,ar0,3]
    [ar1,ar2]


  testEquals:(one,two)->
    @assertEquals(one,two)

  testObject:(one,two)->
    @assertObjectEquals(one,two)
    @assertObjectEquals(one,two)
)


class Person
  constructor:(@name,@age)->



new (class ObjectTest extends TestCase
  constructor:()->
    super()

  base:->
    [new Person("tom",25),new Person("tom",25)]


  testObject:(p1,p2)->
    @assertEquals(p1,p2)

    p2.age=25
    @assertEquals(p1,p2)

  testLiteral:()->
    @assertEquals({"name":"tom",age:25},{"name":"tom",age:25})
)



new (class ArrayTest2 extends TestCase
  constructor:()->
    super()

  base:->
    array=[1,[3,2,3],3]
    array2=[1,[1,2,3],3]
    [array,array2]



  testArray:(p1,p2)->
    @assertObjectEquals(p1,p2)
)


console.log ts.TestCase.getResult()