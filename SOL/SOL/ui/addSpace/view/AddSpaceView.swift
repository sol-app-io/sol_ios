//
//  AddSpaceScreen.swift
//  SOL
//
//  Created by Rostislav Maslov on 30.05.2021.
//

import SwiftUI


struct AddSpaceView: View {
    var spaceDidAdded: (() -> Void)
    
    @StateObject var viewModel:AddSpaceViewModel = AddSpaceViewModel()
    @EnvironmentObject var spaceStore: SpaceStore
    @State var placeholder: String = "🪐"
    @State var stopEditing = false
    
    var body: some View {
        ZStack {
            SolColor.colors().screen.background.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text("Create Space")
                        .font(SolFonts.font(
                                size: 32,
                                weight: Font.Weight.black,
                                color: SolColor.colors().fontColors.normal))
                    Spacer()
                }
                Spacer()
                    .frame(
                        width: 0,
                        height: 16,
                        alignment: .center)
                HStack {
                    IconFieldComponent(
                        placeholder: $placeholder,
                        emoji: $viewModel.emoji,
                        stopEditing: $stopEditing) {
                        }
                 
                    Spacer()
                        .frame(
                            width: 8,
                            height: 0,
                            alignment: .center)
                    TextFieldLoginComponent(
                        placeholder: "Title",
                        value: $viewModel.title,
                        secured: false,
                        keyboardType: .default,
                        state: $viewModel.state,
                        autocapitalization: UITextAutocapitalizationType.sentences)
                }
                Spacer()
                    .frame(
                        width: 0,
                        height: 16,
                        alignment: .center)
                ButtonComponent(title: "Create", state: $viewModel.state) {
                    viewModel.create()
                    spaceDidAdded()
                }
            }.padding()
        }
        .preferredColorScheme(.light)
        .onAppear(perform: {
            viewModel.spaceStore = spaceStore
        })
    }
}

//struct AddSpaceScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        AddSpaceView(viewModel: AddSpaceViewModel(needCloseSheet: {}))
//    }
//}
