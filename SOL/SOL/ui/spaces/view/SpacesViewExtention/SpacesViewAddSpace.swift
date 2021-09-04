//
//  SpacesViewAddSpace.swift
//  SOL
//
//  Created by Rostislav Maslov on 03.09.2021.
//

import Foundation
import SwiftUI
import NavigationStack

extension SpacesView {
    func needCloseSheet(){
        model.onDissmisAddSpace()
        model.load()
    }
    
    var addSpaceSheet: some View {
        EmptyView()
            .sheet(isPresented: $model.showAddSpaceSheet, onDismiss:{
                model.onDissmisAddSpace()
            }) {
                AddSpaceView(viewModel: AddSpaceViewModel(needCloseSheet: self.needCloseSheet))
            }
            .background(SolColor.colors().screen.background)
            .preferredColorScheme(.light)
    }
}