import SwiftUI

struct BricksLoseView: View {
    @StateObject var bricksLoseModel =  BricksLoseViewModel()
    @ObservedObject var audioManager = AudioManager.shared
    var level: Int
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black)
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Rectangle()
                            .fill(Color(red: 56/255, green: 45/255, blue: 81/255))
                            .frame(width: 295, height: 330)
                            .cornerRadius(20)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(red: 135/255, green: 120/255, blue: 174/255),
                                            lineWidth: 4)
                            }
                        VStack(spacing: 30) {
                            Text("Lose")
                                .FredokaOne(size: 60)
                            
                            NavigationLink(destination: BrickGameView(level: level)) {
                                ColorButtonView(text: "Restart",
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
            }
            .onAppear {
                audioManager.stopBackgroundMusic()
                audioManager.playLoseMusic()
            }
            
            .onDisappear {
                audioManager.stopLoseMusic()
                audioManager.playBackgroundMusic()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    BricksLoseView(level: 1)
}

