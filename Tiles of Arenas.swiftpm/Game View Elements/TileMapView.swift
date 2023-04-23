import SwiftUI

struct TileMapView: View {
    let map: Map
    @ObservedObject var game: GameObject
    
    var body: some View {
        GeometryReader { proxy in
            ScrollViewReader { scrollViewProxy in
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
                        ForEach($game.map.rows, id: \.id) { mapRow in
                            GridRow {
                                ForEach(mapRow.tiles, id: \.id) { tile in
                                    TileView(tile: tile, game: game)
                                        .id(tile.id)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, proxy.size.width / 3)
                    .padding(.vertical, proxy.size.height / 3)
                }
                .onChange(of: game.currentPlayerIndex) { _ in 
                    let topLeadingCorner = game.map.topLeadingCorner(of: game.currentPlayer)
                    withAnimation(.easeInOut(duration: 1.0)) {
                        scrollViewProxy.scrollTo(topLeadingCorner.id, anchor: .center)
                    }
                }
                .background(Color(.systemBackground))
            }
        }
    }
}

struct TileMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TileMapView(map: .init(numberOfPlayers: 5), game: .init())
        }
        .colorScheme(.dark)
    }
}
