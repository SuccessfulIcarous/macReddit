//
//  SidebarItemView.swift
//  macReddtr
//
//  Created by Brata on 24/07/21.
//

import SwiftUI
//import iReddtrLibrary

enum IconType {
    struct MenuData {
        let menuName: String
        let iconName: String
        
        static func AllSubRedditMenuData() -> MenuData {
            MenuData(menuName: "all", iconName: "star.fill")
        }
    }
    
    struct SubredditData {
        let subredditName: String
        let subredditIconUrl: String
    }
    case MenuIcon(IconType.MenuData)
    case SubredditIcon(IconType.SubredditData)
}

struct SidebarItemView: View {
    let data: IconType
    
    @Binding public private(set) var showText: Bool
    @Binding public private(set) var isSelected: Bool
    @Binding public private(set) var isExpanded: Bool
    
    var body: some View {
        HStack {
            switch data {
            case .MenuIcon(let menuData):
                Image(systemName: menuData.iconName)
                    .font(.largeTitle)
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            case .SubredditIcon:
                Image(systemName: "star.fill")
                    .font(.largeTitle)
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            }
//            if self.showText {
//                switch data {
//                case .MenuIcon(let menuData):
//                    Text(menuData.menuName)
//                default:
//                    <#code#>
//                }
//                Text("All")
//                Spacer()
//            }
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: {
            withAnimation {
            }
        })
        .padding(5)
        .overlay(ZStack(alignment: self.isExpanded ? .trailing : .center) {
            Color.black.opacity(self.isSelected ? 0.5 : 0.0)
            if self.isSelected {
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

struct SidebarItemView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarItemView(data:  IconType.MenuIcon(IconType.MenuData(menuName: "all", iconName: "star.fill")), showText: .constant(true), isSelected: .constant(false), isExpanded: .constant(true))
    }
}
