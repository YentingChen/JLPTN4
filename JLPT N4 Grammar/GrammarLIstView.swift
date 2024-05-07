import SwiftUI

struct GrammarObject {
    let title: String
    let content: [String]
}

struct GrammarList: View {
    let textArray: [GrammarObject] = [
        GrammarObject(title: "〜に", content:  ["文法1", "文法2", "文法3"]),
        GrammarObject(title: "〜ため(に)", content:  ["Vる+ために", "Nの ＋ ために", "意志動詞", "前、後文的主語，必須是同一人"]),
        GrammarObject(title: "〜ように", content:  ["-為了⋯目的，而做⋯努力","Vる+ように","-前文必須接無意志動詞，而後文通常是努力的內容", "-電車に間まに合う ように 、走ります", "(為了要趕上電車，用跑的。)"])
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text("第10課")
                .font(.largeTitle)
            Spacer()
            Text("表目的")
                .font(.title)

            List(textArray.indices, id: \.self) { index in
                GrammarCardView(text: textArray[index].title, contentList: textArray[index].content)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))

            }
            .listStyle(.plain)

        }
        .padding(16)

    }
}

