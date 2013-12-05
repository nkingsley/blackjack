#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    _.bindAll @, "dealOut"
    @pWins = 0
    @pBucks = 1000
    @currentBet = 0
    @set 'deck', deck = new Deck()
    hand = @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @bet()

  dealOut: ->
    d = @get 'dealerHand'
    dScore = @bestScore(d.scores())
    pScore = @bestScore(@get('playerHand').scores())
    
    # FIXME: if we recurse, it will turn the card back over.
    # d.at(0).flip()

    console.log(dScore, pScore);

    if dScore > 21 
      @win()
      return

    if dScore < 17 
      d.hit()
      @dealOut()
    else if dScore > pScore 
      @loss()
    else if dScore < pScore 
      @win()
    else if dScore == pScore 
      @draw()

  bestScore: (scArr)->
    if scArr[1] and scArr[1] < 22
      scArr = scArr[1]
    else
      scArr = scArr[0]

  win: ->
    @pWins++
    @pBucks += @currentBet
    @bet 'You won!'
    @newHand()
    # console.log("win")

  loss: ->
    @pBucks -= @currentBet
    if @pBucks == 0
      window.location = 'http://www.paypal.com'
      return
    @bet 'You lost!'
    @newHand()
    # console.log("lose")

  draw: ->
    @bet 'Push!'
    @newHand()
    # console.log("draw")

  newHand: ->
    deck = @get 'deck'
    if deck.length < 13
      deck = @shuffle()
      debugger
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @trigger 'newHand'

  shuffle: ->
    deck = new Deck()
    @set 'deck', deck
    deck

  bet: (msg = '')->
    @currentBet = parseInt prompt "#{msg} Place your bet. You have $#{@pBucks}"
    if parseInt(@currentBet) <= 0 or !parseInt(@currentBet)
      @bet('No bartering')
    if parseInt(@currentBet) > @pBucks
      @bet('No going into debt')
    @


