#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @pWins = 0
    @dWins = 0
    _.bindAll @, "dealOut"
    @set 'deck', deck = new Deck()
    hand = @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    # @on 'dealOut', ->
    #   @get('dealerHand').at(0).flip()
    #   debugger
    #   @dealOut()
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
    @newHand()
    console.log("win")

  loss: ->
    @dWins++
    @newHand()
    console.log("lose")

  draw: ->
    @newHand()
    console.log("draw")

  newHand: ->
    deck = @get 'deck'
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @trigger 'newHand'

