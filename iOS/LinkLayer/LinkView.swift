//
//  LinkView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/17.
//

import SwiftUI

struct LinkView: View {
	let lid: Lid
	@EnvironmentObject var svm: SpaceVM
	@ObservedObject var headPVM: PositionVM
	var headP: CGPoint {
		CGPoint(x: headPVM.save.x + headPVM.extra.width, y: headPVM.save.y + headPVM.extra.height)
	}

	@ObservedObject var tailPVM: PositionVM
	var tailP: CGPoint {
		CGPoint(x: tailPVM.save.x + tailPVM.extra.width, y: tailPVM.save.y + tailPVM.extra.height)
	}

	var length: CGFloat {
		headP.distance(to: tailP)
	}

	var lineWidth: CGFloat {
		let base: CGFloat = 7
		let maxD: CGFloat = 600
		let minD: CGFloat = 400
		if length >= maxD {

			svm.removeLink(lid: lid)

			return 0
		} else if length <= minD {
			return base
		} else {
			return base - (pow((length - minD), 2) * base / 40000)
		}
	}
	@AppStorage("mainColor") var mainColor = "blue"
	var body: some View {
		LinkPath(headP: headP, tailP: tailP)
			.stroke(ColorSet(rawValue: mainColor)!.toColor().opacity(0.3), lineWidth: lineWidth)
	}
}
