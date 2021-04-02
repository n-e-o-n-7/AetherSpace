import SwiftUI
//
//  TimePicker.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/4/2.
//
import UIKit

//struct TimePicker: View {
//   // Start timer at mid-day
//    @State private var seconds: TimeInterval = 60 * 60 * 12
//
//    static let formatter: DateComponentsFormatter = {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.hour, .minute]
//        return formatter
//    }()
//
//    var body: some View {
//        Text(Self.formatter.string(from: seconds)!)
//            .font(.title)
//            .digitalCrownRotation(
//                $seconds, from: 0, through: 60 * 60 * 24 - 1, by: 60)
//    }
//
//}

struct PickerView: UIViewRepresentable {
	var data: [[String]]
	@Binding var selections: [Int]

	//makeCoordinator()
	func makeCoordinator() -> PickerView.Coordinator {
		Coordinator(self)
	}

	//makeUIView(context:)
	func makeUIView(context: UIViewRepresentableContext<PickerView>) -> UIPickerView {
		let picker = UIPickerView(frame: .zero)

		let min = UILabel()
		min.text = "min"

		let sec = UILabel()
		sec.text = "sec"

		picker.dataSource = context.coordinator
		picker.delegate = context.coordinator
		picker.setPickerLabels(labels: [0: min, 1: sec])
		return picker
	}

	//updateUIView(_:context:)
	func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<PickerView>) {
		for i in 0...(self.selections.count - 1) {
			view.selectRow(self.selections[i], inComponent: i, animated: false)
		}
	}

	class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
		var parent: PickerView

		//init(_:)
		init(_ pickerView: PickerView) {
			self.parent = pickerView
		}

		//numberOfComponents(in:)
		func numberOfComponents(in pickerView: UIPickerView) -> Int {
			return self.parent.data.count
		}

		//pickerView(_:numberOfRowsInComponent:)
		func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
			return self.parent.data[component].count
		}

		//pickerView(_:titleForRow:forComponent:)
		func pickerView(
			_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int
		) -> String? {
			return self.parent.data[component][row]
		}

		//pickerView(_:didSelectRow:inComponent:)
		func pickerView(
			_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int
		) {
			self.parent.selections[component] = row
		}

	}
}

extension UIPickerView {

	func setPickerLabels(labels: [Int: UILabel]) {  // [component number:label]

		let fontSize: CGFloat = 20
		let labelWidth: CGFloat = self.frame.size.width / CGFloat(self.numberOfComponents) + 3
		let x: CGFloat = self.frame.origin.x
		let y: CGFloat = (self.frame.size.height / 2) - (fontSize / 2)

		for i in 0..<self.numberOfComponents {

			if let label = labels[i] {

				if self.subviews.contains(label) {
					label.removeFromSuperview()
				}

				label.frame = CGRect(
					x: x + labelWidth * CGFloat(i) + 37, y: y, width: labelWidth, height: fontSize)
				label.font = UIFont.boldSystemFont(ofSize: fontSize)
				label.backgroundColor = .clear
				label.textAlignment = NSTextAlignment.center

				self.addSubview(label)
			}
		}
	}
}
