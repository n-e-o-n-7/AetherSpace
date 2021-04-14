//
//  ImageList.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/8.
//

import SwiftUI

struct ImageList: View {
	@Binding var images: [NodeContent]
	@Environment(\.editMode) var editMode
	var body: some View {
		GeometryReader { proxy in
			ScrollView(.horizontal, showsIndicators: false) {
				LazyHStack(spacing: 15) {
					ForEach(images.indices, id: \.self) { index in
						//						GeometryReader { geometry in
						Image(uiImage: UIImage(data: images[index].data!)!)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.animation(.easeInOut)
							//								.scaleEffect(self.scale(proxy, geometry))
							.overlay(
								ZStack {
									if editMode?.wrappedValue == .active {
										Color.primary.opacity(0.2)
										Button(
											action: {
												images.remove(at: index)
											},
											label: {
												Image(systemName: "xmark.circle.fill")
													.font(.title)
													.foregroundColor(Color("BackColor"))
											})
									}
								}
							).cornerRadius(CornerRadius.mid.rawValue)
							.frame(height: proxy.size.height)
							.shadow(.thin)

						//						}.frame(width: proxy.size.width / 2)
					}
					if editMode?.wrappedValue == .active {

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
