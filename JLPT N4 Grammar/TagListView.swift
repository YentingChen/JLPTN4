import SwiftUI

struct RowsView: View {
    @StateObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ForEach(0..<viewModel.rows.count, id: \.self) { rowIndex in
                RowView(viewModel: viewModel, rowIndex: rowIndex)
                    .padding(0)
            }
        }
    }
}

struct RowView: View {
    @StateObject var viewModel: ContentViewModel
    var rowIndex: Int
    @State var isReady = false
    
    var body: some View {
        if !(isReady) {
            return AnyView(
                HStack(alignment: .center, spacing: 0) {
                    ForEach(0..<viewModel.rows[rowIndex].count, id: \.self) { colIndex in
                        TagViewListView1(viewModel: viewModel, rowIndex: rowIndex, colIndex: colIndex)
                            .onAppear {
                                if colIndex == 0 {
                                    isReady = true
                                    
                                }
                            }
                    }
                    
                }
            )
        }
        
        return AnyView(
            HStack(alignment: .center, spacing: 0) {
                ForEach(0..<viewModel.rows[rowIndex].count, id: \.self) { colIndex in
                    TagViewListView(viewModel: viewModel, rowIndex: rowIndex, colIndex: colIndex)
                }
            }
        )
        
    }
}

    
struct TagViewListView1: View {
    @StateObject var viewModel: ContentViewModel
    var rowIndex: Int
    var colIndex: Int
    
    var body: some View {
        Text(viewModel.rows[rowIndex][colIndex].name)
            
            
            .background {
                GeometryReader { proxy in
                    Color.clear.onAppear {
                        let frame = proxy.frame(in: .global)
                        let offset = Offset(viewIndex: 0, order: 0,
                                            width: frame.width ,
                                            height: frame.height,
                                            x: 100,
                                            y: 0 ,
                                            originalX: frame.origin.x + frame.width / 2 ,
                                            originalY: frame.origin.y + frame.height / 2)
                        viewModel.rows[rowIndex][colIndex].offset = offset

                    }
                }

            }
            
    }
}

struct TagViewListView: View {
    @StateObject var viewModel: ContentViewModel
    var rowIndex: Int
    var colIndex: Int
    
    var body: some View {
        Text(viewModel.rows[rowIndex][colIndex].name)
            
            
            
            .background(
                ZStack(alignment: .trailing) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .cornerRadius(14)
                }
            )
            .offset(x: 300, y: 0)
           
            .gesture (
                DragGesture()
                    .onChanged({ value in
                        
                        viewModel.rows[rowIndex][colIndex].offset.x = value.location.x
                        viewModel.rows[rowIndex][colIndex].offset.y = value.location.y
                        
                        if value.location.x < viewModel.rows[rowIndex][colIndex - 1].offset.x {
                            viewModel.rows[rowIndex][colIndex - 1].offset.x = viewModel.rows[rowIndex][colIndex].offset.originalX
                            
                        }
                    })
                    .onEnded({ value in
                        viewModel.rows[rowIndex][colIndex].offset.x = viewModel.rows[rowIndex][colIndex].offset.originalX
                        viewModel.rows[rowIndex][colIndex].offset.y = viewModel.rows[rowIndex][colIndex].offset.originalY
                    })
            )
            
    }
}

struct TagListView: View {
    
    @StateObject var viewModel = ContentViewModel()
    @State var aoffset: (CGFloat, CGFloat) = (0,0)
    
    var body: some View {
        RowsView(viewModel: viewModel)
    }
}

struct TagView: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.system(size: 16))
            .padding(.leading, 14)
            .padding(.trailing, 14)
            .padding(.vertical, 8)
            .background(
                ZStack(alignment: .trailing){
                    Rectangle()
                        .fill(.gray.opacity(0.3))
                        .cornerRadius(14)
                    
                }
            )
    }
}

struct Tag: Identifiable, Equatable, Hashable {
    var id = UUID().uuidString
    var name: String
    var size: CGFloat = 0
    var offset: Offset = Offset()
    
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


class ContentViewModel: ObservableObject{
    
    @Published var rows: [[Tag]] = []
    @Published var tags: [Tag] = [Tag(name: "XCode"), Tag(name: "IOS"), Tag(name: "IOS App Development"), Tag(name: "Swift"), Tag(name: "SwiftUI")]
    @Published var tagText = ""
    
    init(){
        getTags()
    }
    
    func addTag(){
        tags.append(Tag(name: tagText))
        tagText = ""
        getTags()
    }
    
    func removeTag(by id: String){
        tags = tags.filter{ $0.id != id }
        getTags()
    }
    
    
    func getTags(){
        var rows: [[Tag]] = []
        var currentRow: [Tag] = []
        
        var totalWidth: CGFloat = 0
        
        let screenWidth = UIScreen.screenWidth - 10
        let tagSpacing: CGFloat = 28
        
        if !tags.isEmpty{
            
            for index in 0..<tags.count{
                self.tags[index].size = tags[index].name.getSize()
            }
            
            tags.forEach{ tag in
                
                totalWidth += (tag.size + tagSpacing)
                
                if totalWidth > screenWidth{
                    totalWidth = (tag.size + tagSpacing)
                    rows.append(currentRow)
                    currentRow.removeAll()
                    currentRow.append(tag)
                }else{
                    currentRow.append(tag)
                }
            }
            
            if !currentRow.isEmpty{
                rows.append(currentRow)
                currentRow.removeAll()
            }
            
            self.rows = rows
        }else{
            self.rows = []
        }
        
    }
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.width
}

extension String{
    func getSize() -> CGFloat{
        let font = UIFont.systemFont(ofSize: 16)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: attributes)
        return size.width
    }
}
