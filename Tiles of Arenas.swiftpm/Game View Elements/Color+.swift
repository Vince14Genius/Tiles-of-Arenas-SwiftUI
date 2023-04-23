import SwiftUI

enum PlayerSide: Hashable {
    case currentPlayer
    case ally
    case enemy
}

extension Color {
    static func playerTheme(side: PlayerSide) -> Color {
        switch side {
        case .currentPlayer:
            return .init(.sRGB, red: 0, green: 1, blue: 1, opacity: 1)
        case .ally:
            return .blue
        case .enemy:
            return .red
        }
    }
    
    static func territory(side: PlayerSide) -> Color {
        playerTheme(side: side)
//        switch side {
//        case .currentPlayer:
//            return .init(.sRGB, red: 0, green: 0.5, blue: 0.5, opacity: 1)
//        case .ally:
//            return .init(.sRGB, red: 0, green: 0, blue: 0.5, opacity: 1)
//        case .enemy:
//            return .init(.sRGB, red: 0.5, green: 0, blue: 0, opacity: 1)
//        }
    }
}
