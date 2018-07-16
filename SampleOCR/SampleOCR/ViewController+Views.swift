//
//  ViewController+Views.swift
//  SampleOCR
//
//  Created by Nyghtwel on 7/9/18.
//  Copyright © 2018 Nyghtwel. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    let messageText: UITextView = {
        let textView = UITextView()
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedStringKey.font: UIFont(name: "Ubuntu-Bold", size: 14)!])
        textView.attributedText = attributedText
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let instantTextButton: UIButton = {
        let btn = UIButton()
        
        return btn
    }()
    
    let documentButton: UIButton = {
        let btn = UIButton()
        
        return btn
    }()
    
    private func setupViews() {
        
    }
    
    @objc func didTapInstantButton() {
        
    }
    
    @objc func didTapDocumentButton() {
        
    }
}
