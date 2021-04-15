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
	//	@Environment(\.editMode) var editMode
	//	@State private var showImage = false
	//	@State var photo: [(String, UIImage)] = []
	//	var config: PHPickerConfiguration {
	//		var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
	//		config.filter = .images  //videos, livePhotos...
	//		config.selectionLimit = 0  //0 => any, set 1-2-3 for har limit
	//		return config
	//	}
	var body: some View {
		VStack {
			HStack {
				Button("cancel") {
					presentationMode.wrappedValue.dismiss()
				}
				Spacer()
				//				if editMode?.wrappedValue == .active {
				//					Button("add image") {
				//						showImage.toggle()
				//					}.buttonStyle(ActionButtonBackgroundStyle())
				//						.sheet(isPresented: $showImage) {
				//							ImagePicker(
				//								configuration: self.config,
				//								pickerResult: $photo)
				//						}                    .onChange(of: photo){ photos in
				//                            photo = []
				//                            let contents = photo.map { (name, image) in
				//                                NodeContent(data: image.pngData(), fileName: name)
				//                            }
				//                            node.contents += contents
				//                        }
				//				}
				EditButton()
			}.padding()
			ImageList(images: $node.contents)
				.listRowInsets(EdgeInsets())
		}

	}
}
