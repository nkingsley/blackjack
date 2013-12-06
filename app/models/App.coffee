#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    _.bindAll @, "dealOut"
    _.bindAll @, "changeCount"
    @pWins = 0
    @pBucks = 1000
    @currentBet = 0
    @set 'deck', deck = new Deck()
    @count = 0
    @get('deck').on('remove',@changeCount)
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
  changeCount: (card)->
    value = card.attributes.rank
    if value == 7 or value == 2 or value == 3
      @count++
    if value == 4 or value == 5 or value == 6
      @count += 2
    if value == 0 or value == 11 or value == 10 or value == 12
      @count -= 2
    if value == 1
      @count--
    console.log(@count)
    @
  bestScore: (scArr)->
    if scArr[1] and scArr[1] < 22
      scArr = scArr[1]
    else
      scArr = scArr[0]

  win: (blackjack)->
    @pWins++
    @pBucks += @currentBet
    if blackjack
      @pBucks += Math.ceil(@currentBet/2)
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
  newHand: (shuffle)->
    if shuffle
      deck = @shuffle()
    deck ||= @get 'deck'
    if deck.length < 13
      deck = @shuffle()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    if @get('dealerHand').at(1).attributes.rank == 1 && @currentBet*2 <= @pBucks
      @trigger('insurance?')
    if @bestScore(@get('playerHand').scores()) == 21
      @win("Blackjack!")
    @resetListeners()
  insurance: ->
    if @get('dealerHand').at(0).attributes.value == 10
      @currentBet = @currentBet*2
      @get('dealerHand').at(0).flip()
      @win()
    else
      @pBucks -= @currentBet
      @trigger('sucker')
  shuffle: ->
    deck = new Deck()
    @set 'deck', deck
    @get('deck').on('remove',@changeCount)
    @count = 0
    @trigger 'shuffle'
    deck
  resetListeners: ->
    that = @
    @get('playerHand').on "loss" , =>
      @trigger 'loss'
    @get('playerHand').on "dealOut" , =>
      @trigger 'dealOut'
    @get('playerHand').on "doubleDown", =>
      that.currentBet = that.currentBet*2
