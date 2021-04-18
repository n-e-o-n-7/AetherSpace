//
//  FrequencyShape.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/4/16.
//

import Combine
import SwiftUI

struct FrequencyShape: View {
	@ObservedObject var player: SoundPlayer
	@Binding var playing: Bool
	@State var cur: [Float] = []
    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
	var body: some View {
		VStack {
			HStack {
				ForEach(cur, id: \.self) { fac in
					Rectangle()
						.fill(Color.accentColor.opacity(0.4))
						.frame(height: 300 * CGFloat(fac))
				}
			}.frame(minWidth: 0, maxWidth: .infinity)
				.frame(height: 400)

		}.onReceive(timer) { _ in
			if playing {
				cur = player.analyseCur()
			}
		}
	}

	//	func action() {
	//		weak var wplayer = self.player
	//		Timer.publish(every: 0.05, on: .main, in: .default)
	//			.autoconnect().sink(receiveValue: { _ in
	//				//				print("s")
	//				//				print(wplayer?.analyseCur() ?? [])
	//				print(player.analyseCur())
	//			}).seal(in: token)
	//	}
}
