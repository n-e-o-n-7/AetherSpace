//
//  SoundPlayer.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/4/17.
//

import AVFoundation
import Accelerate

class SoundPlayer: ObservableObject {
	private let player: AVAudioPlayer
	private let audioFormat = AVAudioFormat(
		commonFormat: .pcmFormatFloat32,
		sampleRate: 44100, channels: 1,
		interleaved: false)!

	init(data: Data) {
		player = try! AVAudioPlayer(data: data)
	}
	deinit {
		print("deinit")
		vDSP_destroy_fftsetup(fftSetup)
	}

	func inject(data: Data) {
		let buffer = data.convertedTo(audioFormat)!

		let arraySize = Int(buffer.frameLength)
		let samples = Array(
			UnsafeBufferPointer(start: buffer.floatChannelData![0], count: arraySize))

		let total = samples.count / 11025 * 11025

		self.frequency = stride(from: 0, to: total / fftSize, by: 1).map { i in
			Array(samples[fftSize * i..<fftSize * (i + 1)])
		}

		var i = 0
		var ts: Float = 0
		var result: [Float] = [0]
		var max: Float = 0
		var min: Float = 0
		for sample in samples {
			if i == 11024 {
				i = 0
				if ts > max { max = ts }
				if ts < min { min = ts }
				result.append(ts)
				ts = 0
			} else {
				i += 1
				ts += abs(sample)
			}
		}
		let length = max - min
		self.normal = result.map { ($0 - min) / length }
	}

	func play() {
		player.play()
	}
	func pause() {
		player.pause()
	}

	var total: TimeInterval {
		0.25 * Double(normal.count - 1)
	}
	var current: TimeInterval {
		player.currentTime
	}
	var factor: Double {
		current / total
	}
	//MARK: - nor
	@Published var normal: [Float] = []
	func jump(to factor: Double) {
		player.currentTime = factor * total
	}

	//MARK: - fre
	private let fftSize = 2205  //0.05s
	private lazy var fftSetup = vDSP_create_fftsetup(
		vDSP_Length(Int(round(log2(Double(fftSize))))), FFTRadix(kFFTRadix2))

	@Published var frequency: [[Float]] = []
	private func fft(_ data: [Float]) -> [[Float]] {
		var data = data
		var amplitudes = [[Float]]()
		let channel = UnsafeMutablePointer(&data)
		//加汉宁窗
		var window = [Float](repeating: 0, count: Int(fftSize))
		vDSP_hann_window(&window, vDSP_Length(fftSize), Int32(vDSP_HANN_NORM))
		vDSP_vmul(channel, 1, window, 1, channel, 1, vDSP_Length(fftSize))

		var realp = [Float](repeating: 0.0, count: Int(fftSize / 2))
		var imagp = [Float](repeating: 0.0, count: Int(fftSize / 2))
		var fftInOut = DSPSplitComplex(realp: &realp, imagp: &imagp)
		channel.withMemoryRebound(to: DSPComplex.self, capacity: fftSize) {
			(typeConvertedTransferBuffer) -> Void in
			vDSP_ctoz(typeConvertedTransferBuffer, 2, &fftInOut, 1, vDSP_Length(fftSize / 2))
		}

		vDSP_fft_zrip(
			fftSetup!, &fftInOut, 1, vDSP_Length(round(log2(Double(fftSize)))),
			FFTDirection(FFT_FORWARD))

		fftInOut.imagp[0] = 0
		let fftNormFactor = Float(1.0 / (Float(fftSize)))
		vDSP_vsmul(fftInOut.realp, 1, [fftNormFactor], fftInOut.realp, 1, vDSP_Length(fftSize / 2))
		vDSP_vsmul(fftInOut.imagp, 1, [fftNormFactor], fftInOut.imagp, 1, vDSP_Length(fftSize / 2))
		var channelAmplitudes = [Float](repeating: 0.0, count: Int(fftSize / 2))
		vDSP_zvabs(&fftInOut, 1, &channelAmplitudes, 1, vDSP_Length(fftSize / 2))
		channelAmplitudes[0] = channelAmplitudes[0] / 2
		amplitudes.append(channelAmplitudes)

		return amplitudes
	}

	private lazy var bands: [(lowerFrequency: Float, upperFrequency: Float)] = {
		let frequencyBands: Int = 80
		let startFrequency: Float = 100
		let endFrequency: Float = 18000
		var bands = [(lowerFrequency: Float, upperFrequency: Float)]()

		let n = log2(endFrequency / startFrequency) / Float(frequencyBands)
		var nextBand: (lowerFrequency: Float, upperFrequency: Float) = (startFrequency, 0)
		for i in 1...frequencyBands {
			let highFrequency = nextBand.lowerFrequency * powf(2, n)
			nextBand.upperFrequency = i == frequencyBands ? endFrequency : highFrequency
			bands.append(nextBand)
			nextBand.lowerFrequency = highFrequency
		}
		return bands
	}()

	private func findMaxAmplitude(
		for band: (lowerFrequency: Float, upperFrequency: Float), in amplitudes: [Float],
		with bandWidth: Float
	) -> Float {
		let startIndex = Int(round(band.lowerFrequency / bandWidth))
		let endIndex = min(Int(round(band.upperFrequency / bandWidth)), amplitudes.count - 1)
		return amplitudes[startIndex...endIndex].max()!
	}

	//响度
	private lazy var FrequencyWeights: [Float] = {
		let Δf: Float = 20
		let bins = fftSize / 2
		var f = (0..<bins).map { Float($0) * Δf }
		f = f.map { $0 * $0 }

		let c1 = powf(12194.217, 2.0)
		let c2 = powf(20.598997, 2.0)
		let c3 = powf(107.65265, 2.0)
		let c4 = powf(737.86223, 2.0)

		let num = f.map { c1 * $0 * $0 }
		let den = f.map { ($0 + c2) * sqrtf(($0 + c3) * ($0 + c4)) * ($0 + c1) }
		let weights = num.enumerated().map { (index, ele) in
			return 1.2589 * ele / den[index]
		}
		return weights
	}()

	//锯齿消除
	private func highlightWaveform(spectrum: [Float]) -> [Float] {

		let weights: [Float] = [1, 2, 3, 5, 3, 2, 1]
		let totalWeights = Float(weights.reduce(0, +))
		let startIndex = weights.count / 2

		var averagedSpectrum = Array(spectrum[0..<startIndex])
		for i in startIndex..<spectrum.count - startIndex {
			let zipped = zip(Array(spectrum[i - startIndex...i + startIndex]), weights)
			let averaged = zipped.map { $0.0 * $0.1 }.reduce(0, +) / totalWeights
			averagedSpectrum.append(averaged)
		}

		averagedSpectrum.append(contentsOf: Array(spectrum.suffix(startIndex)))
		return averagedSpectrum
	}

	var last: [Float] = []

	//single channel
	func analyseCur() -> [Float] {
		let amplitudes = fft(frequency[Int(current / 0.05)])[0]
		if last.count == 0 {
			last = [Float](repeating: 0, count: bands.count)
		}
		let weightedAmplitudes = amplitudes.enumerated().map { (index, element) in
			return element * FrequencyWeights[index]
		}
		var spectrum = bands.map {
			findMaxAmplitude(for: $0, in: weightedAmplitudes, with: 20) * 5
		}
		spectrum = highlightWaveform(spectrum: spectrum)

		let spectrumSmooth: Float = 0.5
		last = zip(last, spectrum).map { $0 * spectrumSmooth + $1 * (1 - spectrumSmooth) }
		return last
	}
}
