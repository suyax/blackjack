class window.Hand extends Backbone.Collection
  model: Card

  initialize: (array, @deck, @isDealer, @standStatus) ->

  hit: ->
    currentPlayer = if(@isDealer) then 'dealer'
    else 'player'
    console.log currentPlayer, 'has chosen to hit'
    console.log 'picking a new card to add'
    @add(@deck.pop())
    console.log 'sending hitRequest'
    @trigger 'hitRequest', @
    return @.last()

  stand: ->
    currentPlayer = if(@isDealer) then 'dealer'
    else 'player'
    console.log currentPlayer, 'has chosen to stand'
    @trigger 'standRequest', @

  hasAce: -> @reduce (memo, card) ->
    memo or card.get('value') is 1
  , 0

  minScore: -> @reduce (score, card) ->
    score + if card.get 'revealed' then card.get 'value' else 0
  , 0

  realScore: ->
    if !@isDealer then return @minScore()
    else
      return @minScore() + @.models[0].attributes.value

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    [@minScore(), @minScore() + 10 * @hasAce()]


