//
//  AutoSave.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/4/14.
//

import Combine
import SwiftUI

class AutoSave: ObservableObject {
	let saveSubject = PassthroughSubject<Bool, Never>()
	private let token = SubscriptionToken()

	func setSave(frequency: TimeInterval) {
		token.unseal()
		guard frequency > 0 else { return }
		print(frequency)
		Timer.publish(every: frequency, on: .main, in: .default).autoconnect().sink(receiveValue: {
			_ in
			self.save()
		}).seal(in: token)
	}

	func save() {
		self.saveSubject.send(true)
	}
}
