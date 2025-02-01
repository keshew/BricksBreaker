import SwiftUI

struct BrickLevelView: View {
    @StateObject var brickLevelModel =  BrickLevelViewModel()
    @Environment(\.presentationMode) var presentationMode
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
                            .padding(.trailing, 5)
                        }
                        
                        Text("Levels")
                            .FredokaOne(size: 60, color: .white)
                    }
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: brickLevelModel.columns, spacing: 40) {
                            ForEach(0..<40, id: \.self) { index in
                                if index < (UserDefaultsManager.defaults.object(forKey: Keys.currentLevel.rawValue) as? Int ?? 1) - 1 {
                                    NavigationLink(destination: BrickGameView(level: index + 1)) {
                                        DoneLevel(text: "\(index + 1)")
                                    }
                                } else if index == (UserDefaultsManager.defaults.object(forKey: Keys.currentLevel.rawValue) as? Int ?? 1) - 1 {
                                    NavigationLink(destination: BrickGameView(level: index + 1)) {
                                        CurrentLevel(text: "\(index + 1)")
                                    }
                                } else {
                                    LockedLevel()
                                }
                                
                            }
                            .padding(.bottom)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    BrickLevelView()
}

