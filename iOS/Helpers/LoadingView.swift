//
//  LoadingView.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/4/12.
//

import SwiftUI

struct LoadingModifier: ViewModifier {
	@State var isLoading: Bool
	let opacity: Double
	let scale: CGFloat
	func body(content: Content) -> some View {
		content
			.environment(\.loading, $isLoading)
			.disabled(self.isLoading)
			.blur(radius: self.isLoading ? 3 : 0)
			.overlay(
				ZStack {
					if isLoading {
						Color.primary.opacity(opacity)
						ProgressView().progressViewStyle(CircularProgressViewStyle())
							.scaleEffect(scale, anchor: .center)
					}
				}.ignoresSafeArea(.all)
			)
	}
}

struct LoadingKey: EnvironmentKey {
	static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
	var loading: Binding<Bool> {
		get { self[LoadingKey.self] }
		set { self[LoadingKey.self] = newValue }
	}
}

extension View {

	func canLoad(state: Bool = false, opacity: Double = 0.05, scale: CGFloat = 1) -> some View {
		self.modifier(LoadingModifier(isLoading: state, opacity: opacity, scale: scale))
	}
}

//extension View {
//	func loading(_ state: Bool) -> some View {
//		self.preference(key: LoadingPreferenceKey.self, value: state)
//	}
//}
//
//private struct LoadingPreferenceKey: PreferenceKey {
//	static var defaultValue: Bool = false
//	static func reduce(value: inout Bool, nextValue: () -> Bool) {
//	}
//}
