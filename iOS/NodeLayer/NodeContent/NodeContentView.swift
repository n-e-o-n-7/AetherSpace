//
//  ContentView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/22.
//

import Combine
import Introspect
import Kingfisher
import SwiftUI

struct NodeContentView: View {
	@Binding var node: Node
	var type: Node.Species {
		node.type
	}
	var content: NodeContent {
		node.contents.first!
	}
	let knot: () -> KnotView
	var body: some View {
		switch type {
		case .link:
			return AnyView(lc)
		case .tag:
			return AnyView(tc)
		case .date:
			return AnyView(dc)
		case .image:
			return AnyView(ic)
		case .sound:
			return AnyView(sc)
		case .markdown:
			return AnyView(mc)
		}
	}
	var title: some View {
		HStack {
			Image(systemName: type.systemImage)
				.foregroundColor(Color.accentColor)
			Text(node.title)
				.font(.caption)
				.fontWeight(.regular)
			Spacer()
			knot()
		}
		.font(.headline)
		.foregroundColor(.gray)
	}

	@State var isPresented = false
	var lc: some View {
		SwiftUI.Link(destination: URL(string: content.url!)!) {
			Text(content.url!)
		}
		.padding(9)
		.background(Color.accentColor.opacity(0.2).cornerRadius(CornerRadius.ssmall.rawValue))
		.padding(.top, 30)
		.overlay(
			title,
			alignment: .top
		)
	}

	let dateRange: ClosedRange<Date> = {
		let calendar = Calendar.current
		let startComponents = DateComponents(year: 2021, month: 1, day: 1)
		let endComponents = DateComponents(
			year: 2021, month: 12, day: 31, hour: 23, minute: 59, second: 59)
		return calendar.date(from: startComponents)!...calendar.date(from: endComponents)!
	}()
	var dc: some View {
		DatePicker(
			"",
			selection: $node.contents[0].time.unwrap()!,
			in: dateRange,
			displayedComponents: [.date, .hourAndMinute]
		)
		.labelsHidden().accentColor(Color("TextColor"))
		.padding(.top, 30)
		.background(
			title,
			alignment: .top
		)
	}

	var ic: some View {
		VStack(spacing: 9) {
			title
			Group {
				if let data = content.data {
					Image(uiImage: UIImage(data: data)!)
						.resizable()
						.aspectRatio(contentMode: .fit)
				} else {
					KFImage(URL(string: content.path!))
						.loadImmediately()
						.resizable()
						.placeholder {
							ProgressView().progressViewStyle(CircularProgressViewStyle()).padding(
								.bottom)
						}
						.fade(duration: 1)
						.cancelOnDisappear(true)
						.aspectRatio(contentMode: .fit)
				}
			}.onTapGesture {
				isPresented.toggle()
			}.fullScreenCover(isPresented: $isPresented) {
				ImageContent(node: $node)
			}.cornerRadius(9)
				.shadow(.base)
		}.frame(width: 210)
	}

	@State var playing = false
	var sc: some View {
		VStack(spacing: 9) {
			title
			Image(systemName: "play.circle.fill")
				.resizable()
				.opacity(0.7)
				.frame(width: 40, height: 40)
				.soundWave(playState: $playing)
				.onTapGesture {
					playing.toggle()
				}
				.padding(.top, 30)
				.padding(.bottom, 42)
				.frame(maxWidth: .infinity)
				.contentShape(Rectangle())
				.fullScreenCover(isPresented: $isPresented) {
					SoundContent(node: $node)
				}.onTapGesture {
					isPresented.toggle()
				}
		}.frame(width: 170)
	}

	@State private var edit = false
	var tc: some View {

		Text(node.title)
			.overlay(
				TextEditor(text: $node.title)
					.introspectTextView { textView in
						textView.backgroundColor = UIColor.clear
						textView.isScrollEnabled = false
						textView.textContainerInset = UIEdgeInsets.zero
						textView.textContainer.lineFragmentPadding = 0
					}
			)
			//		.frame(width: 100, height: 100)
			//		.frame(maxWidth: 170)
			//		.fixedSize(horizontal: true, vertical: true)
			//		.lineLimit(4)
			//			.padding(.leading, 9)
			.padding(.trailing, 30).overlay(knot(), alignment: .trailing)
	}

	var mc: some View {
		title
			.frame(width: 170)
			.fullScreenCover(isPresented: $isPresented) {
				MarkdownContent(
					node: $node
				)
			}.onTapGesture {
				isPresented.toggle()
			}
	}
}
