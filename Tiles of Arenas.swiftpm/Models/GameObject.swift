import SwiftUI

class GameObject: ObservableObject {
    @Published var map = Map(numberOfPlayers: 2)
    
    @Published var players = [Player]()
    @Published var currentPlayerIndex = -1
    
    var currentPlayer: Player { players[currentPlayerIndex] }
    
    enum StepInTurn: Hashable {
        case place, remove
    }
    
    static let stepsInTurn: [StepInTurn] = [
        .place, .remove
    ]
    
    @Published private(set) var currentStepIndex = -1
    var currentStep: StepInTurn { Self.stepsInTurn[currentStepIndex] }
    
    @Published var currentInstructionText: String? = InstructionsCatalog.turnInstructions[.place]
    
    static let maxTurns = 40
    @Published var numberOfTurnsPlayed = 1
    
    func setup(data: GameSetupData) {
        map = .init(numberOfPlayers: data.players.count)
        players = data.players.map {
            .init(name: $0.playerName)
        }
        
        // trigger current index changes
        currentPlayerIndex = 0
        currentStepIndex = 0
        
        // pick a cluster of 2x2 tiles to spawn for each player
        for player in players {
            let randRow = Int.random(in: 0 ... map.rows.count - 2)
            let randCol = Int.random(in: 0 ... map.rows[0].tiles.count - 2)
            let tileLocations = [
                (randRow, randCol),     (randRow, randCol + 1),
                (randRow + 1, randCol), (randRow + 1, randCol + 1),
            ]
            
            for loc in tileLocations {
                map.rows[loc.0].tiles[loc.1].type = .regularTerritory(owner: player, defenseLevel: 1)
            }
        }
    }
    
    /// Continues to the next step if all required actions this step has been complete
    ///
    /// - Important: needs to be called **when and only when** a tile occupation
    ///   or removal happens.
    func goToNextStepIfNeeded() {
        if isCurrentStepDone { nextStep() }
    }
    
    private func nextStep() {
        // increment step index no matter what
        currentStepIndex += 1
        currentStepIndex %= Self.stepsInTurn.count
        currentInstructionText = InstructionsCatalog.turnInstructions[currentStep]
        if currentStepIndex == 0 { 
            // if player turn is over
            currentPlayerIndex += 1
            currentPlayerIndex %= players.count
            currentPlayer.refreshTurn()
            if currentPlayerIndex == 0 {
                // if all player turns are over
                numberOfTurnsPlayed += 1
                if numberOfTurnsPlayed >= Self.maxTurns {
                    gameOver()
                }
            }
        }
    }
    
    private var isCurrentStepDone: Bool {
        let currentPlayer = players[currentPlayerIndex]
        switch Self.stepsInTurn[currentStepIndex] {
        case .place:
            return currentPlayer.currentTurnRemainingCapturesCount <= 0
        case .remove:
            return currentPlayer.didSelfRemoveCurrentTurn
        }
    }
    
    private func gameOver() {
        //TODO
    }
}
