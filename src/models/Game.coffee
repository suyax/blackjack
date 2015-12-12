class window.Game extends Backbone.Model
  initialize: ->
    @startGame 
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

  startGame: ->
    @trigger 'startGame', @

  endGame: ->
    @trigger 'endGame', @

  declareWinner: ->
    @




