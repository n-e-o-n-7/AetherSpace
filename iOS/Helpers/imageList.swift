//
//  imageList.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/9.
//

import Kingfisher
import SwiftUI

@available(iOS 13.0, *)
struct ListDemo: View {

	@State var imageSize: CGFloat = 250
	@State var isPlaying = false

	var body: some View {
		VStack {
			KFImage(URL(string: "http://10.64.69.154:8081/drawing-animation@2x.png")!)
				.loadImmediately()
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: imageSize, height: imageSize)
				.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
				.frame(width: 350, height: 350)
			Button(action: {
				playButtonAction()
			}) {
				Image(systemName: self.isPlaying ? "pause.fill" : "play.fill")
					.font(.system(size: 60))
			}
		}

	}
	func playButtonAction() {
		withAnimation(Animation.spring(response: 0.45, dampingFraction: 0.475, blendDuration: 0)) {
			if self.imageSize == 250 {
				self.imageSize = 350
			} else {
				self.imageSize = 250
			}
			self.isPlaying.toggle()
		}
	}
}

@available(iOS 13.0, *)
struct ImageCell: View {

	@State var done = false

	var alreadyCached: Bool {
		ImageCache.default.isCached(forKey: url.absoluteString)
	}

	let index: Int
	var url: URL {
		URL(string: "https://github.com/onevcat/Flower-Data-Set/raw/master/rose/rose-\(index).jpg")!
	}

	var body: some View {
		HStack(alignment: .center) {
			Spacer()
			KFImage.url(url, isLoaded: $done)
				.resizable()
				.onSuccess { r in
					print("Success: \(self.index) - \(r.cacheType)")
				}
				.onFailure { e in
					print("Error \(self.index): \(e)")
				}
				.onProgress { downloaded, total in
					print("\(downloaded) / \(total))")
				}
				.placeholder {
					HStack {
						Image(systemName: "arrow.2.circlepath.circle")
							.resizable()
							.frame(width: 50, height: 50)
							.padding(10)
						Text("Loading...").font(.title)
					}
					.foregroundColor(.gray)
				}
				.fade(duration: 1)
				.cancelOnDisappear(true)
				.aspectRatio(contentMode: .fit)
				.cornerRadius(20)

			Spacer()
		}.padding(.vertical, 12)
	}

}

@available(iOS 13.0, *)
struct SwiftUIList_Previews: PreviewProvider {
	static var previews: some View {
		ListDemo()
	}
}
