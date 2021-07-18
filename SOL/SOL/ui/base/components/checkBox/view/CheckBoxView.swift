//
//  CheckBoxView.swift
//  SOL
//
//  Created by Rostislav Maslov on 17.07.2021.
//

import SwiftUI

public enum CheckBoxSize {
    case NORMAL
    case BIG
}

struct CheckBoxView: View {
    
    @State var size:CheckBoxSize
    @State var done: Bool
    
    var body: some View {
        
        Button(action: {
            done = !done
        }, label: {
            ZStack{
                undoneImage
                if (done == true ) {
                    doneImage
                }
            }
        })
        
        
    }
    
    public init(size:CheckBoxSize, done: Bool){
        self.size = size
        self.done = done
    }
    
}

extension CheckBoxView{
    var undoneImage: some View {
        Image("ic_check_undone")
            .resizable()
            .renderingMode(.template)
            .frame(
                width: (self.size == .NORMAL ? 24 : 48),
                height: (self.size == .NORMAL ? 24 : 48),
                alignment: .center)
            .foregroundColor(
                done == true ?
                    SolColor.colors().checkBox.doneBackground :
                    SolColor.colors().checkBox.undoneBackground
            )
            .scaledToFill()
    }
}

extension CheckBoxView {
    var doneImage: some View {
        Image("ic_check_done")
            .resizable()
            .renderingMode(.template)
            .frame(
                width: (self.size == .NORMAL ? 12 : 16),
                height: (self.size == .NORMAL ? 8 : 12),
                alignment: .center)
            .foregroundColor(
                done == true ?
                    SolColor.colors().checkBox.doneBackground :
                    SolColor.colors().checkBox.undoneBackground
            )
            .scaledToFill()
    }
}

struct CheckBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CheckBoxView(size: .BIG, done: true)
    }
}
