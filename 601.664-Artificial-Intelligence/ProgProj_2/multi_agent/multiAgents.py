# multiAgents.py
# --------------
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
# 
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).


from util import manhattanDistance
from game import Directions
import random, util
import sys
from game import Agent
import random
#print(sys.getrecursionlimit())
sys.setrecursionlimit(10000)

class ReflexAgent(Agent):
    """
      A reflex agent chooses an action at each choice point by examining
      its alternatives via a state evaluation function.

      The code below is provided as a guide.  You are welcome to change
      it in any way you see fit, so long as you don't touch our method
      headers.
    """

    def getAction(self, gameState):
        """
        You do not need to change this method, but you're welcome to.

        getAction chooses among the best options according to the evaluation function.

        Just like in the previous project, getAction takes a GameState and returns
        some Directions.X for some X in the set {North, South, West, East, Stop}
        """
        # Collect legal moves and successor states
        legalMoves = gameState.getLegalActions()

        # Choose one of the best actions
        scores = [self.evaluationFunction(gameState, action) for action in legalMoves]
        bestScore = max(scores)
        bestIndices = [index for index in range(len(scores)) if scores[index] == bestScore]
        chosenIndex = random.choice(bestIndices) # Pick randomly among the best

        "Add more of your code here if you want to"

        return legalMoves[chosenIndex]

    def evaluationFunction(self, currentGameState, action):
        """
        Design a better evaluation function here.

        The evaluation function takes in the current and proposed successor
        GameStates (pacman.py) and returns a number, where higher numbers are better.

        The code below extracts some useful information from the state, like the
        remaining food (newFood) and Pacman position after moving (newPos).
        newScaredTimes holds the number of moves that each ghost will remain
        scared because of Pacman having eaten a power pellet.

        Print out these variables to see what you're getting, then combine them
        to create a masterful evaluation function.
        """
        # Useful information you can extract from a GameState (pacman.py)
        successorGameState = currentGameState.generatePacmanSuccessor(action)
        newPos = successorGameState.getPacmanPosition()
        newFood = successorGameState.getFood()
        newGhostStates = successorGameState.getGhostStates()
        newScaredTimes = [ghostState.scaredTimer for ghostState in newGhostStates]

        "*** YOUR CODE HERE ***"
        ghostscore = 0
        foodscore = 0
        ghostPos = []
        for i in range(len(newGhostStates)):
            ghostPos.append(successorGameState.getGhostPosition(i+1))
        x,y = newPos
        dist = []
        for pos in ghostPos:
            dist.append(manhattanDistance((x,y),pos))
        ghostdist = min(dist)

        if ghostdist !=0 and ghostdist < 4:
            ghostscore = - 2/ ghostdist
        else:
            ghostscore = 0

        foodlist = newFood.asList()

        if ghostdist > 3 and len(foodlist)>0:
            dist = []
            for pos in foodlist:
                dist.append(manhattanDistance((x, y), pos))
            bestfood = min(dist)
            foodscore = 1/ bestfood
        else:
            foodscore = 0

        return successorGameState.getScore() + ghostscore + foodscore


        #return successorGameState.getScore()

def scoreEvaluationFunction(currentGameState):
    """
      This default evaluation function just returns the score of the state.
      The score is the same one displayed in the Pacman GUI.

      This evaluation function is meant for use with adversarial search agents
      (not reflex agents).
    """
    return currentGameState.getScore()

class MultiAgentSearchAgent(Agent):
    """
      This class provides some common elements to all of your
      multi-agent searchers.  Any methods defined here will be available
      to the MinimaxPacmanAgent, AlphaBetaPacmanAgent & ExpectimaxPacmanAgent.

      You *do not* need to make any changes here, but you can if you want to
      add functionality to all your adversarial search agents.  Please do not
      remove anything, however.

      Note: this is an abstract class: one that should not be instantiated.  It's
      only partially specified, and designed to be extended.  Agent (game.py)
      is another abstract class.
    """

    def __init__(self, evalFn = 'scoreEvaluationFunction', depth = '2'):
        self.index = 0 # Pacman is always agent index 0
        self.evaluationFunction = util.lookup(evalFn, globals())
        self.depth = int(depth)

