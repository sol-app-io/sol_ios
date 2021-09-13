//
//  MultilineTextFieldModel.swift
//  SOL
//
//  Created by Rostislav Maslov on 21.08.2021.
//

import Foundation
import SwiftUI
import Combine

@objc public protocol MultilineTextFieldProtocol {
    func textDidChange(text: String)
    func textEditFinish(text: String)
    @objc optional func titleSizeDidChange(titleSize: CGFloat)
    @objc optional func multilineTextFieldView(view: UITextView)
}

public class MultilineTextFieldModel: NSObject, ObservableObject, UITextViewDelegate{
    @Published var detectFirstSizeTitle:Bool = false
    @Published var firstSizeTitle:CGFloat = 0
    @Published var titleSize:CGFloat = (24 + 8) * 1
        
    var textDidChange : ((_ text: String) -> Void)
    var textEditFinish : ((_ text: String) -> Void)
    var titleSizeDidChange : ((_ titleSize: CGFloat) -> Void)
    var multilineTextFieldView : ((_ view: UITextView) -> Void)
        
    init(
        textDidChange : @escaping ((_ text: String) -> Void),
        textEditFinish : @escaping ((_ text: String) -> Void),
        titleSizeDidChange : @escaping ((_ titleSize: CGFloat) -> Void),
        multilineTextFieldView : @escaping ((_ view: UITextView) -> Void)
    ){
        self.textDidChange = textDidChange
        self.textEditFinish = textEditFinish
        self.titleSizeDidChange = titleSizeDidChange
        self.multilineTextFieldView = multilineTextFieldView
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        let sizeThatFitsTextView = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat(MAXFLOAT)))
        let heightOfText = sizeThatFitsTextView.height
        
        DispatchQueue.main.async {
            self.titleSize = heightOfText
            self.firstSizeTitle = sizeThatFitsTextView.height
            self.detectFirstSizeTitle = true
            
            self.textDidChange(textView.text)
            self.titleSizeDidChange(self.titleSize)          
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            textEditFinish(textView.text)            
            return false
        }
        return true
    }
    
    func updateTitleSize(_ uiView: UITextView) {
        let sizeThatFitsTextView = uiView.sizeThatFits(CGSize(width: uiView.frame.size.width, height: CGFloat(MAXFLOAT)))
        let heightOfText = sizeThatFitsTextView.height
        
        if self.detectFirstSizeTitle == false || heightOfText != self.titleSize {
            self.titleSize = heightOfText
            self.firstSizeTitle = sizeThatFitsTextView.height
            self.detectFirstSizeTitle = true
            self.textViewDidChange(uiView)
        }
        
    }
}
