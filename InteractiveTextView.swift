//
//  InteractiveTextView.swift
//  InteractiveTextView
//
//  Created by Ihab yasser on 12/10/2023.
//

import Foundation
import UIKit

class InteractiveTextView:UIView{
    
    class UnselectableTappableTextView: UITextView {
        override var selectedTextRange: UITextRange? {
            get { return nil }
            set {}
        }

        override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            if gestureRecognizer is UIPanGestureRecognizer {
                return super.gestureRecognizerShouldBegin(gestureRecognizer)
            }
            if let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer,
                tapGestureRecognizer.numberOfTapsRequired == 1 {
                return super.gestureRecognizerShouldBegin(gestureRecognizer)
            }
            if let longPressGestureRecognizer = gestureRecognizer as? UILongPressGestureRecognizer,
                longPressGestureRecognizer.minimumPressDuration < 0.325 {
                return super.gestureRecognizerShouldBegin(gestureRecognizer)
            }
            gestureRecognizer.isEnabled = false
            return false
        }
    }
    
    lazy var textView:UnselectableTappableTextView = { [unowned self] in
        let textView = UnselectableTappableTextView()
        textView.isSelectable = true
        textView.isEditable = false
        textView.delegate = self
        textView.isUserInteractionEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    let text:String
    let actions:[String]
    let tags:[String]
    let callback:((String) -> Void)
    
    init(text: String, actions: [String] , tags:[String] , callback: @escaping (String) -> Void) {
        self.text = text
        self.actions = actions
        self.callback = callback
        self.tags = tags
        super.init(frame: .zero)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(){
        addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        if tags.count != actions.count{
            assertionFailure("tags and actions should be same length.")
        }
        let attributedString = NSMutableAttributedString(string: text)
        for (index ,action) in actions.enumerated() {
            if let rang = text.ranges(of: action).first {
                let tag = tags[index]
                let words = tag.components(separatedBy: .whitespaces)
                if words.count > 1 {
                    assertionFailure("tags shouldn't be more than one word.")
                }else{
                    attributedString.addAttribute(.link, value: tag, range: rang)
                }
            }
        }
        textView.attributedText = attributedString
    }
    
    
}
extension InteractiveTextView:UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        callback(URL.absoluteString)
        return true
    }
}


extension String {
    func ranges(of substring: String) -> [NSRange] {
        var ranges: [NSRange] = []
        if self.range(of: substring) != nil {
            var searchRange = self.startIndex..<self.endIndex
            while let foundRange = self.range(of: substring, options: [], range: searchRange) {
                let nsRange = NSRange(foundRange, in: self)
                ranges.append(nsRange)
                searchRange = foundRange.upperBound..<self.endIndex
            }
        }
        return ranges
    }
}


