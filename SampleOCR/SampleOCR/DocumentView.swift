//
//  DocumentView.swift
//  SampleOCR
//
//  Created by Nyghtwel on 7/9/18.
//  Copyright © 2018 Nyghtwel. All rights reserved.
//

import UIKit

class DocumentView: UIViewController {
    var message: String? {
        didSet {
            guard let message = message else { return }
            let attributes = [NSAttributedStringKey.font: UIFont(name: "UbuntuCondensed-Regular", size: 14)!,
                              NSAttributedStringKey.foregroundColor: UIColor.white]
            let attributedText = NSMutableAttributedString(string: message, attributes: attributes)
            messageText.attributedText = attributedText
        }
    }
    
    let messageText: UITextView = {
        let textView = UITextView()
        let attributes = [NSAttributedStringKey.font: UIFont(name: "UbuntuCondensed-Regular", size: 14)!,
                          NSAttributedStringKey.foregroundColor: UIColor.white]
        let attributedText = NSMutableAttributedString(string: "Demo\n\nhello\nworld", attributes: attributes)
        textView.attributedText = attributedText
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        view.addSubview(messageText)
        messageText.anchorCenterXToSuperview()
        messageText.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 114, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 290, height: 420)
    }
    
    private func setupNavbar() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 102/255, blue: 102/255, alpha: 0.8)
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
}
