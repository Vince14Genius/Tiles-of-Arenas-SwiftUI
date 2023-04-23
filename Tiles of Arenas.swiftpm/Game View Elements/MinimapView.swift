import SwiftUI

struct MinimapView: View {
    private let spacing = 0.5
    private let padding = 10.0
    
    private func cursorLength(screenLength: Double, tileLength: Double) -> Double {
        let spannedNumberOfTiles = screenLength / tileLength
        return (spacing + padding) * spannedNumberOfTiles
    }
    
    let map: Map
    @ObservedObject var game: GameObject
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                HStack {
                    ZStack {
                        Grid(alignment: .center, horizontalSpacing: spacing, verticalSpacing: spacing) {
                            ForEach(map.rows, id: \.id) { mapRow in
                                GridRow {
                                    ForEach(mapRow.tiles, id: \.id) { tile in
                                        MinimapTileDot(type: tile.type, game: game)
                                    }
                                }
                            }
                        }
                        .padding(padding)
                        .background(Color.black)
//                        Rectangle()
//                            .stroke(.primary, lineWidth: 1)
//                            .frame(
//                                width: cursorLength(screenLength: proxy.size.width, tileLength: TileView.width), 
//                                height: cursorLength(screenLength: proxy.size.height, tileLength: TileView.height),
//                                alignment: .center
//                            )
                    }
                    .padding(20)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct MinimapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MinimapView(map: .init(numberOfPlayers: 5), game: .init())
        }
        .colorScheme(.dark)
    }
}
