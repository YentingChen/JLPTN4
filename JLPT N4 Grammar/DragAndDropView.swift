import SwiftUI

struct Word {
    var id:  Int
    var word: String
}

struct Offset {
    var viewIndex: Int = 0
    var order: Int = 0
    var width: Double = 0
    var height: Double = 0
    var x: Double = 0
    var y: Double = 0
    var originalX: Double = 0
    var originalY: Double = 0
}
extension View {
    func withoutAnimation() -> some View {
        self.animation(nil, value: UUID())
    }
}
struct WordView: View {
    var word: Word
    var wordOffSet = Offset()
    @State private var showThing = true
    var body: some View {
        ZStack {
            Text(word.word)
            
                .background(Color.white)
                .padding(4)
        }
        .background(Color.yellow)
        
    }
}

struct DragAndDropView: View {
    @State var left = true
    @State var wordViewList = [
        WordView(word: Word(id: 1, word: "お湯が")),
        WordView(word: Word(id: 1, word: "沸いたら")),
        WordView(word: Word(id: 1, word: "火を止めて")),
        WordView(word: Word(id: 1, word: "ください"))
    ]
    @State var offsets: [Offset] = []
    @State var isReady = false
    var spacing: Double = 10
    var body: some View {
        if (!isReady) {
            return AnyView(
                HStack(spacing: spacing ) {
                    ForEach(0 ..< wordViewList.count,  id: \.self) { index in
                        wordViewList[index]
                            .overlay {
                                GeometryReader { proxy in
                                    Color.clear.onAppear {
                                        let frame = proxy.frame(in: .global)
                                        let offset = Offset(viewIndex: index, order: index,
                                                            width: frame.width ,
                                                            height: frame.height,
                                                            x: frame.origin.x + frame.width / 2,
                                                            y: frame.origin.y + frame.height / 2,
                                                            originalX: frame.origin.x + frame.width / 2 ,
                                                            originalY: frame.origin.y + frame.height / 2)
                                        self.offsets.insert(offset, at: 0)
                                        wordViewList[index].wordOffSet = offset
                                        
                                    }
                                }
                                
                                
                            }.background(Color.purple)
                            .onAppear {
                                if index == 0 {
                                    isReady = true
                                    
                                }
                            }
                        
                    }
                    
                }
            )
        }
        
        return AnyView(
            ZStack() {
                ForEach(0 ..< wordViewList.count,  id: \.self) { index in
                    wordViewList[index]
                        .offset(x: offsets[index].x , y:offsets[index].y )
                        .gesture (
                            DragGesture()
                                .onChanged { value in
                                    //update its offset
                                    var offset = offsets[index]
                                    offset.x = value.location.x - offset.width/2
                                    offset.y = value.location.y - offset.height/2
                                    offsets[index] = offset

                                    if offset.originalX - offset.x > 0 {

                                        let closetIndex = closestIndex(current: offset.x, offsets: offsets, index: index)

                                        var closetOffset = offsets[closetIndex]

                                        if offsets[index].x - offsets[closetIndex].x < offset.width/2  {
                                            guard offsets[closetIndex].viewIndex < offset.viewIndex else {return }
                                            closetOffset.x = closetOffset.x + offset.width + spacing
                                            offsets[closetIndex] = closetOffset
                                            offsets[closetIndex].originalX = closetOffset.x
                                            offsets[index].originalX = offsets[index].originalX - closetOffset.width - spacing

                                            let currentViewIndex = offset.viewIndex
                                            let closetViewIndex =  closetOffset.viewIndex
                                            offsets[closetIndex].viewIndex = currentViewIndex
                                            offsets[index].viewIndex = closetViewIndex
                                        }


                                    } else {

                                        let closetIndex = closestIndex2(current: offset.x , offsets: offsets, index: index)
                                        var closetOffset = offsets[closetIndex]

                                        if offsets[closetIndex].x - offsets[index].x < offset.width/2  {
                                            guard offsets[closetIndex].viewIndex > offset.viewIndex else {return }
                                            closetOffset.x = closetOffset.x - offset.width - spacing
                                            offsets[closetIndex] = closetOffset
                                            offsets[closetIndex].originalX = closetOffset.x
                                            offsets[index].originalX = offsets[index].originalX + closetOffset.width + spacing

                                            let currentViewIndex = offset.viewIndex
                                            let closetViewIndex =  closetOffset.viewIndex
                                            offsets[closetIndex].viewIndex = currentViewIndex
                                            offsets[index].viewIndex = closetViewIndex
                                        }


                                    }


                                }
                                .onEnded { value in

                                    offsets[index].x = offsets[index].originalX
                                    offsets[index].y = offsets[index].originalY

                                }

                        )
                        .animation(.easeOut, value: offsets[index].x)


                }

                
                
                
            }
            
            
            
        )
        
    }
    
    func updatePosition(index: Int, closest: Int, width: Double) {
        
        guard offsets[closest].order < offsets[index].order else {return }
        guard offsets[closest].originalX == offsets[closest].x else {
            return
        }
        
        if offsets[index].x - offsets[closest].x < width  {
            offsets[closest].x = offsets[closest].x + width + spacing
            offsets[closest].originalX = offsets[closest].x
            offsets[index].originalX = offsets[index].originalX - offsets[closest].width - spacing
            
            let currentOder = offsets[index].order
            let previousOder =  offsets[closest].order
            offsets[closest].order = currentOder
            offsets[index].order = previousOder
            
            
        }
        
    }
    
    func updatePosition2(index: Int, closest: Int, width: Double) {
        guard offsets[closest].order > offsets[index].order else {return }
        guard offsets[closest].originalX == offsets[closest].x else {
            return
        }
        
        if offsets[closest].x - offsets[index].x < width  {
            offsets[closest].x = offsets[closest].x - width - spacing
            offsets[closest].originalX = offsets[closest].x
            offsets[index].originalX = offsets[index].originalX + offsets[closest].width + spacing
            
            let currentOder = offsets[index].order
            let previousOder =  offsets[closest].order
            offsets[closest].order = currentOder
            offsets[index].order = previousOder
            
            
        }
        
    }
    
    
    func closestIndex(current: Double, offsets: [Offset], index: Int) ->  Int {
        let sortedOffsets = offsets.filter({$0.x < current}).sorted(by: {$0.x > $1.x})
        
        let order = sortedOffsets.first?.order ?? index
        
        return order
        
    }
    
    func closestIndex2(current: Double, offsets: [Offset], index: Int) ->  Int {
        let sortedOffsets = offsets.filter({$0.x > current  }).sorted(by: {$0.x < $1.x})
        
        let order = sortedOffsets.first?.order ?? index
        
        return order
        
    }
    
}

