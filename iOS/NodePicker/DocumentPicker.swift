//
//  DocumentPicker.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
	@Environment(\.presentationMode) var presentationMode
	@Binding var sound: Data?
	@Binding var soundName: String?
	let fileType: String
	func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
		let documentPicker = UIDocumentPickerViewController(
			forOpeningContentTypes: [
				UTType(filenameExtension: fileType)!
			], asCopy: true)

		documentPicker.delegate = context.coordinator
		documentPicker.allowsMultipleSelection = false
		return documentPicker
	}

	func updateUIViewController(
		_ uiViewController: UIDocumentPickerViewController, context: Context
	) {}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	class Coordinator: NSObject, UIDocumentPickerDelegate {
		let parent: DocumentPicker
		init(_ parent: DocumentPicker) {
			self.parent = parent
		}

		func documentPicker(
			_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]
		) {

			if let url = urls.first {
				print(url)

				self.parent.sound = try! Data(contentsOf: url)

				print(self.parent.sound!)
				self.parent.soundName = String(url.absoluteString.split(separator: "/").last!)
			}

		}
		func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {

			parent.presentationMode.wrappedValue.dismiss()
		}
	}

}
