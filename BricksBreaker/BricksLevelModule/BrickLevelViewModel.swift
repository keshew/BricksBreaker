import SwiftUI

class BrickLevelViewModel: ObservableObject {
    let contact = BrickLevelModel()
    let columns = [
          GridItem(.flexible(), spacing: -40),
          GridItem(.flexible(), spacing: -40),
          GridItem(.flexible(), spacing: -40)
      ]
}
