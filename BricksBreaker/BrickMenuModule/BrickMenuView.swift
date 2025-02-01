import SwiftUI

struct BrickMenuView: View {
    @StateObject var brickMenuModel =  BrickMenuViewModel()
    @ObservedObject var audioManager = AudioManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack {
                    Image(.mainBackground)
                        .resizable()
                        .ignoresSafeArea()
                    
                    Image(.blocks)
                        .resizable()
                        .frame(width: geometry.size.width * 0.917,
                               height: geometry.size.height * 0.317)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 1.2)
                    
                    VStack(spacing: geometry.size.height * 0.09) {
                        Image(.menuLabel)
                            .resizable()
                            .frame(width: geometry.size.width * 0.542,
                                   height: geometry.size.height * 0.229)
                            .padding(.top, geometry.size.height * 0.027)
                        
                        VStack(spacing: geometry.size.height * 0.027) {
                            NavigationLink(destination: BrickLevelView()) {
                                ColorButtonView(text: "Play",
                                            color: Color(red: 101/255, green: 255/255, blue: 218/255),
                                            geometry: geometry)
                            }
                            
                            NavigationLink(destination: BrickShopView()) {
                                ColorButtonView(text: "Skins",
                                                color: Color(red: 255/255, green: 188/255, blue: 6/255),
                                                geometry: geometry)
                            }
                            
                            NavigationLink(destination: BrickSettingsView()) {
                                ColorButtonView(text: "Settings",
                                                color: Color(red: 255/255, green: 188/255, blue: 6/255),
                                                geometry: geometry)
                            }
                        }
                        Spacer()
                    }
                }
                .onAppear {
//                    let (backgroundVolume, soundEffectVolume) = UserDefaultsManager().loadVolumeSettings()
//                    audioManager.backgroundVolume = backgroundVolume
//                    audioManager.soundEffectVolume = soundEffectVolume
                    
                    audioManager.playBackgroundMusic()
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    BrickMenuView()
}