class MinimaxAgent(MultiAgentSearchAgent):
    """
      Your minimax agent (question 2)
    """

    def getAction(self, gameState):
        """
          Returns the minimax action from the current gameState using self.depth
          and self.evaluationFunction.

          Here are some method calls that might be useful when implementing minimax.

          gameState.getLegalActions(agentIndex):
            Returns a list of legal actions for an agent
            agentIndex=0 means Pacman, ghosts are >= 1

          gameState.generateSuccessor(agentIndex, action):
            Returns the successor game state after an agent takes an action

          gameState.getNumAgents():
            Returns the total number of agents in the game

          gamState.isWin():
            Returns whether or not the gameState is a wining state
          gamState.isLose():
            Returns whether or not the gameState is a losing state
        """
        "*** YOUR CODE HERE ***"

        def max_value(agentIndex, gameState, depth):
            if depth == self.depth or gameState.isWin() or gameState.isLose():
                return self.evaluationFunction(gameState)
            alpha = -1e20
            legalMoves = gameState.getLegalActions(agentIndex)
            for action in legalMoves:
                successorState = gameState.generateSuccessor(agentIndex, action)
                alpha = max(alpha, min_value(1, successorState, depth))
            return alpha

        def min_value(ghostIndex, gameState, depth):
            if depth == self.depth or gameState.isWin() or gameState.isLose():
                return self.evaluationFunction(gameState)
            beta = 1e20
            ghost_num = gameState.getNumAgents() - 1
            legalMoves = gameState.getLegalActions(ghostIndex)
            for action in legalMoves:
                successorState = gameState.generateSuccessor(ghostIndex, action)
                if ghostIndex == ghost_num:
                    beta = min(beta,max_value(0, successorState, depth+1))
                else:
                    beta = min(beta,min_value(ghostIndex + 1, successorState, depth))
            return beta

        score = []
        legalMoves = gameState.getLegalActions(0)
        for action in legalMoves:
            successorState = gameState.generateSuccessor(0, action)
            score.append((action, min_value(1,successorState,0)))
        score.sort(key=lambda v:v[1])
        bestmove = score[-1][0]

        return bestmove

        #util.raiseNotDefined()


class AlphaBetaAgent(MultiAgentSearchAgent):
    """
      Your minimax agent with alpha-beta pruning (question 3)
    """

    def getAction(self, gameState):
        """
          Returns the minimax action using self.depth and self.evaluationFunction
        """
        "*** YOUR CODE HERE ***"
        def max_value(agentIndex, gameState, depth,alpha,beta):
            if depth == self.depth or gameState.isWin() or gameState.isLose():
                return self.evaluationFunction(gameState)
            v = -1e20
            legalMoves = gameState.getLegalActions(agentIndex)
            for action in legalMoves:
                successorState = gameState.generateSuccessor(0, action)
                v = max(v, min_value(1, successorState, depth,alpha,beta))
                if v > beta:
                    return v
                alpha = max(alpha, v)
            return v

        def min_value(ghostIndex, gameState, depth,alpha,beta):
            if depth == self.depth or gameState.isWin() or gameState.isLose():
                return self.evaluationFunction(gameState)
            v = 1e20
            ghost_num = gameState.getNumAgents() - 1
            legalMoves = gameState.getLegalActions(ghostIndex)
            for action in legalMoves:
                successorState = gameState.generateSuccessor(ghostIndex, action)
                if ghostIndex == ghost_num:
                    v = min(v,max_value(0, successorState, depth+1,alpha,beta))
                else:
                    v = min(v,min_value(ghostIndex + 1, successorState, depth,alpha,beta))
                if v < alpha:
                    return v
                beta = min(beta,v)
            return v

        def prunning(gameState):
            v = -1e20
            alpha = -1e20
            beta = 1e20
            score= []
            legalMoves = gameState.getLegalActions(0)
            for action in legalMoves:
                successorState = gameState.generateSuccessor(0, action)
                tmp = min_value(1,successorState,0,alpha,beta)
                score.append((action,tmp))
                if v >= beta:  # pruning
                    return v
                alpha = max(alpha, tmp)
            score.sort(key=lambda v:v[1])
            return score[-1][0]
        return prunning(gameState)

