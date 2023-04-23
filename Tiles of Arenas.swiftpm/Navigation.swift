import SwiftUI

enum PresentableView: Hashable {
    case gameSetupView
    case gameView(setupData: GameSetupData)
}

class Navigator: ObservableObject {
    @Published var path: [PresentableView] = []
}

struct Navigation: View {
    @StateObject var navigator = Navigator()
    
    var body: some View {
        NavigationStack(path: $navigator.path) {
            TitleView(navigator: navigator)
                .navigationDestination(for: PresentableView.self) { presentableView in
                    switch presentableView {
                    case .gameSetupView:
                        GameSetupView(navigator: navigator)
                    case .gameView(let setupData): 
                        GameView(navigator: navigator, setupData: setupData)
                    }
                }
        }
    }
}
