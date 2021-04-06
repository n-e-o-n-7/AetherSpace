//
//  KnotView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/11.
//

import Combine
import Foundation
import SwiftUI

struct KnotView: View {
	let nid: Nid
	@State var isDraw: Bool = false
	@State var extra = CGSize.zero
	let inPoint: CGPoint = CGPoint(x: 7.5, y: 7.5)
	var outPoint: CGPoint {
		inPoint.applyOffset(size: extra)
	}
	var direct: Bool {
		inPoint.x < outPoint.x
	}
	let linkSubject: PassthroughSubject<(Nid, CGPoint), Never>
	@State var globalOffset = CGSize.zero
	var body: some View {

		Circle()
			.fill(Color.gray.opacity(0.4))
			.frame(width: 15, height: 15)
			.overlay(
				GeometryReader { proxy in
					if isDraw {
						Path { path in
							path.move(to: inPoint)
							path.addCurve(
								to: outPoint,
								control1: inPoint.applyOffset(
									x: direct ? curveOffset : -curveOffset, y: 0),
								control2: outPoint.applyOffset(
									x: direct ? -curveOffset : curveOffset, y: 0))
						}
						.strokedPath(StrokeStyle(lineCap: .round, lineJoin: .round))
						.stroke(Color.yellow.opacity(0.6), lineWidth: 8)
						.onAppear(perform: {
							let x = proxy.frame(in: .global).midX
							let y = proxy.frame(in: .global).midY
							globalOffset = CGSize(width: x, height: y)
						})
						.onDisappear(perform: {
							globalOffset = CGSize.zero
						})
					}
				}
			)
			//			.padding()
			.contentShape(Rectangle())
			.gesture(
				DragGesture()
					.onChanged { value in
						isDraw = true
						extra = value.translation
					}.onEnded { value in
						linkSubject.send((nid, outPoint.applyOffset(size: globalOffset)))
						isDraw = false
						extra = CGSize.zero
					}
			)
	}
}

//struct KnotView_Previews: PreviewProvider {
//    static var previews: some View {
//        KnotView()
//    }
//}
