describe "BlackJack Game!!!", ->
  app = null
  d = null
  p = null

  beforeEach ->
    app = new App()
    d = app.get 'dealerHand'
    p = app.get 'playerHand'

  it "should never let the dealer have less than 17", ->
    dS = d.scores()
    dS = app.bestScore(dS)
    app.dealOut()
    dS2 = app.bestScore(d.scores())
    debugger
    expect(dS2).toBeGreaterThan(16)
    if (dS < 17)
      expect(dS2).toBeGreaterThan(dS)
    else
      expect(dS2).toEqual(dS)
