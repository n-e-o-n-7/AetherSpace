//
//  SoundShape.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/4/8.
//

import AVFoundation
import Accelerate
import Combine
import SwiftUI

struct SoundShape: View {
	//    private lazy var fftSetup = vDSP_create_fftsetup(vDSP_Length(Int(round(log2(Double(fftSize))))), FFTRadix(kFFTRadix2))

	let player: AVAudioPlayer
	let pcm: [CGFloat]

	init(sound: Data) {
		self.pcm = SoundShape.getPcm(sound)
		self.player = try! AVAudioPlayer(data: sound)
		self.player.prepareToPlay()
		player.isMeteringEnabled = true
		self.publisher = detector.debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
			.dropFirst()
			.eraseToAnyPublisher()
	}

	static func getPcm(_ sound: Data) -> [CGFloat] {
		let audioFormat = AVAudioFormat(
			commonFormat: .pcmFormatFloat32,
			sampleRate: 44100, channels: 1,
			interleaved: false)!
		let buffer = sound.convertedTo(audioFormat)!
		let arraySize = Int(buffer.frameLength)
		let samples = Array(
			UnsafeBufferPointer(start: buffer.floatChannelData![0], count: arraySize))
		var i = 0
		var ts: Float = 0
		var max: Float = 0
		var min: Float = 0
		var result: [Float] = []
		for sample in samples {
			if i != 11025 {
				i += 1
				ts += sample
			} else {
				i = 0
				if ts > max { max = ts }
				if ts < min { min = ts }
				result.append(ts)
				ts = 0
			}
		}
		return result.map { CGFloat(300 * ($0 - min) / (max - min) + 10) }
	}

	var body: some View {
		VStack {
			b
			p
		}
	}

	@State var playing = false
	var b: some View {
		Button(
			action: {
				if playing {
					player.pause()
				} else {
					player.play()
				}
				playing.toggle()
			},
			label: {
				Image(systemName: playing ? "pause.circle.fill" : "play.circle.fill")
					.resizable()
					.frame(width: 70, height: 70)
					.padding(30)
			}
		)
	}

	let detector = CurrentValueSubject<CGFloat, Never>(0)
	let publisher: AnyPublisher<CGFloat, Never>
	let token = SubscriptionToken()
	var p: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			ScrollViewReader { sproxy in
				VStack(alignment: .leading, spacing: 0) {
					HStack(spacing: 6) {
						ForEach(pcm.indices, id: \.self) { index in
							Rectangle()
								.frame(width: 2, height: pcm[index])
								.opacity(0.7)
								.id(index)
						}
					}
					.frame(height: 400)
					.background(Color.secondary.opacity(0.05))
					HStack(alignment: .top, spacing: 30) {
						ForEach(0..<Int(player.duration), id: \.self) { i in
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
							.preference(
								key: ScrollOffsetPreferenceKey.self,
								value: (UIScreen.main.bounds.width / 2
									- proxy.frame(in: .named("soundScroll")).origin.x)
									/ proxy.size.width
							)
							.onChange(of: playing) { state in
								if state {
									Timer.publish(every: 0.25, on: .main, in: .default)
										.autoconnect().sink(receiveValue: { _ in
											withAnimation(.linear(duration: 0.25)) {
												print(Int(player.currentTime * 4))
												sproxy.scrollTo(
													Int(player.currentTime * 4), anchor: .center)
											}
										}).seal(in: token)
								} else {
									token.unseal()
								}
							}
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
		.onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: { detector.send($0) })
		.onReceive(publisher) {
			print("stop \($0)")
			player.currentTime = Double($0) * player.duration
		}
	}
}

private struct ScrollOffsetPreferenceKey: PreferenceKey {
	static var defaultValue: CGFloat = 0
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
