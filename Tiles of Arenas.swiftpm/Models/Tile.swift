import SwiftUI

private let burstAmount = 2

enum TileType {
    /// nothing special, but can spontaneously turn into one of the single-use resource tiles
    case regular
    
    case regularTerritory(owner: Player, defenseLevel: Int)
    
    /// obstacles cannot be conquered, unless you use the aggression ability
    case obstacle
    
    /// settlements give you permanent extra conquers per turn
    case settlement
    
    case settlementTerritory(owner: Player, developmentLevel: Int)
    
    // MARK: single-use resource tiles
    
    case leap
    case aggression
    case burst
}

struct Tile: Identifiable {
    let id = UUID()
    var type: TileType
    
    var isFogOfWarOn = false
    
    /// Attempts to get captured by a player; returns `true` if successful,
    /// returns `false` if unsuccessful
    mutating func captureAttempt(by player: Player) -> Bool {
        guard player.useCapture() else { return false }
        switch type {
        case .regular:
            
            type = .regularTerritory(owner: player, defenseLevel: 1)
            
        case .regularTerritory(let owner, let defenseLevel):
            
            if owner === player {
                type = .regularTerritory(owner: player, defenseLevel: defenseLevel + 1)
            } else if player.currentlyUsedAbility == .aggression {
                type = .regularTerritory(owner: player, defenseLevel: 1)
            } else {
                let newDefenseLevel = defenseLevel - 1
                if newDefenseLevel <= 0 {
                    type = .regularTerritory(owner: player, defenseLevel: 1)
                } else {
                    type = .regularTerritory(owner: owner, defenseLevel: newDefenseLevel)
                }
            }
            
        case .obstacle:
            
            guard player.currentlyUsedAbility == .aggression else {
                fatalError("Occupying an obstacle without the Destruction ability is not permitted.")
            } 
            type = .regularTerritory(owner: player, defenseLevel: 1)
            
        case .settlement:
            
            type = .settlementTerritory(owner: player, developmentLevel: 1)
            player.gainSettlement(by: 1)
            
        case .settlementTerritory(let owner, let developmentLevel):
            
            if owner === player {
                type = .settlementTerritory(owner: player, developmentLevel: developmentLevel + 1)
                player.gainSettlement(by: 1)
            } else if player.currentlyUsedAbility == .aggression {
                type = .settlementTerritory(owner: player, developmentLevel: 1)
                player.gainSettlement(by: 1)
                owner.loseSettlement(by: developmentLevel)
            } else {
                let newLevel = max(developmentLevel - 1, 1)
                type = .settlementTerritory(owner: player, developmentLevel: newLevel)
                player.gainSettlement(by: newLevel)
                owner.loseSettlement(by: developmentLevel)
            }
            
        case .leap:
            
            type = .regularTerritory(owner: player, defenseLevel: 1)
            player.abilityCounts[.leap] = (player.abilityCounts[.leap] ?? 0) + 1
            
        case .aggression:
            
            type = .regularTerritory(owner: player, defenseLevel: 1)
            player.abilityCounts[.aggression] = (player.abilityCounts[.aggression] ?? 0) + 1
            
        case .burst:
            
            type = .regularTerritory(owner: player, defenseLevel: 1)
            player.burst(by: burstAmount)
            
        }
        player.commitCurrentAbility()
        return true
    }
    
    /// Attempts to get removed by a player; calls the player's `didSelfRemove()`
    /// if successful
    mutating func selfRemove(by player: Player) {
        switch self.type {
        case .regularTerritory(let owner, let defenseLevel):
            guard owner === player else { return }
            let newValue = defenseLevel - 1
            if newValue <= 0 {
                type = .regular
            } else {
                type = .regularTerritory(owner: player, defenseLevel: newValue)
            }
        case .settlementTerritory(let owner, let developmentLevel):
            guard owner === player else { return }
            let newValue = developmentLevel - 1
            player.loseSettlement(by: 1)
            if newValue <= 0 {
                type = .settlement
            } else {
                type = .settlementTerritory(owner: player, developmentLevel: newValue)
            }
        default: 
            return
        }
        player.didSelfRemove()
    }
}
