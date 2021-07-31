//
//  SearchSubRedditView.swift
//  macReddtr
//
//  Created by Brata on 18/07/21.
//

import SwiftUI
//import iReddtrLibrary
import NetworkImage

struct GrayBodyStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .foregroundColor(Color.gray)
    }
}

struct SearchSubRedditView: View {
    @State private var query: String = ""
    @State private var subredditsList: [SubredditData] = []
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search SubReddits", text: $query, onEditingChanged: { isEditing in
                    print("\(isEditing)")
                }, onCommit: {
//                    try? iReddtr.shared
//                        .searchSubreddits(query: query, limit: 10, nsfw: true, onDone: { result in
//                            switch result {
//                            case .Success(let listing):
//                                if let data = listing.data?.children {
//                                    subredditsList.removeAll()
//                                    subredditsList.append(contentsOf: data.map { subreddit in
//                                        subreddit.data!
//                                    })
//                                    print(subredditsList)
//                                }
//                            case .Error(let error):
//                                print(error)
//                            }
//                        })
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                Image(systemName: "magnifyingglass")
            }
            .padding()
            .frame(height: 50)
            ScrollView {
                ForEach(subredditsList) { subreddit in
                    let sData = subreddit.toSubreddit()
                    SubRedditSearchResultView(imageUrl: sData.iconImageUrl, title: sData.displayNamePrefixed, description: sData.title)
                }
            }
        }
        .frame(width: 300)
    }
}

struct SearchSubRedditView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSubRedditView()
            .previewLayout(.fixed(width: 300.0, height: 500.0))
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
