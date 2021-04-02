//
//  Extension.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/11.
//

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
		return sqrt(self.x - point.x) + sqrt(self.y - point.y)
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
typealias Lid = UUID
