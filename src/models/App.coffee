# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    # @set 'playerScore', @.playerHand.minScore
    # @set 'dealerScore', @.dealHand.minScore
    @startGame()

    @get 'playerHand'
      .on 'hitRequest', @processHitRequest, @
    @get 'dealerHand'
      .on 'hitRequest', @processHitRequest, @
    @get 'playerHand'
      .on 'standRequest', @processStandRequest, @
    @get 'dealerHand'
      .on 'standRequest', @processStandRequest, @

  startGame: ->
    @trigger 'startGame', @
    console.log 'staring a new game'

  processHitRequest: (player)->
    console.log 'processing hitRequest'
    if player.realScore() < 21
      if !player.isDealer
        @.processDecisionforDealer()

    if player.realScore() > 21
      console.log 'current player has busted'
      console.log 'declaring the winner'
      @.declareWinner player, false

  processDecisionforDealer: ->
    if @.get 'dealerHand'
        .scores[0] is 17
      console.log('processing dealer\'s turn')
      @.get 'dealerHand'
        .hit()
    else
      console.log('processing dealer\'s turn')
      p = @.get 'dealerHand'
        .minScore() * (1/21)
      n = Math.random()
    #   if n <= p then @.get 'dealerHand'
    #     .stand();
      if n > p 
        @.get 'dealerHand'
        .hit()

  endGame: ->
    @trigger 'endGame', @  

  declareWinner: (player, win)->
    if win
      if player.isDealer then winner = 'dealer'
      else winner = 'player'
    if !win
      if player.isDealer then winner = 'player'
      else winner = 'dealer'

    console.log 'the winner is ...', winner



