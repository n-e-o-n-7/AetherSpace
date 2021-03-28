//
//  AetherSpaceDocument.swift
//  Shared
//
//  Created by 许滨麟 on 2021/3/26.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
	static let spaceDocument = UTType(exportedAs: "com.Aether.space")
}

struct AetherSpaceDocument: FileDocument {
	var space: Space

	init() {
		self.space = Space()

	}

	static var readableContentTypes: [UTType] { [.spaceDocument] }

	init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents else {
			throw CocoaError(.fileReadCorruptFile)
		}
		self.space = try JSONDecoder().decode(Space.self, from: data)

	}

	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		let data = try JSONEncoder().encode(space)
		return .init(regularFileWithContents: data)
	}
}
