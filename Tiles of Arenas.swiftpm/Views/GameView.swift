import SwiftUI

struct FloatingAlertButton: View {
    let text: String
    @Binding var isAlertPresented: Bool
    var body: some View {
        HStack {
            Spacer()
            Button(text) {
                isAlertPresented = true
            }
            .buttonStyle(.bordered)
            .foregroundColor(.primary)
            .padding(.trailing)
        }
    }
}

struct InstructionsText: View {
    var text: String?
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Spacer()
            Text(text ?? "")
                .buttonStyle(.bordered)
                .foregroundColor(.primary)
                .padding()
                .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .allowsHitTesting(false)
            Spacer()
        }
    }
}

struct GameView: View {
    @ObservedObject var navigator: Navigator
    let setupData: GameSetupData
    
    @State var isBackToTitleAlertPresented = false
    @State var isLeaderboardAlertPresented = false
    
    @StateObject var game = GameObject()
    
    var body: some View {
        ZStack {
            TileMapView(map: game.map, game: game)
            Group {
                MinimapView(map: game.map, game: game)
                InstructionsText(text: game.currentInstructionText)
                    .opacity(game.currentInstructionText == nil ? 0 : 1)
                    .scaleEffect(game.currentInstructionText == nil ? 0.5 : 1.0)
                    .animation(.linear, value: game.currentInstructionText)
                    .padding()
                GameHUD(game: game)
                VStack {
                    FloatingAlertButton(text: "Quit", isAlertPresented: $isBackToTitleAlertPresented)
                    FloatingAlertButton(text: "Rankings", isAlertPresented: $isLeaderboardAlertPresented)
                    Spacer()
                }
                .padding(.vertical)
            }
            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 0)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .alert(
            "Back to Title", 
            isPresented: $isBackToTitleAlertPresented
        ) {
            Button("Return to Title", role: .destructive) {
                navigator.path = []
            }
            Button("Dismiss", role: .cancel) {
                isBackToTitleAlertPresented = false
            }
        } message: {
            Text("Are you sure you want to end the game and return to the title screen?")
        }
        .alert(
            "Leaderboard",
            isPresented: $isLeaderboardAlertPresented
        ) {
            Button("Dismiss", role: .cancel) {
                isLeaderboardAlertPresented = false
            }
        } message: {
            VStack {
                let players = game.players.sorted { $0.score > $1.score }
                Text(players.reduce("") {
                    $0 + "Player <\($1.name)>: \($1.score)\n"
                })
            }
        }
        .onAppear {
            game.setup(data: setupData)
            game.map.refreshFogOfWar(player: game.currentPlayer, step: game.currentStep)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GameView(navigator: .init(), setupData: .init())
        }
        .colorScheme(.dark)
    }
}
