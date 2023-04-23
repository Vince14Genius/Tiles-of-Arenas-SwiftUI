import SwiftUI

private let maxSettlementLevel = 5
private let maxDefenseLevel = 5

private let respawnedPlayerCityLevel = 3

struct MapRow: Identifiable {
    var tiles: [Tile]
    let id = UUID()
}

struct Map {
    var rows: [MapRow]
    
    /// Calculates the number of tiles given the number of players.
    ///
    /// This algorithm is migrated from the JavaScript version of this
    /// game, untouched.
    static func numberOfTiles(for numberOfPlayers: Int) -> Int {
        // // The JS code, for reference 
        // var baseArea = Math.pow(24, 2)
        // var totalArea = baseArea + 90 * playerNames.length
        // Game.startGame(Math.ceil(Math.sqrt(totalArea)), playerNames)
        let baseArea = 24.0 * 24.0
        let totalArea = baseArea + 90 * Double(numberOfPlayers)
        return Int(ceil(sqrt(totalArea)))
    }
    
    init(numberOfPlayers: Int) {
        let size = Self.numberOfTiles(for: numberOfPlayers)
        rows = []
        for _ in 1 ... size {
            var row = MapRow(tiles: [])
            for _ in 1 ... size {
                row.tiles.append(.init(type: .randomInitialSpawn()))
            }
            rows.append(row)
        }
    }
    
    func topLeadingCorner(of player: Player) -> Tile {
        for row in rows {
            for tile in row.tiles {
                switch tile.type {
                case .regularTerritory(let owner, _):
                    if owner === player {
                        return tile
                    }
                case .settlementTerritory(let owner, _):
                    if owner === player {
                        return tile
                    }
                default:
                    break
                }
            }
        }
        fatalError("topLeadingCorner(of:) should only be called after testing for respawns")
    }
    
    mutating func refreshFogOfWar(player: Player, step: GameObject.StepInTurn) {
        switch step {
        case .place:
            
            // for keeping track of whether player is still alive
            var hasTiles = false
            
        loopRowsInMap: for i in rows.indices {
        loopTilesInRow: for j in rows[i].tiles.indices {
            let type = rows[i].tiles[j].type
                
            // pre-determined on/off
            if 
                case .obstacle = type,
                player.currentlyUsedAbility != .aggression
            {
                rows[i].tiles[j].isFogOfWarOn = true
                continue loopTilesInRow
            }
            
            if
                case .regularTerritory(let owner, let defenseLevel) = type,
                owner === player
            {
                hasTiles = true
                if defenseLevel >= maxDefenseLevel {
                    rows[i].tiles[j].isFogOfWarOn = true
                    continue loopTilesInRow
                }
            }
            
            if
                case .settlementTerritory(let owner, let developmentLevel) = type,
                owner === player
            {
                hasTiles = true
                if developmentLevel >= maxSettlementLevel {
                    rows[i].tiles[j].isFogOfWarOn = true
                    continue loopTilesInRow
                }
            }
                    
            // depends on vision
            let visionRange = player.currentlyUsedAbility == .leap ? 2 : 1
            let iRange = max(0, i - visionRange) ... min(rows.count - 1, i + visionRange)
            let jRange = max(0, j - visionRange) ... min(rows[i].tiles.count - 1, j + visionRange)
                    
            // don't worry this is O(1)
            for i2 in iRange {
                for j2 in jRange {
                    let probedType = rows[i2].tiles[j2].type
                    if 
                        case .regularTerritory(let owner, _) = probedType,
                        owner === player
                    {
                        rows[i].tiles[j].isFogOfWarOn = false
                        continue loopTilesInRow
                    }
                    if 
                        case .settlementTerritory(let owner, _) = probedType,
                        owner === player
                    {
                        rows[i].tiles[j].isFogOfWarOn = false
                        continue loopTilesInRow
                    }
                }
            }
                    
            // if no neighbor in range is owned by player, fog it
            rows[i].tiles[j].isFogOfWarOn = true
            continue loopTilesInRow
        }
        }
            
            if !hasTiles {
                // respawn player
                let randRow = Int.random(in: 0 ... rows.count - 1)
                let randCol = Int.random(in: 0 ... rows[0].tiles.count - 1)
                rows[randRow].tiles[randCol].type = .settlementTerritory(owner: player, developmentLevel: respawnedPlayerCityLevel)
                player.didJustRespawn = true
                
                // reset player score & Occupy Power
                player.gainSettlement(by: respawnedPlayerCityLevel)
                player.currentTurnRemainingCapturesCount += respawnedPlayerCityLevel
                
                // recursively call refreshFogOfWar once
                refreshFogOfWar(player: player, step: step)
            }
            
        case .remove:
            
        loopRowsInMap: for i in rows.indices {
        loopTilesInRow: for j in rows[i].tiles.indices {
            let type = rows[i].tiles[j].type
            
            if 
                case .regularTerritory(let owner, _) = type,
                owner === player
            {
                rows[i].tiles[j].isFogOfWarOn = false
                continue loopTilesInRow
            }
            if 
                case .settlementTerritory(let owner, _) = type,
                owner === player
            {
                rows[i].tiles[j].isFogOfWarOn = false
                continue loopTilesInRow
            }
            
            // if not owned by player, fog it
            rows[i].tiles[j].isFogOfWarOn = true
            continue loopTilesInRow
        }
        }
            
        }
    }
}
