import SwiftUI

class Player {
    let name: String
    
    private(set) var score = 0
    
    var baseCapturesCount = 2
    var currentTurnRemainingCapturesCount = 2
    var didJustRespawn = false
    
    var abilityCounts = [Ability: Int]()
    private(set) var currentlyUsedAbility: Ability?
    
    private(set) var didSelfRemoveCurrentTurn = false
    
    init(name: String) {
        self.name = name
    }
    
    // MARK: turn logic
    
    internal func refreshTurn() {
        currentTurnRemainingCapturesCount = baseCapturesCount
        didSelfRemoveCurrentTurn = false
    }
    
    internal func didSelfRemove() {
        didSelfRemoveCurrentTurn = true
    }
    
    // MARK: capture logic
    
    /// Attempts to use a capture count; returns `true` if successful,
    /// returns `false` if unsuccessful
    internal func useCapture() -> Bool {
        guard currentTurnRemainingCapturesCount > 0 else { return false }
        currentTurnRemainingCapturesCount -= 1
        return true
    }
    
    internal func burst(by amount: Int) {
        currentTurnRemainingCapturesCount += amount
    }
    
    // MARK: ability logic
    
    /// Attempts to activate an ability; returns `true` if successful,
    /// returns `false` if unsuccessful
    internal func activateAbility(_ ability: Ability) -> Bool {
        guard 
            let count = abilityCounts[ability],
            count > 0
        else {
            deactivateCurrentAbility()
            return false
        }
        currentlyUsedAbility = ability
        return true
    }
    
    internal func deactivateCurrentAbility() {
        currentlyUsedAbility = nil
    }
    
    internal func commitCurrentAbility() {
        if 
            let ability = currentlyUsedAbility,
            let oldValue = abilityCounts[ability]
        {
            abilityCounts[ability] = max(oldValue - 1, 0)
            deactivateCurrentAbility()
        }
    }
    
    // MARK: settlement logic
    
    internal func gainSettlement(by increment: Int) {
        score += increment
        baseCapturesCount += increment
    }
    
    internal func loseSettlement(by decrement: Int) {
        score -= decrement
        baseCapturesCount -= decrement
    }
}
