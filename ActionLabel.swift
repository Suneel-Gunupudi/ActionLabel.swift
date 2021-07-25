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

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attributedText = label.attributedText else { return false }

        let mutableStr = NSMutableAttributedString.init(attributedString: attributedText)
        mutableStr.addAttributes([NSAttributedString.Key.font : label.font!], range: NSRange.init(location: 0, length: attributedText.length))

        // If the label have text alignment. Delete this code if label have a default (left) aligment. Possible to add the attribute in previous adding.
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        mutableStr.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: attributedText.length))

        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: mutableStr)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

