import SwiftUI

struct GrammarCardView: View {
    @State private var isExpanded = false
    let text: String
    var contentList: [String]
    var body: some View {
        ZStack {
            Color.yellow
                .cornerRadius(12)
            VStack(alignment: .leading) {
                GrammarCardContentView(text: text, isExpanded: isExpanded, contentList: contentList)
            }
            
        }
        .onTapGesture {
            self.isExpanded = !self.isExpanded
        }
        .fixedSize(horizontal: false, vertical: true)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct GrammarCardContentView: View {
    let text: String
    var isExpanded: Bool
    var contentList: [String]
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(text)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                
                if isExpanded  {
                    Spacer()
                VStack(alignment: .leading) {
                        Spacer()
                        
                        ForEach(contentList, id: \.self) { content in
                            Text(content)
                        }
                        
                    }
                }
                
            }
            .frame(maxWidth: .infinity, alignment: isExpanded ? .leading : .center)
            .padding(24)
            
            
        }
        
    }
}
