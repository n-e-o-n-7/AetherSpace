//
//  ImagePicker.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/7.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

	let configuration: PHPickerConfiguration
	@Environment(\.presentationMode) var presentationMode
	@Binding var pickerResult: UIImage?
	@Binding var photoName: String?

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
		let parent: ImagePicker
		init(_ parent: ImagePicker) {
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
							self.parent.photoName =
								fetchResult.firstObject?.value(forKey: "filename") as? String
							self.parent.pickerResult = newImage as? UIImage
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
