# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    @set 'playerStand', false
    @set 'dealerStand', false
    @set 'gameActive', true 
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
    console.log 'starting a new game'

  processHitRequest: (player)->
    if @get 'gameActive'
      currentPlayer = if player.isDealer then 'dealer'
      else 'player'

      if !player.isDealer and @get 'playerStand'
        console.log currentPlayer, ' has chosen to stand and cannot play this turn'
        return 
      console.log 'processing hitRequest for',currentPlayer
      if player.realScore() == 21
        @.declareWinner player, true

      if player.realScore() < 21
        if !player.isDealer or @get('playerStand')
          @.processDecisionforDealer()

      if player.realScore() > 21
        console.log  currentPlayer,'has busted'
        console.log 'declaring the winner'
        @.declareWinner player, false

  processStandRequest: (player)->
    if @get 'gameActive'
      currentPlayer = if player.isDealer then 'dealer'
      else 'player'
      console.log 'processing standRequest for',currentPlayer

      if player.isDealer
        @set 'dealerStand', true
        console.log 'dealer\'s play is over'
      else 
        @set 'playerStand', true
        console.log 'player\'s play is over'
        @processDecisionforDealer()
      if @get 'gameActive'
        if @get('dealerStand') and @get('playerStand')
            console.log 'both players have chosen to stand so comparing their scores'          
            playerScore = @get 'playerHand'
              .realScore()
            dealerScore = @get 'dealerHand'
              .realScore()
            if playerScore > dealerScore then winner = @.get 'playerHand'
            if dealerScore > playerScore then winner = @.get 'dealerHand'
            if dealerScore == playerScore then return @declareTie()
            @declareWinner winner, true
          # else winner = 'none. it\'s a tie!'

  processDecisionforDealer: ->
    if @get 'gameActive'
      if @.get 'dealerStand'
        console.log 'dealer has chosen to stand and is not playing this turn'
        return
      if @.get 'dealerHand'
          .scores[0] is 17
        console.log 'processing dealer\'s turn'
        @.get 'dealerHand'
          .hit()
      else
        console.log 'processing dealer\'s turn'
        p = @.get 'dealerHand'
          .minScore() * (1/21)
        n = Math.random()
        if n <= p 
          @.get 'dealerHand'
          .stand();
        if n > p 
          @.get 'dealerHand'
          .hit()

  declareWinner: (player, win)->
    if @get 'gameActive'
      @.get 'dealerHand'
        .models[0].flip();
      if win
        if player.isDealer then winner = 'dealer'
        else winner = 'player'
      if !win
        if player.isDealer then winner = 'player'
        else winner = 'dealer'
      @set 'gameActive', false


    # alert 'the winner is...' + winner
      console.log 'the winner is ...', winner

  declareTie: ->
    if @get 'gameActive'
      console.log 'it\'s a tie'
      @set 'gameActive', false

