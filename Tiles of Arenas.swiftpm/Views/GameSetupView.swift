import SwiftUI

struct GameSetupView: View {
    @State var setupData = GameSetupData()
    
    @ObservedObject var navigator: Navigator
    
    var body: some View {
        Form {
            Text("Maximum length for player names: 4")
            Section {
                List {
                    ForEach($setupData.players, id: \.id) { player in
                        VStack(alignment: .leading) {
                            Text("Player Name: ")
                                .foregroundColor(player.wrappedValue.isNameInvalid ? .red : .secondary)
                            TextField("Player Name", text: player.playerName)
                        }
                    }
                    .onDelete { offsets in
                        setupData.players.remove(atOffsets: offsets)
                    }
                }
                Button("Add Player") {
                    setupData.addNewDefaultPlayer()
                }
                .disabled(setupData.isNumberOfPlayersFull)
            }
            
            Section {
                Button("Start Game") {
                    navigator.path.append(.gameView(setupData: setupData))
                }
                .disabled(setupData.isAnyPlayerNameInvalid)
            }
        }
        .navigationTitle("Players")
        .toolbar {
            EditButton()
        }
    }
}
