#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    _.bindAll @, "dealOut"
    @pWins = 0
    @pBucks = 1000
    @currentBet = 0
    @set 'deck', deck = new Deck()
  dealOut: ->
    d = @get 'dealerHand'
    dScore = @bestScore(d.scores())
    pScore = @bestScore(@get('playerHand').scores())

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

  win: (blackjack)->
    @pWins++
    @pBucks += @currentBet
    if blackjack
      @pBucks += @currentBet/2
    @newBet('Win!!')

  loss: ->
    @pBucks -= @currentBet
    if @pBucks == 0
      window.location = 'http://www.paypal.com'
      return
    @newBet('loss :(')

  draw: ->
    @newBet('draw...')
  newBet: (state)->
    @trigger "newBet", state
  newHand: ->
    deck = @get 'deck'
    if deck.length < 13
      deck = @shuffle()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @trigger 'newHand'
    if @bestScore(@get('playerHand').scores()) == 21
      @win("Blackjack!")

  shuffle: ->
    deck = new Deck()
    @set 'deck', deck
    deck


