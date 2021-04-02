//
//  LinkView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/17.
//

import SwiftUI

struct LinkView: View {

	@ObservedObject var headPVM: PositionVM
	var headP: CGPoint {
		CGPoint(x: headPVM.save.x + headPVM.extra.width, y: headPVM.save.y + headPVM.extra.height)
	}

	@ObservedObject var tailPVM: PositionVM
	var tailP: CGPoint {
		CGPoint(x: tailPVM.save.x + tailPVM.extra.width, y: tailPVM.save.y + tailPVM.extra.height)
	}

	let lineWidth: CGFloat = 7

	var length: CGFloat {
		headP.distance(to: tailP)
	}

	//    var lineWidth:CGFloat {
	//        let base = 7
	//        let maxD = 400000
	//        let mixD = 200000
	//        if length > maxD {
	//            return 0
	//        }else if length < mixD {
	//            return base
	//        }else {
	//            return length - maxD /
	//        }
	//    }

	//		var body: some View {
	//
	//			GeometryReader { proxy in
	//				Path { path in
	//					let h = headP.applyOffset(x: proxy.size.width / 2, y: proxy.size.height / 2)
	//					let t = tailP.applyOffset(x: proxy.size.width / 2, y: proxy.size.height / 2)
	//
	//					path.move(to: h)
	//
	//					path.addCurve(
	//						to: t,
	//						control1: h.applyOffset(x: direct ? curveOffset : -curveOffset, y: 0),
	//						control2: t.applyOffset(x: direct ? -curveOffset : curveOffset, y: 0))
	//
	//				}
	//				.strokedPath(StrokeStyle(lineCap: .round, lineJoin: .round))
	//				.stroke(Color.yellow.opacity(0.6), lineWidth: lineWidth)
	//			}
	//
	//		}

	var body: some View {
		LinkPath(headP: headP, tailP: tailP)
			.stroke(Color.blue.opacity(0.3), lineWidth: lineWidth)
	}
}
