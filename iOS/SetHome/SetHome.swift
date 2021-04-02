//
//  SetHome.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/5.
//

import SwiftUI

struct SetHome: View {
	@Environment(\.presentationMode) var presentationMode

	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("appearance")) {
					appearance
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
							autosave = selections[0] * 60 + selections[1]
						} else {
							autosave = 0
						}

						presentationMode.wrappedValue.dismiss()

					}
				}
			}
			.navigationViewStyle(StackNavigationViewStyle())
			.navigationTitle("Set")
		}

	}

	@State var colorScheme = "sync with system"
	var appearance: some View {
		HStack {
			Text("color scheme")
			Spacer()
			Menu(colorScheme) {
				Button("light mode") {
					colorScheme = "light mode"
				}
				Button("dark mode") {
					colorScheme = "dark mode"
				}
				Button("sync with") {
					colorScheme = "sync with system"
				}
			}
		}
	}

	@AppStorage("lineColor") var lineColor = "255,204,00,100"
	var color: some View {
		ColorPicker(
			"Line Color",
			selection: Binding(
				get: { lineColor.toColor()! },
				set: { newValue in
					lineColor = newValue.toString()
				}
			))
	}

	private let data: [[String]] = [
		Array(0...30).map { "\($0)" },
		Array(0...60).map { "\($0)" },
	]
	@State var enableSave: Bool = false
	@State private var selections: [Int] = [0, 0]
	@AppStorage("autosave") var autosave = 60
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
				self.selections[0] = autosave / 60
				self.selections[1] = autosave % 60
			}
		}
	}

	@State var uploadImage = false
	var system: some View {
		Group {
			Button("noti") {
				UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
			}
			Toggle(isOn: $enableSave) {
				Text("image upload")
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
