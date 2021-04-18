//
//  SoundShape.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/4/8.
//

import Combine
import SwiftUI

struct DecibelShape: View {
	@ObservedObject var player: SoundPlayer
	@Binding var playing: Bool

	let detector = CurrentValueSubject<Float, Never>(0)
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			ScrollViewReader { sproxy in
				VStack(alignment: .leading, spacing: 0) {
					HStack(spacing: 6) {
						ForEach(player.normal.indices, id: \.self) { index in
							Rectangle()
								.frame(width: 2, height: CGFloat(300 * player.normal[index] + 10))
								.opacity(0.7)
								.id(index)
						}
					}
					.frame(height: 400)
					.background(
						GeometryReader { proxy in
							Color.secondary.opacity(0.05)
								.preference(
									key: ScrollOffsetPercentPreferenceKey.self,
									value: Float(
										(UIScreen.main.bounds.width / 2
											- proxy.frame(in: .named("soundScroll")).origin.x)
											/ proxy.size.width)
								)
						})
					HStack(alignment: .top, spacing: 30) {
						ForEach(0..<player.normal.count / 4, id: \.self) { i in
							if i % 5 == 0 {
								VStack(spacing: 0) {
									Rectangle()
										.frame(width: 2, height: 21)
										.opacity(0.05)
									Text(
										"\(i/60):\(i%60 < 10 ? ("0" + String(i%60)) : String(i%60))"
									)
									.font(.caption)
									.opacity(0.7)
									.frame(width: 100, height: 40)
								}.frame(width: 2, height: 61)
							} else {
								Rectangle()
									.frame(width: 2, height: 10)
									.opacity(0.05)
							}
						}
					}
				}
				.background(
					GeometryReader { proxy in
						Color.clear

						//							.onChange(of: playing) { state in
						//								if state {
						//									Timer.publish(every: 0.25, on: .main, in: .default)
						//										.autoconnect().sink(receiveValue: { _ in
						//											withAnimation(.linear(duration: 0.25)) {
						//												print(Int(player.currentTime * 4))
						//												//												sproxy.scrollTo(
						//												//													Int(player.currentTime * 4), anchor: .center)
						//											}
						//										}).seal(in: token)
						//								} else {
						//									token.unseal()
						//								}
						//							}
					}
				)
				.padding(.horizontal, UIScreen.main.bounds.width / 2)
			}
		}
		.background(Color.secondary.opacity(0.05).frame(height: 400), alignment: .top)
		.overlay(
			Rectangle()
				.frame(width: 2, height: 400)
				.foregroundColor(Color.blue),
			alignment: .top
		)
		.coordinateSpace(name: "soundScroll")
		.onPreferenceChange(ScrollOffsetPercentPreferenceKey.self, perform: { detector.send($0) })
		.onReceive(
			detector.debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
				.dropFirst()
				.eraseToAnyPublisher()
		) {

			print("stop \($0)")
			player.jump(to: Double($0) * player.total)
		}
	}
}

private struct ScrollOffsetPercentPreferenceKey: PreferenceKey {
	static var defaultValue: Float = 0
	static func reduce(value: inout Float, nextValue: () -> Float) {}
}
