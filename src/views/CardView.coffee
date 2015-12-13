class window.CardView extends Backbone.View
  className: 'card'

  templateRevealed: _.template '<img src=img/cards/<%= rankName %>-<%= suitName %>.png width=100px, height=100%>'

  templateCovered: _.template '<img src=img/card-back.png width=100px, height=100%>'
  
  initialize: -> @render()

  render: ->
    @$el.children().detach()
    @$el.html @templateCovered @model.attributes unless @model.get 'revealed'
    @$el.html @templateRevealed @model.attributes if @model.get 'revealed'
    @$el.addClass 'covered' unless @model.get 'revealed'

