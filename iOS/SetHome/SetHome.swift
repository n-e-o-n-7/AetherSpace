//
//  SetHome.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/5.
//

import SwiftUI

struct SetHome: View {
	@Environment(\.presentationMode) var presentationMode
	@EnvironmentObject var svm: SpaceVM

	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("appearance")) {
					color
				}
				Section(header: Text("canvas")) {
					save
				}
				Section(header: Text("system")) {
					system
				}
				Section(header: Text("about")) {
					about
				}
			}
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("cancel") { presentationMode.wrappedValue.dismiss() }
				}
				ToolbarItem(placement: .confirmationAction) {
					Button("done") {

						//MARK: - save
						if enableSave {
							autosave = Double(selections[0] * 60 + selections[1])
						} else {
							autosave = 0
						}

						cache = enableUpload

						mainColor = currentColor

						presentationMode.wrappedValue.dismiss()

					}
				}
			}
			.navigationViewStyle(StackNavigationViewStyle())
			.navigationTitle("Settings")

		}

	}

	@AppStorage("mainColor") var mainColor = "blue"
	@State var currentColor = "blue"
	var color: some View {
		HStack {
			Text("color scheme")
			Spacer()
			Picker(
				selection: $currentColor,
				label: Circle().fill(ColorSet(rawValue: currentColor)!.toColor()).frame(
					width: 27, height: 27)
			) {
				ForEach(ColorSet.allCases, id: \.self) { color in
					Text(color.rawValue).tag(color.rawValue)
				}
			}.pickerStyle(MenuPickerStyle())
				.onAppear {
					currentColor = mainColor
				}
		}
		//		ColorPicker(
		//			"Line Color",
		//			selection: Binding(
		//				get: { lineColor.toColor()! },
		//				set: { newValue in
		//					lineColor = newValue.toString()
		//				}
		//			))
	}

	private let data: [[String]] = [
		Array(0...30).map { "\($0)" },
		Array(0...60).map { "\($0)" },
	]
	@State var enableSave: Bool = false
	@State private var selections: [Int] = [0, 0]
	@AppStorage("autosave") var autosave: TimeInterval = 60
	var save: some View {
		Group {
			Toggle(isOn: $enableSave) {
				Text("Enable Autosave")
			}
			if enableSave {
				HStack {
					Spacer()
					PickerView(data: self.data, selections: self.$selections)
					Spacer()
				}
			}
		}.onAppear {
			if autosave != 0 {
				self.enableSave = true
				self.selections[0] = Int(autosave) / 60
				self.selections[1] = Int(autosave) % 60
			}
		}
	}

	@AppStorage("cache") var cache: Bool = false
	@State var enableUpload = false
	var system: some View {
		Group {
			Button("permission") {
				UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
			}
			Toggle(isOn: $enableUpload) {
				Text("clear photo cache")
			}.onAppear {
				enableUpload = cache
			}
		}
	}

	var about: some View {
		Group {
			NavigationLink(destination: AboutView()) {
				Text("about")
			}
		}
	}
}

struct SetHome_Previews: PreviewProvider {
	static var previews: some View {
		SetHome()
			.previewDevice("iPhone 11 Pro")
	}
}
