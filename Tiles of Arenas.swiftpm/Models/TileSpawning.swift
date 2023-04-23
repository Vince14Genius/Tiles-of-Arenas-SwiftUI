import SwiftUI

extension TileType {
    static func randomInitialSpawn() -> TileType {
        switch Double.random(in: 0 ..< 100) {
        case 0 ..< 60: return .regular
        case 60 ..< 64: return .settlement
        case 64 ..< 68: return .leap
        case 68 ..< 72: return .burst
        case 72 ..< 94: return .obstacle
        default: return .aggression
        }
    }
    
    static func randomRenewal() -> TileType {
        switch Double.random(in: 0 ..< 100) {
        case 0 ..< 0.3: return .settlement
        case 0.3 ..< 2.7: return .leap
        case 2.7 ..< 4.3: return .aggression
        case 4.3 ..< 6.2: return .burst
        default: return .regular
        }
    }
}
