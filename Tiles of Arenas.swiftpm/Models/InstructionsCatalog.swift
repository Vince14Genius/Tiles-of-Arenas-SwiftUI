import SwiftUI

struct InstructionsCatalog {
    static let turnInstructions: [GameObject.StepInTurn: String] = [
        .place: "Tap on an available tile to occupy it.\nTap on a tile you occupied to upgrade it.",
        .remove: "End of turn.\nPlease tap and remove one of your occupied tiles to proceed.",
    ]
    
    static func abilityActive(_ ability: Ability) -> String {
        switch ability {
        case .aggression:
            return "You activated the Destruction ability. Your next tile placement can instantly destroy any enemy defense or obstacle."
        case .leap:
            return "You activated the Leap ability. Your next tile placement can be further away from your current territory."
        }
    }
    
    static let failureOutOfRange = "This tile is out of range. You cannot occupy it."
    
    static let failureObstacle = "This tile is an obstacle. You cannot occupy it unless you use the Destruction ability."
    
    static let respawn = "Oops, you have lost all of your territories...\nDon't worry, we have respawned you with a free settlement so you can keep playing and maybe show us an epic comeback!"
    
    static func noticeOccupySuccess(tileType: TileType, player: Player) -> String {
        switch tileType {
        case .regular:
            return "Success! You occupied a tile and it is now your territory. You can now occupy its neighboring tiles for resources and objectives!"
        case .regularTerritory(let owner, let defenseLevel):
            if player === owner {
                return "Congrats! You upgraded your territory's defenses. Enemies will need to spend more Occupy Power to conquer it!"
            } else if defenseLevel <= 0 {
                return "Bravo! You conquered one of your enemy's territories!"
            } else {
                return "You attacked your enemy's defenses. Their territory is now weakened."
            }
        case .obstacle:
            return "Success! You destroyed the obstacle with your Destruction ability and turned the tile into yours."
        case .settlement:
            return "Success! You occupied a settlement and earned a point. Settlements give you extra Occupy Power every turn!"
        case .settlementTerritory(let owner, _):
            if player === owner {
                return "Congrats! You upgraded your settlement and earned a point. This settlement will now give you one additional Occupy Power per turn!"
            } else {
                return "Bravo! You conquered one of your enemy's settlements, stealing their points and extra Occupy Power!"
            }
        case .aggression:
            return "You collected a Flame of Destruction!\nIt allows you to use the Destruction ability to instantly destroy enemy defenses and even obstacles!"
        case .leap:
            return "You collected a Leap Essence!\nIt allows you to use the Leap ability to occupy tiles further away from your territories!"
        case .burst:
            return "You collected a Burst Sustenance!\nIt gives you extra Occupy Power for the current round!"
        }
    }
}
