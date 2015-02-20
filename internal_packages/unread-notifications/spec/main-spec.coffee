_ = require 'underscore-plus'
Contact = require '../../../src/flux/models/contact'
Message = require '../../../src/flux/models/message'
Main = require '../lib/main'

describe "UnreadNotifications", ->
  beforeEach ->
    spyOn(window, 'Notification').andCallFake ->
    @msg1 = new Message
      unread: true
      from: [new Contact(name: 'Ben', email: 'ben@example.com')]
      subject: "Hello World"
    @msg2 = new Message
      unread: true
      from: [new Contact(name: 'Mark', email: 'mark@example.com')]
      subject: "Hello World 2"
    @msgRead = new Message
      unread: false
      from: [new Contact(name: 'Mark', email: 'mark@example.com')]
      subject: "Hello World Read Already"

  it "should create a Notification if there is one unread message", ->
    Main._onNewMailReceived({message: [@msgRead, @msg1]})
    expect(window.Notification).toHaveBeenCalled()
    expect(window.Notification.mostRecentCall.args).toEqual([ 'Ben', { body : 'Hello World', tag : 'unread-update' } ])

  it "should create a Notification if there is more than one unread message", ->
    Main._onNewMailReceived({message: [@msg1, @msg2, @msgRead]})
    expect(window.Notification).toHaveBeenCalled()
    expect(window.Notification.mostRecentCall.args).toEqual([ '2 Unread Messages', { tag : 'unread-update' } ])

  it "should not create a Notification if there are no new messages", ->
    Main._onNewMailReceived({message: []})
    expect(window.Notification).not.toHaveBeenCalled()
    Main._onNewMailReceived({})
    expect(window.Notification).not.toHaveBeenCalled()

  it "should not create a Notification if the new messages are not unread", ->
    Main._onNewMailReceived({message: [@msgRead]})
    expect(window.Notification).not.toHaveBeenCalled()

