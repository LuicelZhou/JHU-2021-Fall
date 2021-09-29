# search.py
# ---------
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


"""
In search.py, you will implement generic search algorithms which are called by
Pacman agents (in searchAgents.py).
"""

"""
This code is wriiten by: Yuyang Zhou

Group member: 
Yuyang Zhou (yzhou193@jhu.edu)
Shuyao Tan (stan29@jhu.edu)

Some of our codes are different, due to our own preferences of code writing.
However, the ideas behind it are the same.
"""


import util
from game import Directions


class SearchProblem:
    """
    This class outlines the structure of a search problem, but doesn't implement
    any of the methods (in object-oriented terminology: an abstract class).

    You do not need to change anything in this class, ever.
    """

    def getStartState(self):
        """
        Returns the start state for the search problem.
        """
        util.raiseNotDefined()

    def isGoalState(self, state):
        """
          state: Search state

        Returns True if and only if the state is a valid goal state.
        """
        util.raiseNotDefined()

    def getSuccessors(self, state):
        """
          state: Search state

        For a given state, this should return a list of triples, (successor,
        action, stepCost), where 'successor' is a successor to the current
        state, 'action' is the action required to get there, and 'stepCost' is
        the incremental cost of expanding to that successor.
        """
        util.raiseNotDefined()

    def getCostOfActions(self, actions):
        """
         actions: A list of actions to take

        This method returns the total cost of a particular sequence of actions.
        The sequence must be composed of legal moves.
        """
        util.raiseNotDefined()


def tinyMazeSearch(problem):
    """
    Returns a sequence of moves that solves tinyMaze.  For any other maze, the
    sequence of moves will be incorrect, so only use this for tinyMaze.
    """
    from game import Directions
    s = Directions.SOUTH
    w = Directions.WEST
    return  [s, s, w, s, w, w, s, w]

def depthFirstSearch(problem):
    """
    Search the deepest nodes in the search tree first.

    Your search algorithm needs to return a list of actions that reaches the
    goal. Make sure to implement a graph search algorithm.

    To get started, you might want to try some of these simple commands to
    understand the search problem that is being passed in:

    print("Start:", problem.getStartState())
    print("Is the start a goal?", problem.isGoalState(problem.getStartState()))
    print("Start's successors:", problem.getSuccessors(problem.getStartState()))
    """
    "*** YOUR CODE HERE ***"
    open = util.Stack()
    close = []
    S = problem.getStartState()
    open.push((S,[]))
    while open.isEmpty() == False:
        cnode,directions = open.pop()
        if problem.isGoalState(cnode):
            return directions
        if cnode not in close:
            s = problem.getSuccessors(cnode)
            close.append(cnode)
            for i in range(len(s)):
                node = s[i][0]
                direction = s[i][1]
                path = directions + [direction]
                open.push((node, path))

    util.raiseNotDefined()


def breadthFirstSearch(problem):
    """Search the shallowest nodes in the search tree first."""
    open = util.Queue()
    close = []
    S = problem.getStartState()
    open.push((S,[]))

    while open.isEmpty() == False:
        cnode,directions = open.pop()
        if problem.isGoalState(cnode):
            return directions
        if cnode not in close:
            s = problem.getSuccessors(cnode)
            close.append(cnode)
            for i in range(len(s)):
                node = s[i][0]
                direction = s[i][1]
                path = directions + [direction]
                open.push((node, path))
    util.raiseNotDefined()



def uniformCostSearch(problem):
    """Search the node of least total cost first."""
    "*** YOUR CODE HERE ***"

    open = util.PriorityQueue()
    close = []
    S = problem.getStartState()
    open.push((S,[],0),0)
    while open.isEmpty() == False:
        cnode = open.pop()
        directions = cnode[1]
        if problem.isGoalState(cnode[0]):
            return directions
        if cnode[0] not in close:
            s = problem.getSuccessors(cnode[0])
            close.append(cnode[0])
            for i in range(len(s)):
                node = s[i][0]
                direction = s[i][1]
                cost = s[i][2] + cnode[2]
                path = directions + [direction]
                open.update((node, path, cost), cost)


    util.raiseNotDefined()

def nullHeuristic(state, problem=None):
    """
    A heuristic function estimates the cost from the current state to the nearest
    goal in the provided SearchProblem.  This heuristic is trivial.
    """
    return 0

def aStarSearch(problem, heuristic=nullHeuristic):
    """Search the node that has the lowest combined cost and heuristic first."""
    "*** YOUR CODE HERE ***"
    open = util.PriorityQueue()
    close = []
    S = problem.getStartState()
    open.push((S,[],0),0)
    while open.isEmpty() == False:
        cnode = open.pop()
        directions = cnode[1]
        if problem.isGoalState(cnode[0]):
            return directions
        if cnode[0] not in close:
            s = problem.getSuccessors(cnode[0])
            close.append(cnode[0])
            for i in range(len(s)):
                node = s[i][0]
                direction = s[i][1]
                path = directions + [direction]
                cost = problem.getCostOfActions(path) + heuristic(node,problem)
                open.update((node, path, cost), cost)
    util.raiseNotDefined()



# Abbreviations
bfs = breadthFirstSearch
dfs = depthFirstSearch
astar = aStarSearch
ucs = uniformCostSearch
