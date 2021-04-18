//
//  SearchCell.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/4/5.
//

import Kingfisher
import SwiftUI

struct SearchCell: View {
	let node: Node
	var content: NodeContent {
		node.contents.first!
	}
	var body: some View {
		switch node.type {
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
			Image(systemName: node.type.systemImage)
				.foregroundColor(Color.accentColor)
			Text(node.title)
				.font(.caption)
				.fontWeight(.regular)
			Spacer()

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
			selection: Binding(get: { content.time! }, set: { _, _ in }),
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
			Group {
				if let data = content.data {
					Image(uiImage: UIImage(data: data)!)
						.resizable()
						.aspectRatio(contentMode: .fit)
				} else {
					KFImage(URL(string: content.path!))
						.resizable()
						.placeholder {
							ProgressView().progressViewStyle(CircularProgressViewStyle()).padding(
								.bottom)
						}
						.aspectRatio(contentMode: .fit)
				}
			}
			.cornerRadius(9)
			.shadow(.thin)
		}.frame(width: 210)

	}
	var sc: some View {
		title.frame(width: 170)
	}

	var tc: some View {

		Text(node.title)
			.font(.title3)
			.frame(maxWidth: 170)
			.fixedSize(horizontal: true, vertical: true)
			.lineLimit(4)
			.padding(.leading, 9)
	}

	var mc: some View {
		title
			.frame(width: 170)
	}
}
