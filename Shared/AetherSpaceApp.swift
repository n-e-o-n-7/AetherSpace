//
//  AetherSpaceApp.swift
//  Shared
//
//  Created by 许滨麟 on 2021/3/26.
//

import Combine
import SwiftUI

@main
struct AetherSpaceApp: App {
	let svm = SpaceVM()
	let autoSave = AutoSave()
	var body: some Scene {

		return DocumentGroup(newDocument: AetherSpaceDocument()) { file in

			ContentView()
				.environmentObject(svm)
				.environmentObject(autoSave)
				.navigationBarHidden(true)
				.onAppear {
					svm.inject(about: file.document.space)
				}
				.onReceive(
					autoSave.saveSubject,
					perform: { _ in
						svm.savePosition()
						file.document.space = svm.space
					})
		}
	}
}

//func content(file: FileDocumentConfiguration<AetherSpaceDocument>) -> some View {
//	let svm = SpaceVM()
//	print("asd")//change
//	return ContentView()
//		.environmentObject(svm)
//		.onAppear {
//			print(file.document.space, "appear")
//			svm.space = file.document.space
//			print(svm.space, "appear")
//		}
//		.onReceive(
//			svm.saveSubject,
//			perform: { i in
//				svm.save()
//				file.document.space = svm.space
//				print(file.document.space, "disappear")
//			})
//}
