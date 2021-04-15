//
//  AddContent.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/24.
//

import PhotosUI
import SwiftUI

struct AddContent: View {
	@Binding var nodeType: Node.Species
	let confirm: ([NodeContent]) -> Void
	var body: some View {
		switch nodeType {
		case .link:
			return AnyView(lp)
		case .tag:
			return AnyView(tp)
		case .date:
			return AnyView(dp)
		case .image:
			return AnyView(ip)
		case .sound:
			return AnyView(sp)
		case .markdown:
			return AnyView(mp)
		}
	}

	//MARK: - link
	@State private var link = ""
	@ViewBuilder
	var lp: some View {
		Text("content").font(.caption).foregroundColor(.gray).fontWeight(.bold)
		TextField(
			"please enter link🔗",
			text: $link
		) { isEditing in

		} onCommit: {

		}
		.autocapitalization(.none)
		.disableAutocorrection(true)
		Spacer()
		confirmButton {
			let content = NodeContent(url: link)
			confirm([content])
		}
	}

	//MARK: - date
	@State private var date = Date()
	let dateRange: ClosedRange<Date> = {
		let calendar = Calendar.current
		let startComponents = DateComponents(year: 2021, month: 1, day: 1)
		let endComponents = DateComponents(
			year: 2021, month: 12, day: 31, hour: 23, minute: 59, second: 59)
		return calendar.date(from: startComponents)!...calendar.date(from: endComponents)!
	}()
	@ViewBuilder
	var dp: some View {
		Text("content").font(.caption).foregroundColor(.gray).fontWeight(.bold)
		DatePicker(
			"",
			selection: $date,
			in: dateRange,
			displayedComponents: [.date, .hourAndMinute]
		)
		.labelsHidden().accentColor(Color("TextColor"))
		//        DatePicker("", selection: $date, displayedComponents: [.hourAndMinute])
		//            .labelsHidden()
		//            .accentColor(.black)
		Spacer()
		confirmButton {
			let content = NodeContent(time: date)
			confirm([content])
		}
	}

	//MARK: - image
	@State private var showImage = false
	@State var photo: [(String, UIImage)] = []
	var config: PHPickerConfiguration {
		var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
		config.filter = .images  //videos, livePhotos...
		config.selectionLimit = 0  //0 => any, set 1-2-3 for har limit
		return config
	}
	@ViewBuilder
	var ip: some View {
		Text("content").font(.caption).foregroundColor(.gray).fontWeight(.bold)
		if photo.count == 0 {
			Button("click to add image") {
				showImage.toggle()
			}
			.accentColor(ColorSet(rawValue: mainColor)!.toColor())
			.sheet(isPresented: $showImage) {
				ImagePicker(
					configuration: self.config,
					pickerResult: $photo)
			}.padding(.top, 5)
		} else {
			Text("choose \(photo.count) images").padding(.top, 5).foregroundColor(
				(ColorSet(rawValue: mainColor)!.toColor()))
		}
		Spacer()
		confirmButton {
			guard photo.count != 0 else { return }
			let contents = photo.map { (name, image) in
				NodeContent(data: image.pngData(), fileName: name)
			}
			confirm(contents)
		}
	}

	//MARK: - sound
	@State var sound: Data?
	@State var soundName: String?
	@State var showSound: Bool = false
	let fileType = "mp3"
	@ViewBuilder
	var sp: some View {
		Text("content").font(.caption).foregroundColor(.gray).fontWeight(.bold)
		soundName.map {
			Text($0.replacingOccurrences(of: "%20", with: " "))
		}
		if sound == nil {
			Button("click to add audio") {
				showSound.toggle()
			}
			.accentColor(ColorSet(rawValue: mainColor)!.toColor())
			.sheet(isPresented: $showSound) {
				DocumentPicker(sound: $sound, soundName: $soundName, fileType: fileType)
			}.padding(.top, 5)
		}
		Spacer()
		confirmButton {
			let content = NodeContent(data: sound, fileName: soundName ?? "")
			confirm([content])

		}
	}
	//MARK: - markdown
	var mp: some View {
		confirmButton {
			let content = NodeContent(markdown: example)
			confirm([content])
		}
	}

	//MARK: - tag
	var tp: some View {
		confirmButton {
			let content = NodeContent()
			confirm([content])
		}
	}

	@AppStorage("mainColor") var mainColor = "blue"
	func confirmButton(confirm: @escaping () -> Void) -> some View {
		Button(
			action: confirm,
			label: {
				ColorSet(rawValue: mainColor)!.toColor().opacity(0.3)
					.cornerRadius(CornerRadius.ssmall.rawValue)
					.overlay(
						Text("confirm")
							.fontWeight(.bold)
							.foregroundColor(ColorSet(rawValue: mainColor)!.toColor())
					)
					//        .buttonStyle(LightButtonStyle())
					.frame(height: 40)
					.padding(.top, 5)
			}
		)
	}
}