class ExpectimaxAgent(MultiAgentSearchAgent):
    """
      Your expectimax agent (question 4)
    """

    def getAction(self, gameState):
        """
          Returns the expectimax action using self.depth and self.evaluationFunction

          All ghosts should be modeled as choosing uniformly at random from their
          legal moves.
        """
        "*** YOUR CODE HERE ***"
        def max_value(agentIndex, gameState, depth):
            if depth == self.depth or gameState.isWin() or gameState.isLose():
                return self.evaluationFunction(gameState)
            v = -1e20
            legalMoves = gameState.getLegalActions(agentIndex)
            for action in legalMoves:
                successorState = gameState.generateSuccessor(agentIndex, action)
                v = max(v,exp_value(1, successorState, depth))
            return v

        def exp_value(ghostIndex,gameState,depth):
            if depth == self.depth or gameState.isWin() or gameState.isLose():
                return self.evaluationFunction(gameState)
            v = 0
            legalMoves = gameState.getLegalActions(ghostIndex)
            p = 1 / len(legalMoves)
            ghost_num = gameState.getNumAgents()-1
            for action in legalMoves:
                successorState = gameState.generateSuccessor(ghostIndex, action)
                if ghostIndex == ghost_num:
                    v += p * max_value(0,successorState,depth+1)
                else:
                    v += p * exp_value(ghostIndex+1,successorState,depth)
            return v

        score = []
        legalMoves = gameState.getLegalActions(0)
        for action in legalMoves:
            successorState = gameState.generateSuccessor(0, action)
            score.append((action, exp_value(1,successorState,0)))
        score.sort(key=lambda v:v[1])
        bestmove = score[-1][0]

        return bestmove

        util.raiseNotDefined()

def betterEvaluationFunction(currentGameState):
    """
    Your extreme ghost-hunting, pellet-nabbing, food-gobbling, unstoppable
    evaluation function (question 5).

    DESCRIPTION:
    The evaluation function takes in the current GameStates (pacman.py)
    and returns a number, where higher numbers are better.

    The code below extracts some useful information from the state, like the
    remaining food (new_food), Pacman's current position (new_pos), ghost's current position,
    and capsule's position.

    We evaluate based on the Manhattan distance between Pacman's position and the nearest ghost,
    the whole distance from the nearest food to the last food on the board, and the whole distance
    from the nearest capsule to the last capsule on the board.

    More detailed explanation on the breakdown of the overall point (i.e, the value being returned) is described as below:
        1. the score of the current state
        2. ghost point: a punitive point to "scare" pacman away from the ghost. the nearer the distance between ghost and
            pacman, the less this item will be
        3. food point: a rewarding point calculated by iterating through the whole food path beginning from the nearest
            food possible. This item is represented by the inverse of distance between pacman and food (i.e. the nearer the
            food, the higher the result)
        4. calsule point: similar to food point as described in point 3
        5. speedup point: we found the autograder is very slow when we just use the sum of 1 - 4. Thus, we decide to add this
        item as an indicator of how far the current state is between a final state
    """
    "*** YOUR CODE HERE ***"

    newPos = currentGameState.getPacmanPosition()
    newFood = currentGameState.getFood().asList()
    newGhostStates = currentGameState.getGhostStates()
    newCapsule = currentGameState.getCapsules()
    remainFood = len(newFood)
    remainCapsule = len(newCapsule)
    score = currentGameState.getScore()

    currentFood = newPos
    for _ in newFood[::-1]:
        closestFood = min(newFood, key=lambda x: manhattanDistance(x, currentFood))
        score += 1.0 / (manhattanDistance(currentFood, closestFood))
        currentFood = closestFood
        newFood.remove(closestFood)

    if currentGameState.getNumAgents() > 1:
        ghostDis = min([manhattanDistance( ghost.getPosition(),newPos) for ghost in newGhostStates])
        if (ghostDis <= 1):
            return -1e20
        score -= 1.0 / ghostDis

    # capsule feature
    current_capsule = newPos
    for _ in newCapsule[::-1]:
        closestCapsule = min(newCapsule, key=lambda x: manhattanDistance(x, current_capsule))
        score += 3.0/(manhattanDistance(current_capsule, closestCapsule))
        current_capsule = closestCapsule
        newCapsule.remove(closestCapsule)

    score -= 4 * (remainCapsule+remainFood)

    return score




# Abbreviation
better = betterEvaluationFunction

