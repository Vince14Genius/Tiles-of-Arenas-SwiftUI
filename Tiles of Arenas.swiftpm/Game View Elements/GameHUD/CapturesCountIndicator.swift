import SwiftUI

struct CapturesCountIndicator: View {
    private let width = 48.0
    private let height = 48.0
    
    private var symbolFont: Font {
        Font.system(size: min(width, height) / 4, weight: .bold, design: .default)
    }
    
    var count: Int
    
    var body: some View {
        let color = Color.playerTheme(side: .currentPlayer)
        ZStack {
            Circle()
                .stroke(color, lineWidth: 2)
                .frame(width: width - 4, height: height - 4, alignment: .center)
                .background(.thickMaterial, in: Circle())
            VStack {
                Image(systemName: "flag")
                    .font(symbolFont)
                Text("\(count)")
            }
            .foregroundColor(color)
        }
        .frame(width: width, height: height, alignment: .center)
    }
}

struct CapturesCountIndicator_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CapturesCountIndicator(count: 0)
            CapturesCountIndicator(count: 1)
            CapturesCountIndicator(count: 2)
            CapturesCountIndicator(count: 14)
        }
        .colorScheme(.dark)
    }
}
