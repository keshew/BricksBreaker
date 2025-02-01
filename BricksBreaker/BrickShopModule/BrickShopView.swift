import SwiftUI

struct BrickShopView: View {
    @StateObject var brickShopModel = BrickShopViewModel()
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
                            Text("level \(UserDefaultsManager.defaults.object(forKey: Keys.currentLevel.rawValue) as? Int ?? 1)")
                                .FredokaOne(size: 30, color: .white)
                                .padding(.leading, 25)
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
                        
                        Text("Shop")
                            .FredokaOne(size: 60, color: .white)
                    }
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: brickShopModel.columns, spacing: 20) {
                            ForEach(brickShopModel.userDefaultsManager.arrayOfBalls.indices, id: \.self) { index in
                                let ball = brickShopModel.userDefaultsManager.arrayOfBalls[index]
                                
                                if ball.isSelected {
                                    SelectedBall(name: ball.name,
                                                 image: ball.image,
                                                 text: "Selected")
                                } else if ball.isAvailible {
                                    AvailibleBall(name: ball.name,
                                                 image: ball.image,
                                                 text: "Available") {
                                        brickShopModel.userDefaultsManager.selectBall(at: index)
                                        brickShopModel.count = 1
                                    }
                                } else {
                                    LockedBall(name: ball.name,
                                                 image: ball.image,
                                                 text: ball.text)
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
    BrickShopView()
}
