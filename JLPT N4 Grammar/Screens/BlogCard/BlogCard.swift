import SwiftUI

struct BlogCard: View {
    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 0) {
                VStack {
                    Image("blogCard")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                VStack(alignment: .leading) {
                    CapsuleLabel(text: "Interior").padding(.bottom, 8)
                    Text("Top 5 Living Room Inspirations")
                        .font(.custom("NotoSans-SemiBold", fixedSize: 18)).padding(.bottom, 12)
                    
                    Text("Curated vibrants colors for your living, make it pop & calm in the same time.")
                        .font(.custom("NotoSans-Medium", fixedSize: 16))
                        .foregroundColor(BlogCardColorSet.davy)
                    HStack {
                        Button(action: {}) {
                            HStack {
                                Text("Read more")
                                    .font(.custom("NotoSans-medium", fixedSize: 16))
                                    .foregroundColor(BlogCardColorSet.majorelle)
                                Image( "arrow-right-line")
                            }
                        }
                        
                    }.padding(.top, 24)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
            }.cornerRadius(8).background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white))
            
        }.compositingGroup().shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1).shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        
    }
}
