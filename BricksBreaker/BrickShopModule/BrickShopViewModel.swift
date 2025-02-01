import SwiftUI

class BrickShopViewModel: ObservableObject {
    @Published var userDefaultsManager = UserDefaultsManager()
    
    let columns = [
          GridItem(.flexible(), spacing: -60),
          GridItem(.flexible(), spacing: -60)
      ]
    
    @Published var count = 2
}
