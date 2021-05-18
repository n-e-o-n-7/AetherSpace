//
//  StyleView.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/5/13.
//

import SwiftUI

struct StyleView: View {
	@EnvironmentObject var svm: SpaceVM
	let nid: Nid
	let close: () -> Void
	var style: Binding<NodeStyle> {
		$svm.space.nodes[nid].unwrap()!.style
	}
	var body: some View {

		VStack(alignment: .leading, spacing: 0) {
			//			header
			//			Divider()
			shadow
			Divider()
			text
			Divider()
			padding
			Divider()
			border
		}
		.frame(width: 300)
		.background(Color("NodeBackground"))
		.cornerRadius(13)
		.shadow(.thin)

	}

	var header: some View {
		HStack {
			Text("change style")
				.fontWeight(.bold)
				.font(.body)
			Spacer()
			Button(
				action: {
					close()
				},
				label: {
					Image(systemName: "xmark.circle.fill")
						.font(.title3).foregroundColor(.gray)
				})
		}
		.padding(10)
	}

	var text: some View {
		VStack(alignment: .leading) {
			Text("Text").font(.callout).fontWeight(.bold)

			VStack {
				HStack {
					Text("font").font(.footnote).foregroundColor(.gray)
					Spacer()
					Picker(
						selection: style.fontSize,
						label: Text(
							StyleFont.transform(font: style.fontSize.wrappedValue)!.rawValue
						).font(
							.footnote)
					) {
						ForEach(StyleFont.allCases, id: \.self) { font in
							Text(font.rawValue).tag(font.font)
						}
					}.pickerStyle(MenuPickerStyle())
				}
			}
			VStack {
				HStack {
					Text("color").font(.footnote).foregroundColor(.gray)
					Spacer()
					Picker(
						selection: style.textColor,
						label: Group {
							if style.textColor.wrappedValue == Color.clear {
								Image(systemName: "circle")
									.resizable()
									.frame(width: 24, height: 24)
									.foregroundColor(.gray)
							} else {
								Circle().fill(style.textColor.wrappedValue).frame(
									width: 24, height: 24)
							}
						}
					) {
						ForEach(StyleColor.allCases, id: \.self) { color in
							Text(color.rawValue)
								.tag(color.color)
						}
					}.pickerStyle(MenuPickerStyle())
				}
			}
		}.padding(10)
	}

	var shadow: some View {
		VStack(alignment: .leading) {
			Text("Shadow").font(.callout).fontWeight(.bold)
			Picker(
				selection: style.shadow,
				label: Text("shadow")
			) {
				ForEach(ShadowType.allCases, id: \.self) { type in
					Text(type.rawValue)
						.tag(type)
				}
			}.pickerStyle(SegmentedPickerStyle())
		}.padding(10)
	}
	var padding: some View {
		VStack(alignment: .leading) {
			Text("padding").font(.callout).fontWeight(.bold)
			Slider(
				value: style.padding,
				in: 5...20
			)
		}.padding(10)

	}
	var border: some View {
		VStack(alignment: .leading) {
			Text("Border").font(.callout).fontWeight(.bold)
			Toggle(isOn: style.border) {
				Text("enable").font(.footnote).foregroundColor(.gray)
			}.toggleStyle(CheckboxStyle())
			if style.border.wrappedValue {
				Toggle(isOn: style.dash) {
					Text("dash").font(.footnote).foregroundColor(.gray)
				}.toggleStyle(CheckboxStyle())
				HStack {
					Text("width").font(.footnote).foregroundColor(.gray)
					Spacer()
					Slider(
						value: style.lineWidth,
						in: 0...5
					)
				}
				HStack {
					Text("color").font(.footnote).foregroundColor(.gray)
					Spacer()
					Picker(
						selection: style.lineColor,
						label: Group {
							if style.textColor.wrappedValue == Color.clear {
								Image(systemName: "circle")
									.resizable()
									.frame(width: 24, height: 24)
									.foregroundColor(.gray)
							} else {
								Circle().fill(style.textColor.wrappedValue).frame(
									width: 24, height: 24)
							}
						}
					) {
						ForEach(StyleColor.allCases, id: \.self) { color in
							Text(color.rawValue)
								.tag(color.color)
						}
					}.pickerStyle(MenuPickerStyle())
				}
			}

		}.padding(10)
	}
}
