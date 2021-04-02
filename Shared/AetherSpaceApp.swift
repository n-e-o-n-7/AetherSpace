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
	var body: some Scene {

		return DocumentGroup(newDocument: AetherSpaceDocument()) { file in

			ContentView()
				.environmentObject(svm)
				.onAppear {
					print(file.document.space, "appear")
					svm.inject(about: file.document.space)
					print(svm.space, "appear")
				}
				.onReceive(
					svm.saveSubject,
					perform: { i in
						svm.save()
						file.document.space = svm.space
						print(file.document.space, "disappear")
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
