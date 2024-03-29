class window.HandView extends Backbone.View

  className: 'hand'

  #todo: switch to mustache
  template: _.template '<h2><% if(isDealer){ %>Dealer<% }else{ %>You<% } %> <% if(!isDealer){%>(<span class="score"></span>)<%} %></h2>'

  initialize: ->
    @collection.on 'add remove change', => @render()
    @render()
    @collection.on "hit" , =>
      @resizeCardDiv()

  render: ->
    @$el.children().detach()
    @$el.html @template @collection
    @$el.append @collection.map (card) ->
      new CardView(model: card).$el
    @$('.score').text App.prototype.bestScore(@collection.scores())
  resizeCardDiv: ->
    @$el.css('width', @collection.length * 126 + 'px')