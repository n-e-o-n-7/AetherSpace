//
//  ImageList.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/8.
//

import Kingfisher
import SwiftUI

struct ImageList: View {
	@Binding var images: [NodeContent]
	var body: some View {
		GeometryReader { proxy in
			ScrollView(.horizontal, showsIndicators: false) {
				LazyHStack(spacing: 15) {
					ForEach(images.indices, id: \.self) { index in
						//						GeometryReader { geometry in
						Group {
							if let data = images[index].data {
								Image(uiImage: UIImage(data: data)!)
									.resizable()
									.aspectRatio(contentMode: .fit)
							} else {
								KFImage(URL(string: images[index].path!))
									.resizable()
									.placeholder {
										ProgressView().progressViewStyle(
											CircularProgressViewStyle()
										).padding(.bottom)
									}
									.aspectRatio(contentMode: .fit)
							}
						}
						.animation(.easeInOut)
						//								.scaleEffect(self.scale(proxy, geometry))
						.overlay(
							EditImageView(remove: {
								if images.count > 1 { images.remove(at: index) }
							})
						).cornerRadius(CornerRadius.mid.rawValue)
						.frame(height: proxy.size.height)
						.shadow(.thin)
					}
				}.padding(.horizontal, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
			}
		}
	}

	//	func scale(_ proxy: GeometryProxy, _ geometry: GeometryProxy) -> CGFloat {
	//		let center = proxy.size.width / 2
	//		let item = geometry.frame(in: .global).midX
	//		return CGFloat(1 - 0.3 * (abs(item - center) / (proxy.size.width / 2)))
	//	}

}

private struct EditImageView: View {
	@Environment(\.editMode) var editMode
	let remove: () -> Void
	var body: some View {
		ZStack {
			if editMode?.wrappedValue == .active {
				Color.primary.opacity(0.2)
				Button(
					action: remove,
					label: {
						Image(systemName: "xmark.circle.fill")
							.font(.title)
							.foregroundColor(Color("BackColor"))
					})
			}
		}
	}
}
