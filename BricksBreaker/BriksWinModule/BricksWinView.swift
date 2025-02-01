import SwiftUI

struct BricksWinView: View {
    @StateObject var BricksWinModel =  BricksWinViewModel()
    @ObservedObject var audioManager = AudioManager.shared
    var level: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.winBackground)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack(spacing: 70) {
                    Image(.winLabel)
                        .resizable()
                        .frame(width: 293, height: 88)
                    
                    VStack {
                        Text("level \(level)")
                            .FredokaOne(size: 20)
                        
                        Text("\(level * 100)")
                            .FredokaOne(size: 114, color: Color(red: 101/255, green: 255/255, blue: 182/255))
                        
                        Text("Completed!")
                            .FredokaOne(size: 20)
                    
                    }
                    
                    VStack(spacing: 30) {
                        NavigationLink(destination: BrickGameView(level: level + 1)) {
                            ColorButtonView(text: "Next",
                                            color: Color(red: 101/255, green: 255/255, blue: 218/255),
                                            geometry: geometry)
                        }
                        
                        NavigationLink(destination: BrickMenuView()) {
                            ColorButtonView(text: "Menu",
                                            color: Color(red: 255/255, green: 188/255, blue: 6/255),
                                            geometry: geometry)
                        }
                    }
                }
            }
            .onAppear {
                audioManager.stopBackgroundMusic()
                audioManager.playWinMusic()
            }
            
            .onDisappear {
                if UserDefaultsManager.defaults.object(forKey: Keys.currentLevel.rawValue) as? Int ?? 0 == level {
                    UserDefaultsManager().increaseLevel()
                }
                
                audioManager.stopWinMusic()
                audioManager.playBackgroundMusic()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    BricksWinView(level: 1)
}

