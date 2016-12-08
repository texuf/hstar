//
//  HStar.swift
//  hstar
//
//  Created by Austin Ellis on 12/7/16.
//  Copyright © 2016 Austin Ellis. All rights reserved.
//

import Foundation

/**
 HStar is a modified AStar algorithm that is familiar with the rules of Hedgehog Escape
 it also dirtly uses globals from the model.swift file
 based of the classic A* https://en.wikipedia.org/wiki/A*_search_algorithm
 */

class HStar{
    static func shortestPath(
        from start: Hedge,
        obstacles: Set<Position>
    ) -> [Hedge]?
    {
        // The set of nodes already evaluated.
        var closedSet: Set<Hedge> = []
        // The set of currently discovered nodes still to be evaluated.
        // Initially, only the start node is known.
        let goal = goalNode
        var openSet: Set<Hedge> = [start]
        // For each node, which node it can most efficiently be reached from.
        // If a node can be reached from many nodes, cameFrom will eventually contain the
        // most efficient previous step.
        var cameFrom: [Hedge: Hedge] = [:]
        // For each node, the cost of getting from the start node to that node.
        var gScore: [Hedge: Int] = [:]
        // The cost of going from start to start is zero.
        gScore[start] = 0
        // For each node, the total cost of getting from the start node to the goal
        // by passing by that node. That value is partly known, partly heuristic.
        var fScore: [Hedge: Int] = [:]
        // For the first node, that value is completely heuristic.
        fScore[start] = heuristicCostEstimate(from: start, to: goalNode)
        
        do {
            //current = the node in openSet having the lowest fScore[] value
            let current = bestFScoreNode(openSet: openSet, fScores: fScore)
            if current == goalNode
            {
                return reconstructPath(cameFrom: cameFrom, current: current)
            }
            
            openSet.remove(current)
            closedSet.insert(current)
            let neighbors = try getNeighbors(current: current, obstacles: obstacles)
            for neighbor in neighbors
            {
                if closedSet.contains(neighbor)
                {
                    continue		// Ignore the neighbor which is already evaluated.
                }
                // The distance from start to a neighbor
                let tentativeGScore = gScore[current]! + distBetween(from: current, to: neighbor)
                if !openSet.contains(neighbor)
                {
                    openSet.insert(neighbor)
                }
                else if tentativeGScore >= gScore[neighbor]!
                {
                    continue		// This is not a better path.
                }
                
                // This path is the best until now. Record it!
                cameFrom[neighbor] = current
                gScore[neighbor] = tentativeGScore
                fScore[neighbor] = gScore[neighbor]! + heuristicCostEstimate(from: neighbor, to: goal)
            }
        }
        catch {
            
        }
        return nil
    }
    
    private static func getNeighbors(current: Hedge, obstacles: Set<Position>) throws -> [Hedge]
    {
        return try Direction.all()
            .map{
                try current.rotate(to: $0)
            }.filter{
                !$0.isOutOfBounds()
                && obstacles.intersection($0.footPrint()).count == 0
            }
    }
    
    private static func bestFScoreNode(openSet: Set<Hedge>, fScores: [Hedge: Int]) -> Hedge
    {
        var bestScore: Int = Int.max
        var bestNode: Hedge!
        for node in openSet{
            if fScores[node]! < bestScore
            {
                bestScore = fScores[node]!
                bestNode = node
            }
        }
        return bestNode!
    }
    
    private static func heuristicCostEstimate(from: Hedge, to: Hedge) -> Int
    {
        //return distance for now since
        return distBetween(from: from, to: to)
    }

    private static func distBetween(from fHedge: Hedge, to tHedge: Hedge) -> Int {
        //return unsquared distance
        let to = tHedge.position
        let from  = fHedge.position
        return (to.x - from.x) * (to.x - from.x) + (to.y - from.y) * (to.y - from.y)
    }
    private static func reconstructPath(cameFrom: [Hedge: Hedge], current: Hedge) -> [Hedge]
    {
        var totalPath = [current]
        var next = current
        while cameFrom[next] != nil
        {
            next = cameFrom[next]!
            totalPath.append(next)
        }
        return totalPath.reversed()
    }
}
