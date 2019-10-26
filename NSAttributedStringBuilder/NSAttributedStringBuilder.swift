//
//  NSAttributedStringBuilder.swift
//  Playground
//
//  Created by Lukáš Hromadník on 26/10/2019.
//  Copyright © 2019 Lukáš Hromadník. All rights reserved.
//

import UIKit

typealias Attributes = [NSAttributedString.Key: Any]

protocol Attribute {
    var value: Attributes { get }
}

class AttributesComposite: Attribute {
    var value: Attributes = [:]

    func update(_ attributes: Attributes) {
        for (key, item) in attributes {
            switch key {
            case .paragraphStyle:
                guard let currentStyle = value[key] as? NSParagraphStyle else { fallthrough }
                guard let newStyle = item as? NSParagraphStyle else { break }
                value[key] = currentStyle + newStyle
            default:
                value[key] = item
            }
        }
    }
}

@_functionBuilder
struct NSAttributedStringBuilder {
    static func buildBlock(_ segments: Attribute...) -> Attribute {
        segments.map { $0.value }.reduce(AttributesComposite()) { acc, next in
            acc.update(next)
            return acc
        }
    }
}

struct Foreground: Attribute {
    let color: UIColor
    var value: Attributes { [.foregroundColor: color] }

    init(_ color: UIColor) {
        self.color = color
    }
}

struct LineHeight: Attribute {
    let minimumLineHeight: CGFloat
    let maximumLineHeight: CGFloat
    var value: Attributes {
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = minimumLineHeight
        style.maximumLineHeight = maximumLineHeight
        return [.paragraphStyle: style]
    }
}

extension LineHeight {
    init(_ lineHeight: CGFloat) {
        minimumLineHeight = lineHeight
        maximumLineHeight = lineHeight
    }
}

struct LineBreakMode: Attribute {
    let lineBreakMode: NSLineBreakMode

    init(_ lineBreakMode: NSLineBreakMode) {
        self.lineBreakMode = lineBreakMode
    }

    var value: Attributes {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = lineBreakMode
        return [.paragraphStyle: style]
    }
}

extension NSAttributedString {
    convenience init(_ text: String, @NSAttributedStringBuilder _ content: () -> Attribute) {
        self.init(string: text, attributes: content().value)
    }
}

extension NSMutableAttributedString {
    func addAttribute(_ key: NSAttributedString.Key, value: Any) {
        addAttribute(key, value: value, range: NSRange(location: 0, length: length))
    }
}

func + <T: NSParagraphStyle> (lhs: T, rhs: T) -> NSParagraphStyle {
    let style = NSMutableParagraphStyle()
    style.setParagraphStyle(lhs)
    if rhs.lineSpacing != NSParagraphStyle.default.lineSpacing {
        style.lineSpacing = rhs.lineSpacing
    }
    if rhs.paragraphSpacing != NSParagraphStyle.default.paragraphSpacing {
        style.paragraphSpacing = rhs.paragraphSpacing
    }
    if rhs.alignment != NSParagraphStyle.default.alignment {
        style.alignment = rhs.alignment
    }
    if rhs.firstLineHeadIndent != NSParagraphStyle.default.firstLineHeadIndent {
        style.firstLineHeadIndent = rhs.firstLineHeadIndent
    }
    if rhs.headIndent != NSParagraphStyle.default.headIndent {
        style.headIndent = rhs.headIndent
    }
    if rhs.tailIndent != NSParagraphStyle.default.tailIndent {
        style.tailIndent = rhs.tailIndent
    }
    if rhs.lineBreakMode != NSParagraphStyle.default.lineBreakMode {
        style.lineBreakMode = rhs.lineBreakMode
    }
    if rhs.minimumLineHeight != NSParagraphStyle.default.minimumLineHeight {
        style.minimumLineHeight = rhs.minimumLineHeight
    }
    if rhs.maximumLineHeight != NSParagraphStyle.default.maximumLineHeight {
        style.maximumLineHeight = rhs.maximumLineHeight
    }
    if rhs.baseWritingDirection != NSParagraphStyle.default.baseWritingDirection {
        style.baseWritingDirection = rhs.baseWritingDirection
    }
    if rhs.lineHeightMultiple != NSParagraphStyle.default.lineHeightMultiple {
        style.lineHeightMultiple = rhs.lineHeightMultiple
    }
    if rhs.paragraphSpacingBefore != NSParagraphStyle.default.paragraphSpacingBefore {
        style.paragraphSpacingBefore = rhs.paragraphSpacingBefore
    }
    if rhs.hyphenationFactor != NSParagraphStyle.default.hyphenationFactor {
        style.hyphenationFactor = rhs.hyphenationFactor
    }
    if rhs.tabStops != NSParagraphStyle.default.tabStops {
        style.tabStops = rhs.tabStops
    }
    if rhs.defaultTabInterval != NSParagraphStyle.default.defaultTabInterval {
        style.defaultTabInterval = rhs.defaultTabInterval
    }
    if rhs.allowsDefaultTighteningForTruncation != NSParagraphStyle.default.allowsDefaultTighteningForTruncation {
        style.allowsDefaultTighteningForTruncation = rhs.allowsDefaultTighteningForTruncation
    }
    return style
}
