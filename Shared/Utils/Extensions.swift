//
//  Extension.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/11.
//

import AVFoundation
import Combine
import CoreGraphics
import Foundation
import SwiftUI

//MARK: - CGPonit
extension CGPoint {

	func applyOffset(x: CGFloat, y: CGFloat) -> CGPoint {
		return CGPoint(x: self.x + x, y: self.y + y)
	}

	func applyOffset(size: CGSize) -> CGPoint {
		return CGPoint(x: self.x + size.width, y: self.y + size.height)
	}
	func applyOffset(point: CGPoint) -> CGPoint {
		return CGPoint(x: self.x + point.x, y: self.y + point.y)
	}

	func distance(to point: CGPoint) -> CGFloat {
		return sqrt(pow((self.x - point.x), 2) + pow((self.y - point.y), 2))
	}

	func subtract(_ point: CGPoint) -> CGPoint {
		return CGPoint(x: self.x - point.x, y: self.y - point.y)
	}
}

//MARK: - Combine
class SubscriptionToken {
	var cancellable: AnyCancellable?
	func unseal() { cancellable = nil }
}

extension AnyCancellable {
	func seal(in token: SubscriptionToken) {
		token.cancellable = self
	}
}

func accessNotifications(delegate: UNUserNotificationCenterDelegate) {

	UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
		(_, _) in

	}
	UNUserNotificationCenter.current().delegate = delegate
}

func createNotification() {
	let content = UNMutableNotificationContent()
	content.title = "Message"
	content.subtitle = "upload success"

	let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
	let request = UNNotificationRequest(identifier: "In-App", content: content, trigger: trigger)

	let close = UNNotificationAction(identifier: "CLOSE", title: "close", options: .destructive)
	let reply = UNNotificationAction(identifier: "REPLY", title: "reply", options: .foreground)
	let category = UNNotificationCategory(
		identifier: "ACTIONS", actions: [close, reply], intentIdentifiers: [], options: [])
	UNUserNotificationCenter.current().setNotificationCategories([category])
	content.categoryIdentifier = "ACTIONS"
	UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}

class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
	func userNotificationCenter(
		_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
		withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) ->
			Void
	) {
		completionHandler([.badge, .banner, .sound])
	}

	//actions

	func userNotificationCenter(
		_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
		withCompletionHandler completionHandler: @escaping () -> Void
	) {
		if response.actionIdentifier == "REPLY" {
			print("reply")
		}
		completionHandler()
	}
}

func ?? <T>(binding: Binding<T?>, fallback: T) -> Binding<T> {
	return Binding(
		get: {
			binding.wrappedValue ?? fallback
		},
		set: {
			binding.wrappedValue = $0
		})
}
extension Binding {
	func unwrap<Wrapped>() -> Binding<Wrapped>? where Wrapped? == Value {
		guard self.wrappedValue != nil else { return nil }
		return Binding<Wrapped>(
			get: {
				return self.wrappedValue!
			},
			set: { newValue in
				self.wrappedValue = newValue
			}
		)
	}

}

// For all Bindings whose Value is a collection
extension Binding: RandomAccessCollection
where Value: RandomAccessCollection & MutableCollection {

	// The Element of this collection is Binding of underlying Value.Element
	public typealias Element = Binding<Value.Element>
	public typealias Index = Value.Index
	public typealias SubSequence = Self
	public typealias Indices = Value.Indices

	// return a binding to the underlying collection element
	public subscript(position: Index) -> Element {
		get {
			.init(
				get: { self.wrappedValue[position] },
				set: { self.wrappedValue[position] = $0 })
		}
	}

	// other protocol conformance requirements routed to underlying collection ...

	public func index(before i: Index) -> Index {
		self.wrappedValue.index(before: i)
	}

	public func index(after i: Index) -> Index {
		self.wrappedValue.index(after: i)
	}

	public var startIndex: Index {
		self.wrappedValue.startIndex
	}

	public var endIndex: Index {
		self.wrappedValue.endIndex
	}
}
extension Binding: Sequence
where Value: RandomAccessCollection & MutableCollection {

	public func makeIterator() -> IndexingIterator<Self> {
		IndexingIterator(_elements: self)
	}
}

extension Binding: Collection
where Value: RandomAccessCollection & MutableCollection {

	public var indices: Value.Indices {
		self.wrappedValue.indices
	}
}

extension Binding: BidirectionalCollection
where Value: RandomAccessCollection & MutableCollection {
}
extension Binding: Identifiable where Value: Identifiable {
	public var id: Value.ID {
		self.wrappedValue.id
	}
}

extension Color {
	func toString() -> String {
		let uiColor = UIColor(self)
		var hue: CGFloat = 0
		var saturation: CGFloat = 0
		var brightness: CGFloat = 0
		var alpha: CGFloat = 0
		uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
		return "\(hue),\(saturation),\(brightness),\(alpha)"
	}
}

extension String {
	func toColor() -> Color? {
		let ca = self.components(separatedBy: ",")
		if ca.count == 4, let hue = Double(ca[0]), let saturation = Double(ca[1]),
			let brightness = Double(ca[2]), let opacity = Double(ca[3])
		{
			return Color(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity)
		} else {
			return nil
		}
	}
}

typealias Nid = UUID
typealias Lid = Int

extension String {
	func toReg() -> NSRegularExpression? {
		try? NSRegularExpression(pattern: self, options: .caseInsensitive)
	}
}

extension Data {
	init(buffer: AVAudioPCMBuffer, time: AVAudioTime) {
		let audioBuffer = buffer.audioBufferList.pointee.mBuffers
		self.init(bytes: audioBuffer.mData!, count: Int(audioBuffer.mDataByteSize))
	}

