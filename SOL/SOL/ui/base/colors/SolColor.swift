//
//  SolColor.swift
//  SOL
//
//  Created by Rostislav Maslov on 22.05.2021.
//

import Foundation
import SwiftUI

struct ColorsVar {
    var fontColors: FontColors
    var textField: TextFieldColors
    var button: ButtonColors
    var screen: ScreenColors
    var stories: StoriesColors
    var addTask: AddTask
    var checkBox: CheckBox
    var actionButton:ActionButton
    var taskLine: TaskLine
    var filterButton: FilterButton
}

struct FontColors {
    var normal: Color
    var dangerous: Color
    var second: Color
}

struct TextFieldColors {
    var login: Color
}

struct ScreenColors{
    var background: Color
}

struct StoriesColors{
    var background: Color
    var countFontHasNew: Color
    var countFontNoNew: Color
}

struct ButtonColors {
    var background: Color
    var backgroundLoading: Color
    var font: Color
}

struct AddTask{
    var placeholderBackground: Color
    var placeholderTextDefault: Color
    var placeholderTextFill: Color
    var addTaskBackground: Color
    var taskButtonDefaultColor: Color
    var taskButtonActiveColor: Color
}

struct CheckBox{
    var undoneBackground: Color
    var doneBackground: Color
}

struct ActionButton {
    var background: Color
    var taskDone: Color
}

struct TaskLine{
    var container: Color
    var containerDone: Color
    var divider: Color
}

struct FilterButton{
    var font: Color
    var background: Color
}

class SolColor{
    
    static func colors() -> ColorsVar {
        //        if( UIScreen.main.traitCollection.userInterfaceStyle == .light ) { return lightColors() }
        //        return darkColors()
        return lightColors()
    }
    
    static func lightColors() -> ColorsVar {
        let colors: ColorsVar = ColorsVar(
            fontColors: FontColors(
                normal: Color(CGColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1)),
                dangerous: Color(CGColor(red: 127/255, green: 0/255, blue: 0/255, alpha: 1)),
                second: Color(CGColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1))                
            ),
            textField: TextFieldColors(
                login: Color(CGColor(red: 248/255, green: 249/255, blue: 255/255, alpha: 1))
            ),
            button: ButtonColors(
                background: Color(CGColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1)),
                backgroundLoading: Color(CGColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 0.6)),
                font: Color(CGColor(red: 243/255, green: 244/255, blue: 256/255, alpha: 1))
            ),
            
            screen: ScreenColors(background: Color(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1))),
            
            stories: StoriesColors(
                background: Color(CGColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)),
                countFontHasNew:  Color(CGColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)),
                countFontNoNew:  Color(CGColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1))
            ),
            
            addTask: AddTask(
                placeholderBackground: Color(CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)),
                placeholderTextDefault: Color(CGColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)),
                placeholderTextFill: .white,
                addTaskBackground: Color(CGColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1.0)),
                taskButtonDefaultColor: Color(CGColor(red: 175/255, green: 175/255, blue: 175/255, alpha: 1.0)),
                taskButtonActiveColor: Color(CGColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1.0))
            ),
            
            checkBox: CheckBox(
                undoneBackground: Color(CGColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1.0)),
                doneBackground: Color(CGColor(red: 229/255, green: 230/255, blue: 241/255, alpha: 1.0))
            ),
            
            actionButton: ActionButton(
                background: Color(red: 246/255,green: 246/255,blue: 246/255),
                taskDone: Color(red:28/255, green: 206/255, blue: 12/255)
            ),
             
            taskLine: TaskLine(
                container: Color(red: 246/255, green:  246/255, blue:  246/255, opacity:  1),
                containerDone: Color(red: 96/255, green:  96/255, blue:  96/255, opacity:  1),
                divider: Color(red: 236/255, green:  236/255, blue:  236/255, opacity:  1)
            ),
            
            filterButton: FilterButton(font: Color.white, background: Color(red:68/255, green:68/255, blue:68/255, opacity: 1))
        )
        return colors
    }
    
    //    static func darkColors() -> ColorsVar {
    //        let colors: ColorsVar = ColorsVar(background: Color.white, buttonBackground: Color.white, storiesGradient: Color.white, fontColors: FontColors(normal: Color.white, second: Color.white))
    //
    //        return colors
    //    }
    
}
