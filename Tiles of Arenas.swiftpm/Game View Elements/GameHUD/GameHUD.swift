import SwiftUI

struct GameHUD: View {
    @ObservedObject var game: GameObject
    
    var body: some View {
        VStack {
            if game.players.indices.contains(game.currentPlayerIndex) {
                Text("Turn: \(game.numberOfTurnsPlayed) / \(GameObject.maxTurns)\nPlayer: \(game.currentPlayer.name)\nScore: \(game.currentPlayer.score)")
                    .padding(8)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                Spacer()
                CapturesCountIndicator(count: game.currentPlayer.currentTurnRemainingCapturesCount)
                HStack(spacing: 0) {
                    let step = game.currentStep
                    ActiveAbilityButton(
                        type: .aggression, 
                        count: game.currentPlayer.abilityCounts[.aggression] ?? 0,
                        step: step
                    ) {
                        if game.currentPlayer.activateAbility(.aggression) {
                            game.currentInstructionText = InstructionsCatalog.abilityActive(.aggression)
                            game.map.refreshFogOfWar(player: game.currentPlayer, step: step)
                        }
                    }
                    ActiveAbilityButton(
                        type: .leap, 
                        count: game.currentPlayer.abilityCounts[.leap] ?? 0,
                        step: step
                    ) {
                        if game.currentPlayer.activateAbility(.leap) {
                            game.currentInstructionText = InstructionsCatalog.abilityActive(.leap)
                            game.map.refreshFogOfWar(player: game.currentPlayer, step: step)
                        }
                    }
                }
                .padding(4)
                .background(Color(.systemBackground), alignment: .center)
            }
        }
        .colorScheme(.dark)
        .padding()
    }
}

struct GameHUD_Previews: PreviewProvider {
    static var previews: some View {
        GameHUD(game: GameObject())
    }
}