	func makePCMBuffer(format: AVAudioFormat) -> AVAudioPCMBuffer? {
		let streamDesc = format.streamDescription.pointee
		let frameCapacity = UInt32(count) / streamDesc.mBytesPerFrame
		guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCapacity) else {
			return nil
		}

		buffer.frameLength = buffer.frameCapacity
		let audioBuffer = buffer.audioBufferList.pointee.mBuffers

		withUnsafeBytes { (bufferPointer) in
			guard let addr = bufferPointer.baseAddress else { return }
			audioBuffer.mData?.copyMemory(from: addr, byteCount: Int(audioBuffer.mDataByteSize))
		}

		return buffer
	}
}

func data_AudioFile_ReadProc(
	_ inClientData: UnsafeMutableRawPointer, _ inPosition: Int64, _ requestCount: UInt32,
	_ buffer: UnsafeMutableRawPointer, _ actualCount: UnsafeMutablePointer<UInt32>
) -> OSStatus {
	let data = inClientData.assumingMemoryBound(to: Data.self).pointee
	let bufferPointer = UnsafeMutableRawBufferPointer(start: buffer, count: Int(requestCount))
	let copied = data.copyBytes(
		to: bufferPointer, from: Int(inPosition)..<Int(inPosition) + Int(requestCount))
	actualCount.pointee = UInt32(copied)
	return noErr
}

func data_AudioFile_GetSizeProc(_ inClientData: UnsafeMutableRawPointer) -> Int64 {
	let data = inClientData.assumingMemoryBound(to: Data.self).pointee
	return Int64(data.count)
}

extension Data {
	func convertedTo(_ format: AVAudioFormat) -> AVAudioPCMBuffer? {
		var data = self

		var af: AudioFileID? = nil
		var status = AudioFileOpenWithCallbacks(
			&data, data_AudioFile_ReadProc, nil, data_AudioFile_GetSizeProc(_:), nil, 0, &af)
		guard status == noErr, af != nil else {
			return nil
		}

		defer {
			AudioFileClose(af!)
		}

		var eaf: ExtAudioFileRef? = nil
		status = ExtAudioFileWrapAudioFileID(af!, false, &eaf)
		guard status == noErr, eaf != nil else {
			return nil
		}

		defer {
			ExtAudioFileDispose(eaf!)
		}

		var clientFormat = format.streamDescription.pointee
		status = ExtAudioFileSetProperty(
			eaf!, kExtAudioFileProperty_ClientDataFormat,
			UInt32(MemoryLayout.size(ofValue: clientFormat)), &clientFormat)
		guard status == noErr else {
			return nil
		}

		if let channelLayout = format.channelLayout {
			var clientChannelLayout = channelLayout.layout.pointee
			status = ExtAudioFileSetProperty(
				eaf!, kExtAudioFileProperty_ClientChannelLayout,
				UInt32(MemoryLayout.size(ofValue: clientChannelLayout)), &clientChannelLayout)
			guard status == noErr else {
				return nil
			}
		}

		var frameLength: Int64 = 0
		var propertySize: UInt32 = UInt32(MemoryLayout.size(ofValue: frameLength))
		status = ExtAudioFileGetProperty(
			eaf!, kExtAudioFileProperty_FileLengthFrames, &propertySize, &frameLength)
		guard status == noErr else {
			return nil
		}

		guard
			let pcmBuffer = AVAudioPCMBuffer(
				pcmFormat: format, frameCapacity: AVAudioFrameCount(frameLength))
		else {
			return nil
		}

		let bufferSizeFrames = 512
		let bufferSizeBytes =
			Int(format.streamDescription.pointee.mBytesPerFrame) * bufferSizeFrames
		let numBuffers = format.isInterleaved ? 1 : Int(format.channelCount)
		let numInterleavedChannels = format.isInterleaved ? Int(format.channelCount) : 1
		let audioBufferList = AudioBufferList.allocate(maximumBuffers: numBuffers)
		for i in 0..<numBuffers {
			audioBufferList[i] = AudioBuffer(
				mNumberChannels: UInt32(numInterleavedChannels),
				mDataByteSize: UInt32(bufferSizeBytes), mData: malloc(bufferSizeBytes))
		}

		defer {
			for buffer in audioBufferList {
				free(buffer.mData)
			}
			free(audioBufferList.unsafeMutablePointer)
		}
		while true {
			var frameCount: UInt32 = UInt32(bufferSizeFrames)
			status = ExtAudioFileRead(eaf!, &frameCount, audioBufferList.unsafeMutablePointer)
			guard status == noErr else {
				return nil
			}

			if frameCount == 0 {
				break
			}

			let src = audioBufferList
			let dst = UnsafeMutableAudioBufferListPointer(pcmBuffer.mutableAudioBufferList)

			if src.count != dst.count {
				return nil
			}

			for i in 0..<src.count {
				let srcBuf = src[i]
				let dstBuf = dst[i]
				memcpy(
					dstBuf.mData?.advanced(by: Int(dstBuf.mDataByteSize)), srcBuf.mData,
					Int(srcBuf.mDataByteSize))
			}

			pcmBuffer.frameLength += frameCount
		}

		return pcmBuffer
	}
}

extension Array where Element == Float {
	var sum: Float {
		return self.reduce(0, +)
	}
	var ave: Float {
		return sum / Float(self.count)
	}
	var variance: Float {
		let ave = self.ave
		return self.map { pow(($0 - ave), 2) }.ave
	}
	var std: Float {
		return sqrt(variance)
	}
	var zscored: [Float] {
		let ave = self.ave
		let std = self.std
		return self.map { std != 0 ? (($0 - ave) / std) : 0 }
	}
}
