import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Drag and drop") {
                    DragContainer(child: DragAndDropView())
                    
                }
                NavigationLink("Grammar List") {
                    GrammarList()
                }
                
                NavigationLink("TagList") {
                    TagListView()
                }
                
                NavigationLink("Blog Card") {
                    BlogCardScreen()
                }
                
            }
        }
    }
}

struct DragContainer<Content: View>: View {
    var child: Content
    var body: some View {
        child
        
    }
}
