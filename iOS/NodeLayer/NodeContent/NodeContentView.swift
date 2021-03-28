//
//  ContentView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/22.
//

import SwiftUI

struct NodeContentView: View {
	let type: Node.Species
	@Binding var content: NodeContent
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

	@State var isPresented = false
	var lc: some View {
		Color.gray
			.fullScreenCover(isPresented: $isPresented) {
			}.onTapGesture {
				isPresented.toggle()
			}

	}

	var tc: some View {
		Color.gray
			.fullScreenCover(isPresented: $isPresented) {
			}.onTapGesture {
				isPresented.toggle()
			}
	}
	var dc: some View {
		Color.gray
			.fullScreenCover(isPresented: $isPresented) {
			}.onTapGesture {
				isPresented.toggle()
			}
	}
	var ic: some View {
		Image(uiImage: UIImage(data: content.data!)!)
			.renderingMode(.original)
			.resizable()
			.aspectRatio(contentMode: .fill)
			.fullScreenCover(isPresented: $isPresented) {
				ImageContent(content: $content)
			}.onTapGesture {
				isPresented.toggle()
			}
	}
	var sc: some View {
		Color.gray
			.fullScreenCover(isPresented: $isPresented) {
			}.onTapGesture {
				isPresented.toggle()
			}
	}
	var mc: some View {
		Color.gray
			.fullScreenCover(isPresented: $isPresented) {
				MarkdownContent(markdown: $content.markdown.unwrap()!)
			}.onTapGesture {
				isPresented.toggle()
			}
	}
}
