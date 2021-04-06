//
//  ContentView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/22.
//

import Combine
import SwiftUI

struct NodeContentView: View {
	let type: Node.Species
	@Binding var content: NodeContent
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
			Text(content.title!)
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
		.background(Color.accentColor.opacity(0.3).cornerRadius(CornerRadius.ssmall.rawValue))
		.padding(.top, 30)
		.overlay(
			title,
			alignment: .top)

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
			selection: $content.time.unwrap()!,
			in: dateRange,
			displayedComponents: [.date, .hourAndMinute]
		)
		.labelsHidden().accentColor(Color("TextColor"))
		.padding(.top, 30)
		.overlay(
			title,
			alignment: .top)

	}
	var ic: some View {
		VStack(spacing: 9) {
			title
			Image(uiImage: UIImage(data: content.data!)!)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.onTapGesture {
					isPresented.toggle()
				}
				.fullScreenCover(isPresented: $isPresented) {
					ImageContent(content: $content)
				}
				.cornerRadius(9)
				.shadow(.base)
		}.frame(width: 210)

	}
	var sc: some View {
		VStack(spacing: 9) {
			title
			Image(systemName: "play.circle.fill")
				.resizable()
				.opacity(0.7)
				.frame(width: 40, height: 40)
				.padding(.top, 30)
				.padding(.bottom, 42)
				.fullScreenCover(isPresented: $isPresented) {
					SoundContent(content: $content)
				}.onTapGesture {
					isPresented.toggle()
				}

		}.frame(width: 170)
	}

	var tc: some View {

		TextField(
			"Placeholder", text: $content.title.unwrap()!
		)
		.font(.title3)
		.frame(maxWidth: 170)
		.fixedSize(horizontal: true, vertical: true)
		.lineLimit(4)
		.padding(.trailing, 30)
		.padding(.leading, 9)
		.overlay(knot(), alignment: .trailing)

	}

	var mc: some View {
		title
			.frame(width: 170)
			.fullScreenCover(isPresented: $isPresented) {
				MarkdownContent(
					markdown: $content.markdown.unwrap()!
				)
			}.onTapGesture {
				isPresented.toggle()
			}
	}
}
