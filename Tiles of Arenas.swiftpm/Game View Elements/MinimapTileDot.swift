import SwiftUI

struct MinimapTileDot: View {
    static let sideLength = 3.5
    
    let type: TileType
    @ObservedObject var game: GameObject
    
    private let regularColor = Color(.secondarySystemBackground)
    private var symbolFont: Font {
        Font.system(size: Self.sideLength / 3, weight: .bold, design: .default)
    }
    
    var body: some View {
        Group {
            switch (type) {
            case .regular: 
                regularColor
            case .regularTerritory(let owner, _):
                Color.territory(side: owner === game.currentPlayer ? .currentPlayer : .enemy)
            case .settlement:
                Color.green.opacity(0.3)
            case .settlementTerritory(let owner, _):
                Color.playerTheme(side: owner === game.currentPlayer ? .currentPlayer : .enemy)
            case .obstacle:
                Color.secondary.opacity(0.8)
            case .aggression:
                Color.red.opacity(0.3)
            case .leap:
                Color.yellow.opacity(0.3)
            case .burst:
                Color.green.opacity(0.3)
            }
        }
        .frame(width: Self.sideLength, height: Self.sideLength, alignment: .center)
    }
}

struct MinimapTileDot_Previews: PreviewProvider {
    static var previews: some View {
        let size = Map.numberOfTiles(for: 5)
        VStack {
            Spacer()
            Grid(alignment: .center, horizontalSpacing: 0.5, verticalSpacing: 0.5) {
                ForEach(0 ..< size) { _ in
                    GridRow {
                        ForEach(0 ..< size) { _ in
                            MinimapTileDot(type: .randomInitialSpawn(), game: GameObject())
                        }
                    }
                }
            }
            .padding(10)
            .background(Color(.systemBackground))
            .colorScheme(.dark)
            Spacer()
            Text("Number of tiles, side length: \(size)")
            Spacer()
        }
    }
}
