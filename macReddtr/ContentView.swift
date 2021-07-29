//
//  ContentView.swift
//  macReddtr
//
//  Created by Brata on 02/07/21.
//

import SwiftUI
import Combine
import NetworkImage
import WebKit
import MarkdownUI

public enum Menu {
    case AllStream
    case Search
    case Setting
    case FavoriteSubreddit(Subreddit)
}

extension Menu: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .FavoriteSubreddit(let subreddit):
            hasher.combine("subreddit")
            hasher.combine(subreddit.id)
        default:
            hasher.combine(self)
        }
    }
}

struct SidebarFavoriteItem: View {
    var subreddit: Subreddit
    @Binding var selected: Menu?
    
    var body: some View {
        NavigationLink(
            destination: Text(subreddit.displayNamePrefixed),
            tag: Menu.FavoriteSubreddit(
                subreddit
            ),
            selection: $selected
        ) {
            HStack {
                Text(subreddit.displayNamePrefixed)
                Spacer()
                Image(systemName: "star.fill")
            }
        }
    }
}

struct SearchSubreddit: View {
    @EnvironmentObject private var store: GlobalStore
    @State private var query: String = ""
    @State var searchResult = [Subreddit]()
    @State private var cancellable: AnyCancellable?
    @State private var selectedResult: String?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                TextField("Search Subreddit", text: $query) { _ in
                    
                } onCommit: {
                    print(query)
                    self.cancellable = try? store.api.searchSubreddits(query: query, limit: 100, nsfw: true, resultQueue: DispatchQueue.main)
                        .sink { _ in
                            
                        } receiveValue: { listing in
                            if let listingData = listing.data?.children {
                                self.searchResult = listingData.map({ $0.data!.toSubreddit() })
                            }
                            self.cancellable = nil
                        }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(5)
                List {
                    ForEach(searchResult, id: \.id) { subreddit in
                        NavigationLink(destination: Text(subreddit.displayName), tag: subreddit.id, selection: $selectedResult) {
                            SearchResult(imageUrl: subreddit.iconImageUrl, title: subreddit.displayNamePrefixed, description: subreddit.title)
                                .onAppear {
                                    print(subreddit)
                                }
                        }
                    }
                }
            }
            .frame(minWidth: 250)
        }
    }
}

struct SearchResult: View {
    let imageUrl: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 10) {
            NetworkImage(url: URL(string: imageUrl)) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } fallback: {
                Image("default-reddit")
            }
            .scaledToFit()
            .frame(width: 40, height: 40)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                Text(description)
            }
            Spacer()
        }
    }
}

struct PostList: View {
    @EnvironmentObject private var store: GlobalStore
    @State var posts: [Post] = []
    @State private var cancellable: AnyCancellable?
    @State private var selected: String?
    var isPreview = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.posts) { post in
                    NavigationLink(post.title, destination: PostDetail(content: post), tag: post.id, selection: $selected)
                        .onAppear {
                            print(post)
                        }
                    
                }
            }
            .frame(minWidth: 400)
        }
        .onAppear {
            if !self.isPreview {
                let param = APIParam()
                    .setLimit(100)
                    .setSortType(.new)
                self.cancellable = try? store.api.getPostsFor(subredditNames: ["Gunners"], params: param)
                    .sink(receiveCompletion: { _ in
                        
                    }, receiveValue: { postlisting in
                        if let listingData = postlisting.data?.children {
                            self.posts = listingData.map({ $0.data!.toPost() })
                        }
                        self.cancellable = nil
                    })
            }
        }
    }
}

struct PostDetail: View {
    let content: Post
    
    var body: some View {
        ScrollView {
            Markdown(Document(content.selftext))
        }
        .padding()
    }
}

struct HtmlView: NSViewRepresentable {
    @State var content: String
    
    func makeNSView(context: Context) -> some NSView {
        return WKWebView()
            
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        (nsView as! WKWebView).loadHTMLString(content, baseURL: nil)
    }
}

struct ContentView: View {
    @EnvironmentObject var store: GlobalStore
    @State private var selected: Menu? = .AllStream
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink("All", destination: PostList(), tag: Menu.AllStream, selection: $selected)
                NavigationLink("Search", destination: SearchSubreddit(), tag: Menu.Search, selection: $selected)
                NavigationLink("Setting", destination: Text("Setting"), tag: Menu.Setting, selection: $selected)
                
                Spacer()
                
                Section(header: Text("Favorites")) {
                    ForEach(store.favoritedSubreddits, id: \.id) { subreddit in
                        SidebarFavoriteItem(
                            subreddit: subreddit,
                            selected: $selected
                        )
                    }
                }
            }
            .frame(minWidth: 200)
            .listStyle(SidebarListStyle())
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let store = GlobalStore()
        ContentView()
            .environmentObject(store)
            .onAppear {
                store.addSubredditAsFavorite(subreddit: SAMPLE_SUBREDDIT)
            }
        
        SearchSubreddit(searchResult: [SAMPLE_SUBREDDIT])
            .environmentObject(store)
        
        PostList(posts: [SAMPLE_POST], isPreview: true)
            .environmentObject(store)
        
        PostDetail(content: SAMPLE_POST)
            .environmentObject(store)
    }
}
