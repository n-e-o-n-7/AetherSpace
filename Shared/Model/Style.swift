//
//  Style.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/5/17.
//

import Foundation
import SwiftUI

struct NodeStyle {
	var fontSize: Font = .title3
	var textColor: Color = .clear
	var shadow: ShadowType = .base
	var padding: CGFloat = 9
	var border: Bool = false
	var dash: Bool = false
	var lineWidth: CGFloat = 1
	var lineColor: Color = .black

}
enum StyleFont: String, CaseIterable {
	case largeTitle
	case title
	case headline
	case body
	case callout

	var font: Font {
		switch self {
		case .headline:
			return .headline
		case .body:
			return .body
		case .callout:
			return .callout
		case .largeTitle:
			return .largeTitle
		case .title:
			return .title3
		}
	}

	static func transform(font: Font) -> Self? {
		switch font {
		case .headline:
			return .headline
		case .body:
			return .body
		case .callout:
			return .callout
		case .largeTitle:
			return .largeTitle
		case .title3:
			return .title
		default:
			return nil
		}
	}
}

enum StyleColor: String, CaseIterable {
	case red
	case orange
	case yellow
	case green
	case blue
	case purple
	case pink
	case black
	case clear

	var color: Color {
		switch self {
		case .red:
			return .red
		case .orange:
			return .orange
		case .yellow:
			return .yellow
		case .green:
			return .green
		case .blue:
			return .blue
		case .purple:
			return .purple
		case .pink:
			return .pink
		case .black:
			return .black
		case .clear:
			return .clear
		}
	}

	static func transform(color: Color) -> Self? {
		switch color {
		case .red:
			return .red
		case .orange:
			return .orange
		case .yellow:
			return .yellow
		case .green:
			return .green
		case .blue:
			return .blue
		case .purple:
			return .purple
		case .pink:
			return .pink
		case .black:
			return .black
		case .clear:
			return .clear
		default:
			return nil
		}
	}
}
extension NodeStyle: Codable {
	enum CodingKeys: String, CodingKey {
		case fontSize
		case textColor
		case shadow
		case border
		case dash
		case lineWidth
		case lineColor
	}

	init(from decoder: Decoder) throws {

		let value = try decoder.container(keyedBy: CodingKeys.self)
		fontSize = StyleFont(rawValue: try value.decode(String.self, forKey: .fontSize))!.font

		textColor = StyleColor(rawValue: try value.decode(String.self, forKey: .textColor))!.color

		let shadowA: [ShadowType] = [.thin, .base, .thick]
		shadow = shadowA[try value.decode(Int.self, forKey: .shadow)]

		border = try value.decode(Bool.self, forKey: .border)
		dash = try value.decode(Bool.self, forKey: .dash)

		lineWidth = CGFloat(try value.decode(Float.self, forKey: .lineWidth))

		lineColor = StyleColor(rawValue: try value.decode(String.self, forKey: .lineColor))!.color

	}

	func encode(to encoder: Encoder) throws {
		var v = encoder.container(keyedBy: CodingKeys.self)

		try v.encode(StyleFont.transform(font: fontSize)!.rawValue, forKey: .fontSize)

		try v.encode(StyleColor.transform(color: textColor)!.rawValue, forKey: .textColor)

		let shadowD: [ShadowType: Int] = [.thin: 0, .base: 1, .thick: 2]
		try v.encode(shadowD[shadow], forKey: .shadow)

		try v.encode(border, forKey: .border)
		try v.encode(dash, forKey: .dash)
		try v.encode(Float(lineWidth), forKey: .lineWidth)
		try v.encode(StyleColor.transform(color: lineColor)!.rawValue, forKey: .lineColor)

	}
}
