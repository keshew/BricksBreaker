import SwiftUI

struct BrickSettingsView: View {
    @StateObject var brickSettingsModel =  BrickSettingsViewModel()
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var audioManager = AudioManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.mainBackground)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(.close)
                                    .resizable()
                                    .frame(width: 34, height: 34)
                                    .padding(.trailing, 30)
                                    .padding(.top, 20)
                            }
                        }
                        Text("Settings")
                            .FredokaOne(size: 60)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: geometry.size.height * 0.067) {
                        VStack {
                            Text("Music")
                                .FredokaOne(size: 50)
                            
                            CustomSlider(value: $audioManager.backgroundVolume,
                                         range: 0...1,
                                         sizeSlider: geometry.size.width * 0.589)
                        }
                        
                        VStack {
                            Text("Sound")
                                .FredokaOne(size: 50)
                            
                            CustomSlider(value: $audioManager.soundEffectVolume,
                                         range: 0...1,
                                         sizeSlider: geometry.size.width * 0.589,
                                         color: Color(red: 255/255, green: 188/255, blue: 6/255),
                                         image: BrickImageName.soundSliderPin.rawValue)
                        }
                     
                    }
                    .padding(.bottom, geometry.size.height * 0.132)
                    Spacer()
                }
                .onAppear {
                    let (backgroundVolume, soundEffectVolume) = UserDefaultsManager().loadVolumeSettings()
                    audioManager.backgroundVolume = backgroundVolume
                    audioManager.soundEffectVolume = soundEffectVolume
                }
                
                .onDisappear {
                    UserDefaultsManager().saveVolumeSettings(backgroundVolume: audioManager.backgroundVolume,
                                                                  soundEffectVolume: audioManager.soundEffectVolume)
                }
            }
           
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    BrickSettingsView()
}

