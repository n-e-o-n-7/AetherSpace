//
//  SoundView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/22.
//

import SwiftUI

struct SoundContent: View {
	@Environment(\.presentationMode) var presentationMode

	@Binding var node: Node
	var content: NodeContent {
		node.contents.first!
	}
	@ObservedObject var player: SoundPlayer
	@State private var mode: DisplayMode = .frequency

	init(node: Binding<Node>) {
		_node = node
		player = SoundPlayer(data: node.wrappedValue.contents.first!.data!)
	}

	var body: some View {
		VStack {
			HStack {
				Button("cancel") {
					presentationMode.wrappedValue.dismiss()
				}
				Spacer()
				Picker("", selection: $mode) {
					ForEach(DisplayMode.allCases, id: \.self) { mode in
						Text(mode.rawValue).tag(mode)
					}
				}.pickerStyle(SegmentedPickerStyle())
					.frame(width: CGFloat(DisplayMode.allCases.count * 70))
			}
			.padding(15)
			VStack {
				Text(content.fileName!.replacingOccurrences(of: "%20", with: " "))
					.font(.largeTitle)
				Text(node.title)
					.font(.title3)
					.opacity(0.4)
				playerButton
				Group {
					if mode == .frequency && player.frequency.count != 0 {
						FrequencyShape(player: player, playing: $playing)
					} else if mode == .decibel && player.normal.count != 0 {
						DecibelShape(player: player, playing: $playing)
					} else {
						ProgressView().progressViewStyle(CircularProgressViewStyle())
					}
				}
			}.frame(minHeight: 0, maxHeight: .infinity)
		}
	}

	@State var playing = false
	var playerButton: some View {
		Button(
			action: {
				if !playing {
					player.play()
				} else {
					player.pause()
				}
				playing.toggle()
			},
			label: {
				Image(systemName: playing ? "pause.circle.fill" : "play.circle.fill")
					.resizable()
					.frame(width: 70, height: 70)
					.padding(30)
			}
		).onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
				player.inject(data: content.data!)
			}
		}
	}
}

private enum DisplayMode: String, CaseIterable {
	case frequency
	case decibel
}
