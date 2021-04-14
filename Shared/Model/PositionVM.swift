//
//  NodeVM.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/12.
//

import SwiftUI

class PositionVM: ObservableObject {
	@Published var save: CGPoint = CGPoint.zero
	@Published var extra: CGSize = CGSize.zero

	init(offset position: CGPoint) {
		self.save = position
	}
	init() {}
}
