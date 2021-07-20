//
//  TextStyles.swift
//  macReddtr
//
//  Created by Brata on 18/07/21.
//

import SwiftUI

struct SubRedditSearchResultTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.headline, design: .serif))
    }
}

struct SubRedditSearchResultDesc: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.subheadline, design: .serif))
    }
}
