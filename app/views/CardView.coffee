class window.CardView extends Backbone.View

  className: 'card'

  # template: _.template '<%= rankName %> of <%= suitName %>'

  initialize: ->
    @model.on 'change', => @render
    @render()

  render: ->
    @$el.children().detach().end().html
    # @$el.html @template @model.attributes

    @$el.addClass @model.attributes.suitName

    if typeof @model.attributes.rankName is 'string'
      @$el.addClass @model.attributes.rankName
    else
      @$el.attr 'data-value', @model.attributes.rankName

    @$el.addClass 'covered' unless @model.get 'revealed'
