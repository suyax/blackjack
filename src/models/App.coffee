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

  startGame: ->
    @trigger 'startGame', @
    console.log 'staring a new game'

  processHitRequest: (player)->
    console.log 'processing hitRequest'
    if player.minScore() < 21
      if !player.isDealer
        console.log 'requesting processing dealer\'s turn'
        @.processDecisionforDealer()

    if player.minScore() > 21
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
      console.log(p, n)
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



