//
//  LinkPath.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/3/28.
//

import SwiftUI

typealias AnimatablePoint = AnimatablePair<CGFloat, CGFloat>
typealias AnimatableCorners = AnimatablePair<AnimatablePoint, AnimatablePoint>

struct LinkPath: Shape {

	var headP: CGPoint
	var tailP: CGPoint
	var dash: Bool
	var direct: Bool {
		headP.x < tailP.x
	}
	var curve: Bool = true
	func path(in rect: CGRect) -> Path {
		print(rect.width, rect.height)
		let h = headP.applyOffset(x: rect.size.width / 2, y: rect.size.height / 2)
		let t = tailP.applyOffset(x: rect.size.width / 2, y: rect.size.height / 2)
		var path = Path()

		path.move(to: h)
		if curve {
			path.addCurve(
				to: t,
				control1: h.applyOffset(x: direct ? curveOffset : -curveOffset, y: 0),
				control2: t.applyOffset(x: direct ? -curveOffset : curveOffset, y: 0))
		} else {
			path.addLine(to: t)
		}

		if dash {
			return path.strokedPath(StrokeStyle(lineCap: .round, lineJoin: .round, dash: [14]))
		} else {
			return path.strokedPath(StrokeStyle(lineCap: .round, lineJoin: .round))
		}
	}

	var animatableData: AnimatableCorners {
		get {
			AnimatablePair(AnimatablePair(headP.x, headP.y), AnimatablePair(tailP.x, tailP.y))
		}
		set {
			headP = CGPoint(x: newValue.first.first, y: newValue.first.second)
			tailP = CGPoint(x: newValue.second.first, y: newValue.second.second)
		}
	}
}
