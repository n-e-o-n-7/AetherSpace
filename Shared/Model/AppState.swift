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
		}
	}
}
