//
//  AppState.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/3/29.
//

import SwiftUI

struct AppState {
}

enum ColorSet: String, CaseIterable {
	case red
	case orange
	case yellow
	case green
	case blue
	case purple
	case pink

	func toColor() -> Color {
		switch self {
		case .red:
			return Color.red
		case .orange:
			return Color.orange
		case .yellow:
			return Color.yellow
		case .green:
			return Color.green
		case .blue:
			return Color.blue
		case .purple:
			return Color.purple
		case .pink:
			return Color.pink
		}
	}
}
