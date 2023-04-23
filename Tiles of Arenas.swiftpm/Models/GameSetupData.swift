import SwiftUI

struct GameSetupData: Equatable, Hashable {
    struct PlayerSetupData: Identifiable, Equatable, Hashable {
        var playerName: String
        let id = UUID()
        
        var isNameInvalid: Bool {
            !GameSetupData.playerNameCharCountRange.contains(playerName.count)
        }
    }
    
    var players = [PlayerSetupData]() {
        didSet {
            ensureLowerbound()
            ensureUpperbound()
        }
    }
    
    var isNumberOfPlayersFull: Bool {
        players.count == Self.numberOfPlayersRange.upperBound
    }
    
    var isAnyPlayerNameInvalid: Bool {
        players.reduce(false) { $0 || $1.isNameInvalid }
    }
    
    static let numberOfPlayersRange = 2 ... 9
    static let playerNameCharCountRange = 1 ... 4
    static let defaultPlayerNames = ["🤷", "Hi", "🇺🇳", "Me", "lol", "Fun", "わからん", "[ə]"]
    
    init() {
        ensureLowerbound()
    }
    
    /// Adds a new default (unnamed) player to the players array
    mutating func addNewDefaultPlayer() {
        players.append(.init(playerName: Self.defaultPlayerNames.randomElement()!))
    }
    
    /// Fills up the players array with default players until the
    /// array count reaches the lower bound
    private mutating func ensureLowerbound() {
        while players.count < Self.numberOfPlayersRange.lowerBound {
            addNewDefaultPlayer()
        }
    }
    
    /// Removes trailing players from the players array until the 
    /// array count reaches the upper bound
    private mutating func ensureUpperbound() {
        let upperbound = Self.numberOfPlayersRange.upperBound
        guard players.count > upperbound else { return }
        players.removeLast(players.count - upperbound)
    }
}
