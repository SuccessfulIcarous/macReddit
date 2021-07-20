//
//  SidebarView.swift
//  macReddtr
//
//  Created by Brata on 20/07/21.
//

import SwiftUI

extension Animation {
    static func delayAnimation(time: Double) -> Animation {
        Animation.easeIn.speed(2.0).delay(time)
    }
}

struct SidebarView: View {
    @State private var isExpanded: Bool = false
    @State private var showText: Bool = false
    @State private var curWidth: CGFloat = minWidth
    @State private var selectedName: String = "all"
    
    private static let maxWidth: CGFloat = 250.0
    private static let minWidth: CGFloat = 60.0
    
    var body: some View {
        VStack(alignment: .trailing) {
            ScrollView() {
                LazyVStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.largeTitle)
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        if self.showText {
                            Text("All")
                            Spacer()
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture(perform: {
                        withAnimation {
                            self.selectedName = "all"
                        }
                    })
                    .padding(5)
                    .overlay(ZStack(alignment: self.isExpanded ? .trailing : .center) {
                        Color.black.opacity(self.selectedName == "all" ? 0.5 : 0.0)
                        if self.selectedName == "all" {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(Color.white)
                                .padding(.trailing, self.isExpanded ? 5 : 0)
                        }
                    })
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    HStack {
                        Image("default-reddit")
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        if self.showText {
                            Text("r/Gunners")
                            Spacer()
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture(perform: {
                        withAnimation {
                            self.selectedName = "gunners"
                        }
                    })
                    .padding(5)
                    .overlay(ZStack(alignment: self.isExpanded ? .trailing : .center) {
                        Color.black.opacity(self.selectedName == "gunners" ? 0.5 : 0.0)
                        if self.selectedName == "gunners" {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(Color.white)
                                .padding(.trailing, self.isExpanded ? 5 : 0)
                        }
                    })
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    HStack {
                        Image("default-reddit")
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        if self.showText {
                            Text("r/soccer")
                            Spacer()
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture(perform: {
                        withAnimation {
                            self.selectedName = "soccer"
                        }
                    })
                    .padding(5)
                    .overlay(ZStack(alignment: self.isExpanded ? .trailing : .center) {
                        Color.black.opacity(self.selectedName == "soccer" ? 0.5 : 0.0)
                        if self.selectedName == "soccer" {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(Color.white)
                                .padding(.trailing, self.isExpanded ? 5 : 0)
                        }
                    })
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
            .padding(.top, 50)
            .padding(.horizontal, 4)
            Button(action: {
                if self.isExpanded {
                    withAnimation(.easeIn) {
                        self.isExpanded.toggle()
                        self.showText = self.isExpanded
                        self.curWidth = self.isExpanded ? SidebarView.maxWidth : SidebarView.minWidth
                    }
                } else {
                    withAnimation(.easeIn) {
                        self.isExpanded.toggle()
                        self.curWidth = self.isExpanded ? SidebarView.maxWidth : SidebarView.minWidth
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            self.showText = self.isExpanded
                        }
                    }
                }
            }, label: {
                Image(systemName: self.isExpanded ? "chevron.backward.2" : "chevron.forward.2")
                    .padding()
            })
            .buttonStyle(PlainButtonStyle())
        }
        .background(Color.gray)
        .zIndex(8)
        .frame(width: self.curWidth)
        .shadow(radius: 8)
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
            .background(Color.gray)
    }
}
