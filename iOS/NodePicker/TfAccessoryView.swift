//
//  TfAccessoryView.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/5/20.
//

import UIKit

class TfAccessoryView: UIInputView, UITextFieldDelegate {
	private var text = UILabel()
	init(label: String, textview: UITextField) {
		super.init(frame: .zero, inputViewStyle: .default)

		textview.addTarget(
			self, action: #selector(textViewDidChange(_:)), for: UIControl.Event.editingChanged)

		translatesAutoresizingMaskIntoConstraints = false
		allowsSelfSizing = true

		let title = UILabel()
		title.translatesAutoresizingMaskIntoConstraints = false

		title.text = label
		text.translatesAutoresizingMaskIntoConstraints = false
		text.text = ""
		addSubview(title)
		addSubview(text)

		NSLayoutConstraint.activate([
			heightAnchor.constraint(equalToConstant: 50),
			//			title.topAnchor.constraint(equalTo: topAnchor),
			//			title.bottomAnchor.constraint(equalTo: bottomAnchor),
			//			title.leadingAnchor.constraint(equalTo: leadingAnchor),
			//			title.trailingAnchor.constraint(equalTo: trailingAnchor),
			title.centerYAnchor.constraint(equalTo: centerYAnchor),
			text.centerYAnchor.constraint(equalTo: centerYAnchor),
			title.leadingAnchor.constraint(equalTo: leadingAnchor),
			text.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 10),
		])
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc func textViewDidChange(_ textView: UITextField) {
		text.text = textView.text
	}
}
