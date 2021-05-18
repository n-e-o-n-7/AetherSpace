//
//  ImageView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/22.
//

import PhotosUI
import SwiftUI

struct ImageContent: View {
	@Environment(\.presentationMode) var presentationMode
	@Binding var node: Node
	@Environment(\.editMode) var editMode
	@State private var showImage = false

	var config: PHPickerConfiguration {
		var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
		config.filter = .images
		config.selectionLimit = 1
		return config
	}
	var body: some View {
		VStack {
			HStack {
				Button("cancel") {
					presentationMode.wrappedValue.dismiss()
				}
				Spacer()
				if editMode?.wrappedValue == .active {
					Button("add image") {
						showImage.toggle()
					}.buttonStyle(ActionButtonBackgroundStyle())
						.sheet(isPresented: $showImage) {
							ImageSinglePicker(configuration: self.config) { (name, image) in
								let content = NodeContent(data: image.pngData(), fileName: name)
								node.contents.append(content)
							}
						}

				}
				EditButton()
			}.padding()
			ImageList(images: $node.contents)
				.listRowInsets(EdgeInsets())
		}

	}
}
