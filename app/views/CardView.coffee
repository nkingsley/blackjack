class window.CardView extends Backbone.View

  className: 'card'

  # template: _.template '<%= rankName %> of <%= suitName %>'

  initialize: ->
    @model.on 'change', => @render
    @render()

  render: ->
    @$el.children().detach().end().html

    @$el.addClass @model.attributes.suitName

    if @model.get 'revealed'
      if typeof @model.attributes.rankName is 'string'
        @$el.addClass @model.attributes.rankName
        val = @model.attributes.rankName.split("")[0]
        @$el.html('<div class="topleft"><div class = "rank">'+val+'</div></div><div class="bottomright"><div class = "rank">'+val+'</div></div>')
      else
        val = @model.attributes.rankName
        @$el.html('<div class="topleft"><div class = "rank">'+val+'</div></div><div class="bottomright"><div class = "rank">'+val+'</div></div>')


    @$el.addClass 'covered' unless @model.get 'revealed'
