//
//  SoundWave.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/4/14.
//

import SwiftUI

struct SoundWave: ViewModifier {

	@Binding var playing: Bool

	func body(content: Content) -> some View {
		content
			.background(
				Group {
					if playing {
						ZStack {
							Circle()
								.stroke(Color.blue, lineWidth: 100)
								.scaleEffect(playing ? 1 : 0)
							Circle()
								.stroke(Color.blue, lineWidth: 100)
								.scaleEffect(playing ? 1.5 : 0)
							Circle()
								.stroke(Color.blue, lineWidth: 100)
								.scaleEffect(playing ? 2 : 0)
						}
						.opacity(playing ? 0.0 : 0.2)
						.animation(
							Animation.easeInOut(duration: 1).repeatForever(autoreverses: false))
					}
				}
			)
	}

}

extension View {
	func soundWave(playState: Binding<Bool>) -> some View {
		self.modifier(SoundWave(playing: playState))
	}
}
