//
//  Node.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/3/26.
//

import Foundation

struct Node: Identifiable, Codable {
	let id: Nid
	let creatTime: Date
	let type: Species
	var asHeadLinkIds: [Lid: Lid]
	var asTailLinkIds: [Lid: Lid]
	var contents: [NodeContent]
	var title: String
	var style: NodeStyle
	init(title: String, type: Species, contents: [NodeContent]) {
		self.id = Nid()
		self.creatTime = Date()
		self.type = type
		self.asHeadLinkIds = [:]
		self.asTailLinkIds = [:]
		self.contents = contents
		self.title = title
		self.style = NodeStyle()
	}
}

extension Node {
	enum Species: String, CaseIterable, Codable {
		case image = "image"
		case sound = "sound"
		case link = "link"
		case date = "date"
		case tag = "tag"
		case markdown = "markdown"

		var systemImage: String {
			switch self {
			case .link:
				return "link"
			case .tag:
				return "drop"
			case .date:
				return "calendar.badge.clock"
			case .image:
				return "photo.fill"
			case .sound:
				return "wave.3.right.circle.fill"
			case .markdown:
				return "doc.append.fill"
			}
		}
	}
}

//extension Node: Codable {
//
//	enum CodingKeys: String, CodingKey {
//		case id
//		case creatTime
//		case type
//		case title
//		case asHeadLinkIds
//		case asTailLInkIds
//		case contents
//	}
//
//	init(from decoder: Decoder) throws {
//		let value = try decoder.container(keyedBy: CodingKeys.self)
//		id = try value.decode(UUID.self, forKey: .id)
//		creatTime = try value.decode(Date.self, forKey: .creatTime)
//		type = try value.decode(Species.self, forKey: .type)
//
//		asHeadLinkIds = try value.decode(Dictionary<Int, Int>.self, forKey: .asHeadLinkIds)
//		asTailLinkIds = try value.decode(Dictionary<Int, Int>.self, forKey: .asTailLInkIds)
//
//		switch type {
//		case .link:
//			contents = try value.decode(Array<Alink>.self, forKey: .contents)
//		case .tag:
//			contents = try value.decode(Array<Atag>.self, forKey: .contents)
//		case .date:
//			contents = try value.decode(Array<Adate>.self, forKey: .contents)
//		case .image:
//			contents = try value.decode(Array<Aimage>.self, forKey: .contents)
//		case .sound:
//			contents = try value.decode(Array<Asound>.self, forKey: .contents)
//		case .markdown:
//			contents = try value.decode(Array<Amark>.self, forKey: .contents)
//		}
//
//	}
//
//	func encode(to encoder: Encoder) throws {
//		var v = encoder.container(keyedBy: CodingKeys.self)
//		try v.encode(id, forKey: .id)
//		try v.encode(creatTime, forKey: .creatTime)
//		try v.encode(type, forKey: .type)
//		try v.encode(asHeadLinkIds, forKey: .asHeadLinkIds)
//		try v.encode(asTailLinkIds, forKey: .asTailLInkIds)
//		switch type {
//		case .link:
//			try v.encode(contents as!Array<Alink>, forKey: .contents)
//		case .tag:
//			try v.encode(contents as!Array<Atag>, forKey: .contents)
//		case .date:
//			try v.encode(contents as!Array<Adate>, forKey: .contents)
//		case .image:
//			try v.encode(contents as!Array<Aimage>, forKey: .contents)
//		case .sound:
//			try v.encode(contents as!Array<Asound>, forKey: .contents)
//		case .markdown:
//			try v.encode(contents as!Array<Amark>, forKey: .contents)
//		}
//	}
//}
