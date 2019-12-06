//
//  BorderedLabel.swift
//  TopaceForReddit
//
//  Created by hesham on 11/26/18.
//  Copyright © 2018 hesham. All rights reserved.
//

import UIKit
import Atributika

class BorderedLabel: UILabel {

    private var textString: String
    let all = Style.font(UIFont.systemFont(ofSize: 16))
    let boldStyle = Style("strong").font(.boldSystemFont(ofSize: 16))
    let italicStyle = Style("em").font(.italicSystemFont(ofSize: 16))
    lazy var formattedText: NSAttributedString = {
        textString = self.replaceCharsIfExist(originalString: textString, toBeTruncated: "<!-- SC_OFF -->")
        textString = self.replaceCharsIfExist(originalString: textString, toBeTruncated: "<!-- SC_ON -->")
        return textString.style(tags: boldStyle, italicStyle).styleAll(all).attributedString
    }()
//    private let INSET_VAL = 4
    private var topInset: CGFloat = 8.0
    private var bottomInset: CGFloat = 8.0
    private var leftInset: CGFloat = 8.0
    private var rightInset: CGFloat = 8.0
//
//    private var htmlText : NSAttributedString? {
//        if let textHtml = textString {
//            let dataValue = textHtml.data(using: String.Encoding.unicode,
//                                          allowLossyConversion: true)!
//            if let attrStr = try? NSAttributedString(data: dataValue,
//                                                     options: [.documentType: NSAttributedString.DocumentType.html],
//                                                     documentAttributes: nil) {
//                return attrStr
//            }
//        }
//        return nil
//    }
//
//    private var formattedHtmlText : NSMutableAttributedString? {
//        if let htmlText = htmlText {
//            let mutableAttrString = NSMutableAttributedString(attributedString: htmlText)
//            if let lastCharacter = mutableAttrString.string.last, lastCharacter == "\n" {
//                mutableAttrString.deleteCharacters(in: NSRange(location: mutableAttrString.length-1, length: 1))
//            }
//            mutableAttrString.enumerateAttribute(
//                NSAttributedString.Key.font,
//                in:NSMakeRange(0,mutableAttrString.length),
//                options:.longestEffectiveRangeNotRequired) { value, range, stop in
//                    let f1 = value as! UIFont
//                    let f2 = UIFont.systemFont(ofSize: CGFloat(SMALL_FONT_SIZE))
//                    if let f3 = applyTraitsFromFont(f1, to:f2) {
//                        mutableAttrString.addAttribute(
//                            NSAttributedString.Key.font, value:f3, range:range)
//                    }
//            }
//            return mutableAttrString
//        }
//        return nil
//    }
//
    init(textStr: String?) {
        textString = textStr ?? ""
        super.init(frame: CGRect.zero)
//        textString = textStr
        setPropeties()
        self.attributedText = formattedText
//        self.sizeToFit()
    }
//
    private func setPropeties() {
//        self.font = UIFont.systemFont(ofSize: CGFloat(SMALL_FONT_SIZE))
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.blue.cgColor
//        self.textColor = .black
        self.backgroundColor = .white
        self.numberOfLines = 0
        self.lineBreakMode = NSLineBreakMode.byWordWrapping
    }
//
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
//
    override var intrinsicContentSize: CGSize {
        get {
            self.invalidateIntrinsicContentSize()
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
//            print("Number of lines: \(self.attributedText?.numberOfLines(with: self.frame.size.width))")
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
//
//    private func applyTraitsFromFont(_ f1: UIFont, to f2: UIFont) -> UIFont? {
//        let t = f1.fontDescriptor.symbolicTraits
//        if let fd = f2.fontDescriptor.withSymbolicTraits(t) {
//            return UIFont.init(descriptor: fd, size: 0)
//        }
//        return nil
//    }
//
//    private func heightForString(_ str : NSAttributedString, width : CGFloat) -> CGFloat {
//        let ts = NSTextStorage(attributedString: str)
//
//        let size = CGSize(width:width, height:CGFloat.greatestFiniteMagnitude)
//
//        let tc = NSTextContainer(size: size)
//        tc.lineFragmentPadding = 0.0
//
//        let lm = NSLayoutManager()
//        lm.addTextContainer(tc)
//
//        ts.addLayoutManager(lm)
//        lm.glyphRange(forBoundingRect: CGRect(origin:CGPoint(x:0,y:0),size:size), in: tc)
//
//        let rect = lm.usedRect(for: tc)
//        return rect.size.height
//    }
    func replaceCharsIfExist(originalString: String, toBeTruncated: String) -> String {
        if originalString.contains(toBeTruncated) {
            return originalString.replacingOccurrences(of: toBeTruncated, with: "", options: .regularExpression, range: nil)
        }
        return originalString
    }
}
