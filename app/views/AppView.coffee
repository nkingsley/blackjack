class window.AppView extends Backbone.View

  template: _.template '
    
    <div class="dealer-hand-container"></div>
    <div class="buttons" style = "display:none"><button class="hit-button">Hit</button><button class="stand-button" >Stand</button></div>
    <div class = "betArea">Bet:<span class = "betAmount">$1</span> Chips:<span class = "pBucks">$1000</span><button class ="bet">Bet</button><input type="range" class = "betSlider" name="betSlider" min="1" max="1000" value = "1"></div>
    <div class="player-hand-container"></div>
    <div class="player-wins"></div>
  '

  events:
    "click .hit-button": -> @model.get('playerHand').hit()
    "click .stand-button": -> @model.get('playerHand').stand()
    "change .betSlider": "changeBet"
    "click .bet" : "placeBet"

  initialize: -> 
    @render()
    @model.on "newBet" , (state)=>
      @newBet(state)
  render: ->
    @$el.children().detach()
    @$el.html @template()
    if @model.get 'playerHand'
      @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
      @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
  placeBet: ->
    @model.currentBet = parseInt(@$('.betSlider').val())
    @model.newHand()
    @resetListeners()
    @render()
    @$('.betArea').toggle()
    @$('.buttons').toggle()
  newBet: (state)->
    @$('.buttons').html('<span style = "font-size:40px">'+state+'</span>')
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
    @model.get('dealerHand').at(0).flip()
    @model.dealOut()
  changeBet: (e)->
    @$('.betAmount').text('$' + e.target.value)
  #new hands are entirely new objects, needing new listeners
  resetListeners: ->
    @model.get('playerHand').on "loss" , =>
      @loss()
    @model.get('playerHand').on "dealOut" , =>
      @dealOut()