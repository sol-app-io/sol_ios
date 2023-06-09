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
                    NavigationLink(
                        destination: ViewWithTasksView(viewId: viewUser.id)) {
                            StoryComponent(viewUser.id)
                        }.buttonStyle(.plain)
                    Spacer().frame(width: 20.0, height: 1.0, alignment: Alignment.center)
                }                                
                NavigationLink(
                    destination: CustomizeViewPage()) {
                        StoryConfigButtonComponent()
                    }.buttonStyle(.plain)
                Spacer().frame(width: 30, height: 10)
                Spacer()
            }
        }
        .frame(height: 90)
        .onAppear {            
        }
    }
}

struct StoriesComponent_Previews: PreviewProvider {
    static var previews: some View {
        StoriesComponent()
            .preferredColorScheme(.light)
    }
}
