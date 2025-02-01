import SwiftUI

@main
struct BricksBreakerApp: App {
    var body: some Scene {
        WindowGroup {
            BrickMenuView()
                .onAppear {
                    UserDefaultsManager().firstLaunch()
                }
        }
    }
}
