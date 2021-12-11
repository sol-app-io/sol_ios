//
//  StoriesComponent.swift
//  SOL
//
//  Created by Rostislav Maslov on 10.05.2021.
//

import SwiftUI

struct StoriesComponent: View {
    @EnvironmentObject var viewStore: ViewUserStore
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                Spacer().frame(width: 10, height: 10, alignment: .center)
                ForEach(viewStore.root, id: \.id)  { viewUser in
                    StoryComponent(viewUser.id)
                }
                Spacer()
            }
        }
        .frame(height: 90)
        .onAppear {
            viewStore.sync()
        }
    }
}

struct StoriesComponent_Previews: PreviewProvider {
    static var previews: some View {
        StoriesComponent()
            .preferredColorScheme(.light)
    }
}
