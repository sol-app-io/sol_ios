//
//  LoginByEmail.swift
//  SOL
//
//  Created by Rostislav Maslov on 27.04.2021.
//

import SwiftUI
import Combine

struct LoginByEmailView: View {
    @ObservedObject var viewModel = LoginByEmailViewModel()
            
    init() {
        UINavigationBar.appearance().tintColor = .black
    }
    
    
    var body: some View {
        
            ZStack {
                NavigationLink(destination: SpacesView(), isActive: $viewModel.navigateToSpace) {}
                
                SolColor.colors().screen.background.edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    // basic usage
                    titleView
                    Spacer().frame(width: 1, height: 32, alignment: .center)
                    TextFieldLoginComponent(placeholder: "Email", value: $viewModel.email, secured: false, keyboardType: .emailAddress, state: $viewModel.state)
                    Spacer().frame(width: 0, height: 16, alignment: .center)
                    TextFieldLoginComponent(placeholder: "Password", value: $viewModel.password, secured: true, state: $viewModel.state)
                    Spacer().frame(height: 32.0)
                    ButtonComponent(title: "Submit", state: $viewModel.state,  action: self.viewModel.signUp)
                    Spacer().frame(width: 1, height: 100, alignment: .center)
                }.padding()
            
        }
        .onAppear(perform: {
        })
        .onDisappear(perform: {
        })
    }
}

struct LoginByEmail_Previews: PreviewProvider {
    static var previews: some View {
        LoginByEmailView()
            .preferredColorScheme(.light)
    }
}

extension LoginByEmailView{
    var titleView: some View {
        VStack(alignment: .leading){
            Text("Mail so mail,")
                .font(SolFonts.font(
                        size: 32,
                        weight: Font.Weight.heavy,
                        color: SolColor.colors().fontColors.normal))
                .multilineTextAlignment(.leading)
            Text("enter it")
                .font(SolFonts.font(
                        size: 32,
                        weight: Font.Weight.heavy,
                        color: SolColor.colors().fontColors.normal))
                .multilineTextAlignment(.leading)
            Text("and password")
                .font(SolFonts.font(
                        size: 32,
                        weight: Font.Weight.heavy,
                        color: SolColor.colors().fontColors.normal))
                .multilineTextAlignment(.leading)

        }
        
    }
}
