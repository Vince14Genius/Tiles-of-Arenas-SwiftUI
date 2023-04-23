import SwiftUI

struct TitleView: View {
    @ObservedObject var navigator: Navigator
    
    var body: some View {
        VStack {
            Spacer()
            Text("Tiles of Arenas")
                .font(.title)
                .shadow(color: .accentColor, radius: 10, x: 0, y: 0)
                .padding()
            Text("A SwiftUI-powered\nmultiplayer strategy board game.")
                .multilineTextAlignment(.leading)
                .padding()
            Spacer()
            NavigationLink("Play", value: PresentableView.gameSetupView)
                .buttonStyle(.borderedProminent)
                .padding()
            Spacer()
        }
    }
}
