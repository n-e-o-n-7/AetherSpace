//
//  NodeView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/5.
//

import Combine
import SwiftUI

struct NodeView: View {
	@Binding var node: Node
	@Binding var top: Nid?
	@ObservedObject var pvm: PositionVM
	@EnvironmentObject var svm: SpaceVM
	let linkSubject: PassthroughSubject<(Nid, CGPoint), Never>
	@State var showAlert = false
	@Environment(\.showStyle) var showStyle
	@State var proxyFrame: CGRect = CGRect.zero
	var body: some View {

		NodeContentView(
			node: $node,
			knot: { KnotView(nid: node.id, linkSubject: linkSubject) }
		)
		.padding(node.style.padding)
		.font(node.style.fontSize)
		.if(node.style.textColor != .clear) {
			$0.foregroundColor(node.style.textColor)
		}
		.background(
			GeometryReader { proxy in
				RoundedRectangle(cornerRadius: CornerRadius.mid.rawValue)
					.fill(Color("NodeBackground"))
					.overlay(
						Group {
							if node.style.border {
								RoundedRectangle(cornerRadius: CornerRadius.mid.rawValue)
									.stroke(
										node.style.lineColor,
										style: node.style.dash
											? StrokeStyle(
												lineWidth: node.style.lineWidth, dash: [10])
											: StrokeStyle(lineWidth: node.style.lineWidth))
							}
						}
					)
					.shadow(node.style.shadow)
					.onReceive(
						linkSubject,
						perform: { (sender, point) in
							let pos = proxy.frame(in: .global)
							if pos.minX < point.x && point.x < pos.maxX && pos.minY < point.y
								&& point.y < pos.maxY
							{
								svm.addLink(head: sender, tail: node.id)
							}
						}
					)
					.onAppear(perform: {
						proxyFrame = proxy.frame(in: .global)
					}).onChange(
						of: proxy.frame(in: .global),
						perform: { value in
							proxyFrame = value
						})
			}
		)
		.contextMenu {
			Button(
				action: {
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
						withAnimation(.easeInOut) {
							svm.jump(to: node)
						}
					}
				},
				label: {
					Label("choose", systemImage: "cursorarrow.rays")
				})
			Button(
				action: { top = node.id },
				label: {
					Label("front", systemImage: "rectangle.stack")
				})
			Button(
				action: {
					var p = CGPoint.zero
					let width = UIScreen.main.bounds.size.width / 2
					let top = UIApplication.shared.windows.first!.safeAreaInsets.top
					let height = (UIScreen.main.bounds.size.height - top) / 2
					if proxyFrame.minX < 360 {
						p.x = proxyFrame.maxX + 180 - width
					} else {
						p.x = proxyFrame.minX - 180 - width
					}
					if proxyFrame.midY - top < 230 {
						p.y = -height + 230
					} else {
						p.y = proxyFrame.midY - height
					}
					showStyle.wrappedValue = (node.id, p)
				},
				label: {
					Label("style", systemImage: "rectangle.stack")
				})
			Button(
				action: { svm.hide(nid: node.id) },
				label: {
					Label("hide", systemImage: "eye.slash")
				})
			Button(
				action: {
					if node.id == svm.space.lastNodeId {
						showAlert.toggle()
					} else {
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
							withAnimation(.easeInOut) {
								svm.removeNode(nid: node.id)
							}
						}
					}
				},
				label: {
					Label("delete", systemImage: "trash").foregroundColor(.red)
				})
		}

		.offset(x: pvm.save.x + pvm.extra.width, y: pvm.save.y + pvm.extra.height)
		.gesture(
			DragGesture()
				.onChanged { value in
					pvm.extra = value.translation
				}.onEnded { value in
					pvm.save = CGPoint(
						x: pvm.save.x + pvm.extra.width, y: pvm.save.y + pvm.extra.height)
					pvm.extra = CGSize.zero
				}
		)
		.alert(isPresented: $showAlert) {
			Alert(
				title: Text("this is the center node"),
				message: Text("please confirm whether to delete"),
				primaryButton: .destructive(Text("delete")) { svm.removeNode(nid: node.id) },
				secondaryButton: .cancel())
		}
	}
}
