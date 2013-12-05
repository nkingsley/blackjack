class window.AppView extends Backbone.View

  template: _.template '
    
    <div class="dealer-hand-container"></div>
    <div class="buttons"><button class="hit-button">Hit</button><button class="stand-button">Stand</button></div>
    <div class="player-hand-container"></div>
    <div class="player-wins"></div>
  '

  events:
    "click .hit-button": -> @model.get('playerHand').hit()
    "click .stand-button": -> @model.get('playerHand').stand()

  initialize: -> 
    @render()
    @model.get('playerHand').on "dealOut" , =>
      @dealOut()
    @model.on 'newHand', =>
      @render()
    @model.get('playerHand').on "loss" , =>
      @loss()
  render: ->
    @$el.children().detach()
    @$el.html @template()
    # @$('.player-wins').html @model.pWins
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
  loss: ->
    @model.loss()
    @resetListeners()

  dealOut: ->
    @model.get('dealerHand').at(0).flip()
    @model.dealOut()
    @resetListeners()
  #new hands are entirely new objects, needing new listeners
  resetListeners: ->
    @model.get('playerHand').on "loss" , =>
      @loss()
    @model.get('playerHand').on "dealOut" , =>
      @dealOut()