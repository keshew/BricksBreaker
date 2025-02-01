import SwiftUI
import SpriteKit

struct BrocksPauseView: View {
    @StateObject var brocksPauseModel =  BrocksPauseViewModel()
    var game: BrickGameData
    var scene: SKScene
    
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
                            Text("Pause")
                                .FredokaOne(size: 60)
                            
                            ColorButton(action: {
                                game.isPause = false
                                scene.isPaused = false
                            }, text: "Resume",
                                        color: Color(red: 101/255, green: 255/255, blue: 218/255),
                                        geometry: geometry)
                            
                            NavigationLink(destination: BrickMenuView()) {
                                ColorButtonView(text: "Menu",
                                                color: Color(red: 255/255, green: 188/255, blue: 6/255),
                                                geometry: geometry)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let gameData = BrickGameData()
    let scene = SKScene()
    return BrocksPauseView(game: gameData, scene: scene)
}

