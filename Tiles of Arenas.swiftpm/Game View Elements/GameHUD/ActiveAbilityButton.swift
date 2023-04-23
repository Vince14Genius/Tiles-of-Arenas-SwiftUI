import SwiftUI

struct ActiveAbilityButton: View {
    private let width = 64.0
    private let height = 64.0
    
    let type: Ability
    var count: Int
    var step: GameObject.StepInTurn
    let block: () -> Void
    
    private let backgroundColor = Color(.secondarySystemBackground)
    private var symbolFont: Font {
        Font.system(size: min(width, height) / 3, weight: .bold, design: .default)
    }
    
    var body: some View {
        let isDisabled = count <= 0 || step != .place
        Button {
            block()
        } label: {
            switch type {
            case .aggression:
                let color = isDisabled ? .secondary : Color.red
                ZStack {
                    backgroundColor
                        .border(color, width: 4)
                        .border(.background.opacity(0.5), width: 2)
                    VStack {
                        Image(systemName: "flame")
                            .font(symbolFont)
                        Text(String(count))
                    }
                    .foregroundColor(color)
                }
            case .leap:
                let color = isDisabled ? .secondary : Color.yellow
                ZStack {
                    backgroundColor
                        .border(color, width: 4)
                        .border(.background.opacity(0.5), width: 2)
                    VStack {
                        Image(systemName: "figure.gymnastics")
                            .font(symbolFont)
                        Text(String(count))
                    }
                    .foregroundColor(color)
                }
            }
        }
        .frame(width: width, height: height, alignment: .center)
        .disabled(isDisabled)
    }
}

struct ActiveAbilityButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                ActiveAbilityButton(type: .aggression, count: 1, step: .place) {}
                ActiveAbilityButton(type: .leap, count: 3, step: .place) {}
                ActiveAbilityButton(type: .aggression, count: 0, step: .place) {}
                ActiveAbilityButton(type: .leap, count: 2, step: .remove) {}
            }
            .padding(4)
            .background(Color(.systemBackground), alignment: .center)
        }
        .colorScheme(.dark)
        .padding()
    }
}
