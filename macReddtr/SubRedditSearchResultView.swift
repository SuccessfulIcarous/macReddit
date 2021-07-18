//
//  SubRedditSearchResultView.swift
//  macReddtr
//
//  Created by Brata on 18/07/21.
//

import SwiftUI
import NetworkImage

struct SubRedditSearchResultView: View {
    let imageUrl: String
    let title: String
    let description: String
    
    var body: some View {
        HStack {
            NetworkImage(url: URL(string: imageUrl)) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } fallback: {
                Image("default-reddit")
            }
            .scaledToFit()
            .frame(width: 100, height: 100)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .modifier(SubRedditSearchResultTitle())
                Text(description)
                    .modifier(SubRedditSearchResultDesc())
            }
            .padding()
            Spacer()
        }
        .padding()
    }
}

struct SubRedditSearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SubRedditSearchResultView(imageUrl: "https://b.thumbs.redditmedia.com/ZiAEtqQcDoI72L601xFToVXnp-VRwALa1ZviwnkZ3jg.png", title: "r/Gunners", description: "The Arsenal on Reddit")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .previewLayout(.fixed(width: 400.0, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
        
        SubRedditSearchResultView(imageUrl: "", title: "r/Gunners", description: "The Arsenal on Reddit")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .previewLayout(.fixed(width: 400.0, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
    }
}
