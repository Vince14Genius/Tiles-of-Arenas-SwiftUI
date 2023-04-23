import SwiftUI

private struct EmbeddedSymbol: View {
    private var symbolFont: Font {
        Font.system(size: min(TileView.width, TileView.height) / 3, weight: .bold, design: .default)
    }
    
    let systemName: String
    let color: Color
    
    var body: some View {
        Image(systemName: systemName)
            .foregroundColor(color)
            .font(symbolFont)
    }
}

struct TileView: View {
    static let width = 72.0
    static let height = 84.0
    
    private let regularColor = Color(.secondarySystemBackground)
    
    @Binding var tile: Tile
    @ObservedObject var game: GameObject
    
    var isDebugOn = false
    
    var body: some View {
        ZStack {
            Group {
                switch (tile.type) {
                case .regular: 
                    
                    regularColor
                        .border(.background.opacity(0.5), width: 2)
                    
                case .regularTerritory(let owner, let defenseLevel):
                    
                    let side: PlayerSide = isDebugOn ? .currentPlayer : (
                        owner === game.currentPlayer ? .currentPlayer : .enemy
                    )
                    let color = Color.territory(side: side)
                    ZStack {
                        regularColor
                            .border(color, width: 4 * Double(defenseLevel))
                            .border(.background.opacity(0.5), width: 2)
                        Text(owner.name)
                            .foregroundColor(color)
                    }
                    
                case .settlement:
                    
                    let color = Color.green.opacity(0.9)
                    ZStack {
                        regularColor
                        color.opacity(0.25)
                            .border(color, width: 4)
                            .border(.background.opacity(0.5), width: 2)
                        EmbeddedSymbol(systemName: "house.lodge", color: color)
                    }
                    
                case .settlementTerritory(let owner, let developmentLevel):
                    
                    let side: PlayerSide = isDebugOn ? .currentPlayer : (
                        owner === game.currentPlayer ? .currentPlayer : .enemy
                    )
                    let color = Color.playerTheme(side: side)
                    ZStack {
                        regularColor
                            .border(color, width: 4)
                            .border(.background.opacity(0.5), width: 2)
                        VStack {
                            Text(String.init(repeating: "★", count: developmentLevel))
                                .font(.system(size: min(TileView.width, TileView.height) * 0.1))
                            EmbeddedSymbol(systemName: "building.2", color: color)
                            Text(owner.name)
                        }
                        .foregroundColor(color)
                    }
                    
                case .obstacle:
                    
                    Color.primary
                    
                case .aggression:
                    
                    let color = Color.red.opacity(0.5)
                    ZStack {
                        regularColor
                            .border(color, width: 4)
                            .border(.background.opacity(0.5), width: 2)
                        EmbeddedSymbol(systemName: "flame", color: color)
                    }
                    
                case .leap:
                    
                    let color = Color.yellow.opacity(0.5)
                    ZStack {
                        regularColor
                            .border(color, width: 4)
                            .border(.background.opacity(0.5), width: 2)
                        EmbeddedSymbol(systemName: "figure.gymnastics", color: color)
                    }
                    
                case .burst:
                    
                    let color = Color.green.opacity(0.5)
                    ZStack {
                        regularColor
                            .border(color, width: 4)
                            .border(.background.opacity(0.5), width: 2)
                        EmbeddedSymbol(systemName: "laurel.leading", color: color)
                    }
                    
                }
            }
            .frame(width: Self.width, height: Self.height, alignment: .center)
            if tile.isFogOfWarOn {
                Color.black.opacity(0.5)
            }
        }
        .onTapGesture {
            if isDebugOn {
                if tile.isFogOfWarOn {
                    tile.isFogOfWarOn = false
                    return
                }
                
                switch tile.type {
                case .regularTerritory(let owner, let defenseLevel):
                    tile.type = .regularTerritory(owner: owner, defenseLevel: min(defenseLevel + 1, 5))
                case .settlementTerritory(let owner, let developmentLevel):
                    tile.type = .settlementTerritory(owner: owner, developmentLevel: min(developmentLevel + 1, 10))
                case .settlement:
                    tile.type = .settlementTerritory(owner: Player(name: "TEST"), developmentLevel: 1)
                default:
                    tile.type = .regularTerritory(owner: Player(name: "TEST"), defenseLevel: 1)
                }
            } else {
                if tile.isFogOfWarOn { return }
                switch game.currentStep {
                case .place: 
                    let oldType = tile.type
                    if tile.captureAttempt(by: game.currentPlayer) {
                        game.currentInstructionText = InstructionsCatalog.noticeOccupySuccess(tileType: oldType, player: game.currentPlayer)
                    }
                case .remove:
                    tile.selfRemove(by: game.currentPlayer)
                }
                
                // mandatory updates
                game.goToNextStepIfNeeded()
                game.map.refreshFogOfWar(player: game.currentPlayer, step: game.currentStep)
                
                // respawn message
                if game.currentPlayer.didJustRespawn {
                    game.currentPlayer.didJustRespawn = false
                    game.currentInstructionText = InstructionsCatalog.respawn
                }
            }
        }
    }
}

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        let size = Map.numberOfTiles(for: 9)
        GeometryReader { proxy in
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                Grid(alignment: .center, horizontalSpacing: 0, verticalSpacing: 0) {
                    ForEach(0 ..< size) { _ in
                        GridRow {
                            ForEach(0 ..< size) { _ in
                                TileView(
                                    tile: Binding.constant(.init(
                                        type: .randomInitialSpawn(),
                                        isFogOfWarOn: true
                                    )),
                                    game: .init(),
                                    isDebugOn: true
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, proxy.size.width / 3)
                .padding(.vertical, proxy.size.height / 3)
            }
            .background(Color(.systemBackground))
        }
        .colorScheme(.dark)
    }
}
