import SwiftUI

struct ColorButton: View {
    var action: (() -> ())
    var text: String
    var color: Color
    var geometry: GeometryProxy
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                color
                    .frame(width: geometry.size.width * 0.382,
                           height: geometry.size.height * 0.058)
                    .cornerRadius(6)
                
                Text(text)
                    .FredokaOne(size: 20, color: Color(red: 25/255, green: 36/255, blue: 79/255))
            }
        }
    }
}

struct ColorButtonView: View {
    var text: String
    var color: Color
    var geometry: GeometryProxy
    var body: some View {
        ZStack {
            color
                .frame(width: geometry.size.width * 0.382,
                       height: geometry.size.height * 0.058)
                .cornerRadius(6)
            
            Text(text)
                .FredokaOne(size: 20, color: Color(red: 25/255, green: 36/255, blue: 79/255))
        }
    }
}

struct CustomSlider: View {
    @Binding var value: Float
    let range: ClosedRange<Float>
    let thumbSize: CGFloat = 20
    let trackHeight: CGFloat = 10
    let sizeSlider: CGFloat
    var color: Color = Color(red: 101/255, green: 255/255, blue: 218/255)
    var image: String = BrickImageName.musicSliderPin.rawValue
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(red: 133/255, green: 120/255, blue: 172/255))
                    .frame(height: trackHeight)
                    .cornerRadius(8)
                
                Rectangle()
                    .fill(color)
                    .frame(width: max(0, CGFloat(normalizedValue) * geometry.size.width - 5), height: 6)
                    .cornerRadius(8)
                    .padding(.leading, 5)
                
                Image(image)
                    .resizable()
                    .frame(width: thumbSize, height: thumbSize)
                    .offset(x: CGFloat(normalizedValue) * (geometry.size.width - thumbSize))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                updateValue(with: gesture.location.x, in: geometry.size.width)
                            }
                    )
            }
        }
        .frame(width: sizeSlider, height: thumbSize)
    }
    
    private var normalizedValue: Float {
        return (value - range.lowerBound) / (range.upperBound - range.lowerBound)
    }
    
    private func updateValue(with locationX: CGFloat, in totalWidth: CGFloat) {
        let newValue = Float((locationX / totalWidth)) * (range.upperBound - range.lowerBound) + range.lowerBound
        value = min(max(newValue, range.lowerBound), range.upperBound)
    }
}

struct SelectedBall: View {
    var name: String
    var image: String
    var text: String
    var body: some View {
        ZStack {
            Color(red: 68/255, green: 51/255, blue: 140/255)
                .frame(width: 119, height: 153)
                .cornerRadius(10)
                .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(red: 101/255, green: 255/255, blue: 218/255),
                                    lineWidth: 2)
                    )

            Text(name)
                .FredokaOne(size: 24)
                .offset(y: -45)

            Image(image)
                .resizable()
                .frame(width: 34, height: 34)
                .offset(y: 3)

            Button(action: {

            }) {
                ZStack {
                    Color(red: 101/255, green: 255/255, blue: 218/255)
                        .frame(width: 91, height: 27)
                        .cornerRadius(6)

                    Text(text)
                        .FredokaOne(size: 16, color: Color(red: 25/255, green: 36/255, blue: 79/255))
                }
            }
            .offset(y: 50)
        }
        .padding(.top)
    }
}

struct AvailibleBall: View {
    var name: String
    var image: String
    var text: String
    var action: (() -> ())
    var body: some View {
        ZStack {
            Color(red: 68/255, green: 51/255, blue: 140/255)
                .frame(width: 119, height: 153)
                .cornerRadius(10)

            Text(name)
                .FredokaOne(size: 24)
                .offset(y: -45)

            Image(image)
                .resizable()
                .frame(width: 34, height: 34)
                .offset(y: 3)

            Button(action: {
                action()
            }) {
                ZStack {
                    Color(red: 120/255, green: 160/255, blue: 174/255)
                        .frame(width: 91, height: 27)
                        .cornerRadius(6)

                    Text(text)
                        .FredokaOne(size: 16, color: Color(red: 25/255, green: 36/255, blue: 79/255))
                }
            }
            .offset(y: 50)
        }
        .padding(.top)
    }
}

struct LockedBall: View {
    var name: String
    var image: String
    var text: String
    var body: some View {
        ZStack {
            Color(red: 68/255, green: 51/255, blue: 140/255)
                .frame(width: 119, height: 153)
                .cornerRadius(10)
            
            Text(name)
                .FredokaOne(size: 24)
                .offset(y: -45)
            
            Image(image)
                .resizable()
                .frame(width: 34, height: 34)
                .offset(y: 3)
            
            ZStack {
                Color(red: 113/255, green: 120/255, blue: 171/255)
                    .frame(width: 91, height: 27)
                    .cornerRadius(6)
                
                Text(text)
                    .FredokaOne(size: 16)
            }
            .offset(y: 50)
        }
        .padding(.top)
    }
}

struct DoneLevel: View {
    var text: String
    var body: some View {
        ZStack {
            Color(red: 120/255, green: 160/255, blue: 174/255)
                .frame(width: 70, height: 70)
                .cornerRadius(10)
            
            Text(text)
                .FredokaOne(size: 40)
        }
    }
}

struct CurrentLevel: View {
    var text: String
    var body: some View {
        ZStack {
            Color(red: 101/255, green: 255/255, blue: 218/255)
                .frame(width: 70, height: 70)
                .cornerRadius(10)
            
            Text(text)
                .FredokaOne(size: 40, color: Color(red: 25/255, green: 36/255, blue: 79/255))
        }
    }
}

struct LockedLevel: View {
    var body: some View {
        ZStack {
            Color(red: 136/255, green: 120/255, blue: 174/255)
                .frame(width: 70, height: 70)
                .cornerRadius(10)
            
            Image(.locked)
                .resizable()
                .frame(width: 40, height: 40)
        }
    }
}


