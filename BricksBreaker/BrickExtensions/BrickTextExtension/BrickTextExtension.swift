import SwiftUI

extension Text {
    func FredokaOne(size: CGFloat,
                    color: Color = .white) -> some View {
        self.font(.custom("FredokaOne-Regular", size: size))
        .foregroundColor(color)
            
    }
}

