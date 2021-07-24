//
//  ActionLabel.swift
//  OXYMON
//
//  Created by Suneel Gunupudi on 24/07/21.
//

import UIKit

@IBDesignable
class ActionLabel: UILabel {
    @IBInspectable var subText1: String? {
        didSet {
            configureLabel()
        }
    }
    @IBInspectable var subText2: String?{
        didSet {
            configureLabel()
        }
    }
    @IBInspectable var subText3: String?{
        didSet {
            configureLabel()
        }
    }
    @IBInspectable var subText4: String?{
        didSet {
            configureLabel()
        }
    }
    @IBInspectable var subText5: String?{
        didSet {
            configureLabel()
        }
    }

    var subTextArray: [String] = []
    var didSelectSubText: ((_ subText: String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setupUI() {
        isUserInteractionEnabled = true
        lineBreakMode = .byWordWrapping
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tappedOnLabel(_:)))
        tapGesture.numberOfTouchesRequired = 1
        addGestureRecognizer(tapGesture)
        configureLabel()
    }

    func configureLabel() {
        let aSubTextArray = [subText1, subText2, subText3, subText4, subText5]
        subTextArray = aSubTextArray.compactMap { $0 }

        guard let text = text else { return }
        let underlineAttriString = NSMutableAttributedString(string: text)
        for subText in subTextArray {
            let range = (text as NSString).range(of: subText)
            underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: range)
            underlineAttriString.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.systemBlue, range: range)
        }
        attributedText = underlineAttriString
    }

    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let subText = getLinkFromGesture(gesture) else { return }
        didSelectSubText?(subText)
    }

    func getLinkFromGesture(_ gesture: UITapGestureRecognizer) -> String? {
            guard let text = text else { return  nil }

            for subText in subTextArray {
                let rangeText = (text as NSString).range(of: subText)
                if gesture.didTapAttributedTextInLabel(label: self, inRange: rangeText) {
                    return subText
                }
            }
            return nil
        }
}
