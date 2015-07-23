chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'wit-ai', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()
      hear: sinon.spy()

    require('../src/wit-ai')(@robot)

  it 'registers a respond listener', ->
    expect(@robot.respond).to.have.been.calledWith(/hey(, | )(.*)/i)

  it 'registers a hear listener', ->
    expect(@robot.hear).to.have.been.calledWith(///hey\s+#{@robot.name}(,\s+|\s+)(.*)///i)