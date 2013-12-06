class window.AppView extends Backbone.View

  template: _.template '
    
    <div class="dealer-hand-container"></div>
    <div class="buttons" style = "display:none">
      <button class="insurance-button">Insurance</button>
      <button class="double-button">Double</button>
      <button class="hit-button">Hit</button>
      <button class="stand-button" >Stand</button>
    </div>
    <div class = "betArea">
      Bet:<span class = "betAmount">$1</span> 
      Chips:<span class = "pBucks">$1000</span>
      <button class ="bet">Bet</button>
      <input type="range" class = "betSlider" name="betSlider" min="1" max="1000" value = "1">
    </div>
    <div class="player-hand-container"></div>
    <div class = "countDiv">Count:<div class = "count"></div></div>
    <div class = "flash"></div>
  '

  events:
    "click .hit-button": -> @model.get('playerHand').hit()
    "click .stand-button": -> @model.get('playerHand').stand()
    "change .betSlider": "changeBet"
    "click .bet" : "placeBet"
    "click .double-button" : -> @model.get('playerHand').doubleDown()
    "click .insurance-button": -> @model.insurance()

  initialize: -> 
    @render()
    @model.on "newBet" , (state)=>
      @newBet(state)
    @model.on "loss", =>
      @loss()
    @model.on "dealOut", =>
      @dealOut()
    # @model.on "shuffle", =>
      # @$()
    @model.on "insurance?", =>
      @insurance = true
    @model.on "sucker", =>
      @flash('No Dealer BlackJack.')
      $('.insurance-button').hide()
  render: ->
    @$el.children().detach()
    @$el.html @template()
    if @model.get 'playerHand'
      @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
      @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
    $('.count').html(@model.count)
  placeBet: ->
    @model.currentBet = parseInt(@$('.betSlider').val())
    @model.newHand()
    @render()
    @$('.betArea').toggle()
    @$('.buttons').toggle()
    if (@model.currentBet*2 > @model.pBucks)
      @$('.double-button').hide()
    if (@insurance)
      $('.insurance-button').show()
    else
      @$('.insurance-button').hide()
  newBet: (state)->
    @$('.buttons').html('')
    @flash(state)
    setTimeout( =>
      @render()
      @$('.player-hand-container').html('')
      @$('.dealer-hand-container').html('')
      @$('.betSlider').attr('max',@model.pBucks)
      @$('.pBucks').text('$' + @model.pBucks)
      @$('.betArea').fadeIn('slow') 
      @$('.buttons').fadeOut('slow')
    ,2000);
  loss: ->
    @model.loss()
  dealOut: ->
    @insurance = false
    @model.get('dealerHand').at(0).flip()
    @model.dealOut()
  changeBet: (e)->
    @$('.betAmount').text('$' + e.target.value)
  flash: (message) ->
    $f = @$('.flash')
    $f.text(message).fadeIn('slow')
    setTimeout ->
      $f.fadeOut('slow').text('')
    , 4000
  #new hands are entirely new objects, needing new listeners