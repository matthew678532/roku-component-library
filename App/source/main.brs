sub main(args as Object)
  screen = createObject("roSGScreen")
  scene = screen.createScene("MainScene")
  m.port = createObject("roMessagePort")
  screen.setMessagePort(m.port)
  screen.show()

  if args.runTests = "true" and TF_Utils__IsFunction(TestRunner)
    runner = TestRunner()
    runner.logger.setVerbosity(3)
    runner.logger.setEcho(false)
    runner.logger.setJUnit(false)
    runner.run()
  end if

  while true
    msg = wait(0, m.port)
    msgType = type(msg)

    if msgType = "roSGScreenEvent" then
      if msg.isScreenClosed() then
        return
      end if
    end if
  end while
end sub