//
//  MatterCell.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/4/7.
//

import Kingfisher
import SwiftUI

struct FodderCell: View {
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
		default:
			return AnyView(Color.clear)
		}
	}

	var title: some View {
		HStack {
			Image(systemName: node.type.systemImage)
			Text(node.title)
				.font(.caption)
				.fontWeight(.regular)
			Spacer()
		}
		.font(.headline)
		.foregroundColor(.gray)
	}
	@ViewBuilder
	var lc: some View {
		VStack(alignment: .leading, spacing: 9) {
			title
			SwiftUI.Link(destination: URL(string: content.url!)!) {
				Text(content.url!)
			}
			.padding(9)
			.roundedBackground(radius: .ssmall, color: Color.accentColor.opacity(0.3))
			.onDrag({
				NSItemProvider(
					object: String("[\(node.title)](\(content.url!))") as NSString)
			})
		}

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
	}

	var ic: some View {
		VStack {
			ForEach(node.contents, id: \.fileName) { content in
				Group {
					if let data = content.data {
						Image(uiImage: UIImage(data: data)!)
							.resizable()
							.aspectRatio(contentMode: .fit)
					} else {
						KFImage(URL(string: content.path!))
							.resizable()
							.placeholder {
								ProgressView().progressViewStyle(CircularProgressViewStyle())
									.padding(.bottom)
							}
							.fade(duration: 1)
							.cancelOnDisappear(true)
							.aspectRatio(contentMode: .fit)
					}
				}
				.cornerRadius(9)
				.onDrag({
					NSItemProvider(
						object: String(
							"![\(node.title)](\(server)/\( content.fileName ?? ""))")
							as NSString)
				})
			}
		}
	}
	var sc: some View {
		VStack(spacing: 9) {
			Image(systemName: "play.circle.fill")
				.resizable()
				.opacity(0.7)
				.frame(width: 40, height: 40)
				.padding(.top, 30)
				.padding(.bottom, 42)

		}.frame(width: 170)
	}

	var tc: some View {

		Text(node.title)
			.font(.title3)
			.frame(maxWidth: 170)
			.fixedSize(horizontal: true, vertical: true)
			.lineLimit(4)
			.padding(.leading, 9)
	}
}

//struct FodderCell_Previews: PreviewProvider {
//    static var previews: some View {
//        FodderCell()
//    }
//}
