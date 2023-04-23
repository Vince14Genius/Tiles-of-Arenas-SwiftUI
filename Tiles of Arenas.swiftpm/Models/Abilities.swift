import SwiftUI

enum Ability: Hashable {
    /// range +1
    case leap
    static let baseRange = 1
    static let leapRange = 2
    
    /// forcibly conquers, ignoring defense or obstacles
    case aggression
    
    static func from(tileType: TileType) -> Ability? {
        switch tileType {
        case .leap: return .leap
        case .aggression: return .aggression
        default: return nil
        }
    }
}
