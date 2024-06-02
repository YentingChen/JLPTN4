import SwiftUI

struct CapsuleLabel: View {
    var text: String
    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(BlogCardColorSet.grass)
                .font(Font.custom("NotoSans-Regular", fixedSize: 14))
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(BlogCardColorSet.mint, lineWidth: 1)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(BlogCardColorSet.honeydew)
                            
                        )
                )
        }
        
    }
}
