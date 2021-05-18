//
//  ImageSinglePicker.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/5/18.
//

import PhotosUI
import SwiftUI

struct ImageSinglePicker: UIViewControllerRepresentable {

	let configuration: PHPickerConfiguration
	@Environment(\.presentationMode) var presentationMode
	let done: (String, UIImage) -> Void

	func makeUIViewController(context: Context)
		-> PHPickerViewController
	{
		let controller = PHPickerViewController(configuration: configuration)
		controller.delegate = context.coordinator
		return controller
	}

	func updateUIViewController(
		_ uiViewController: PHPickerViewController,
		context: Context
	) {}

	func makeCoordinator() -> Coordinator {
		return Coordinator(self)
	}

	class Coordinator: PHPickerViewControllerDelegate {
		let parent: ImageSinglePicker
		init(_ parent: ImageSinglePicker) {
			self.parent = parent
		}

		func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
			for image in results {
				if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
					image.itemProvider.loadObject(ofClass: UIImage.self) { (newImage, error) in
						if let error = error {
							print(error.localizedDescription)
						} else {
							let fetchResult = PHAsset.fetchAssets(
								withLocalIdentifiers: [image.assetIdentifier!], options: nil)
							let photoName =
								fetchResult.firstObject?.value(forKey: "filename") as? String
							let image = newImage as? UIImage
							self.parent.done(photoName!, image!)
						}
					}
				} else {
					print("Loaded Assest is not a Image")
				}
			}
			parent.presentationMode.wrappedValue.dismiss()
		}
	}
}
