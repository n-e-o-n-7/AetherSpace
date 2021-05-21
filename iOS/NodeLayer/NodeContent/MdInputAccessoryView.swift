//
//  mdInputAccessoryView.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/5/20.
//

import UIKit

class MdButton: UIButton {
	var text: String = ""
	var offset: Int = 0
}
class MdInputAccessoryView: UIInputView {

	private weak var text: UITextView?

	init(text: UITextView) {
		super.init(frame: .zero, inputViewStyle: .default)
		self.text = text
		translatesAutoresizingMaskIntoConstraints = false
		allowsSelfSizing = true

		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.showsVerticalScrollIndicator = false

		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.spacing = 10

		let contents: [(String, [(String, String, Int)])] = [
			(
				"heading",
				[
					("Heading 1", "\n# ", 0), ("Heading 2", "\n## ", 0), ("Heading 3", "\n### ", 0),
					("Heading 4", "\n#### ", 0), ("Heading 5", "\n##### ", 0),
					("Heading 6", "\n###### ", 0),
				]
			),
			(
				"list",
				[
					("Unordered List", "\n* ", 0), ("Ordered List", "\n1. ", 0),
				]
			),
			(
				"block",
				[
					("Quotes", "\n> ", 0), ("Code Fences", "\n```\n```\n", -4),
					("Math Blocks", "\n$$\n$$\n", -4),
					("Table", "\n | First Header  | Second Header | \n", 0),
				]
			),
			(
				"format",
				[
					("Code", "``", -1), ("Underline", "<u></u>", -4), ("Emphasis", "**", -1),
					("Strong", "****", -2),
				]
			),
			(
				"other",
				[
					("Footnote", "\n[^]", -1), ("Link Reference", "\n[]:", -2),
				]
			),
		]
		contents.forEach { (title, buttons) in
			let label = UILabel()
			label.text = title + ": "
			stackView.addArrangedSubview(label)
			buttons.forEach { text in
				let button = MdButton()
				button.translatesAutoresizingMaskIntoConstraints = false
				button.setTitle(text.0, for: .normal)
				button.setTitleColor(.black, for: .normal)
				button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
				button.layer.cornerRadius = 14
				button.backgroundColor = .white
				button.addTarget(
					self, action: #selector(enter(_:)), for: UIControl.Event.touchUpInside)
				button.text = text.1
				button.offset = text.2
				stackView.addArrangedSubview(button)
			}
		}

		scrollView.addSubview(stackView)
		addSubview(scrollView)

		NSLayoutConstraint.activate([
			stackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
			stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 15),
			stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -15),

			scrollView.topAnchor.constraint(equalTo: topAnchor),
			scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
			scrollView.heightAnchor.constraint(equalToConstant: 50),
			scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
			scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
		])

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	@objc private func enter(_ sender: MdButton) {
		text?.insertText(sender.text)
		if sender.offset != 0 {
			moveCursor(offset: sender.offset)
		}
	}

	func moveCursor(offset: Int) {
		if let text = text, let selectedRange = text.selectedTextRange {
			let cursorPosition =
				text.position(from: selectedRange.start, offset: offset)
				?? (offset > 0 ? text.endOfDocument : text.beginningOfDocument)
			text.selectedTextRange = text.textRange(from: cursorPosition, to: cursorPosition)
		}
	}
}
