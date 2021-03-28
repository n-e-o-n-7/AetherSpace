//
//  Node.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/3/26.
//

import Foundation

struct Node: Identifiable, Codable {
	let id: UUID
	let creatTime: Date
	let type: Species
	var asHeadLinkIds: [UUID]
	var asTailLinkIds: [UUID]
	var content: NodeContent

	init(type: Species, content: NodeContent) {
		self.id = UUID()
		self.creatTime = Date()
		self.type = type
		self.asHeadLinkIds = []
		self.asTailLinkIds = []
		self.content = content
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
//		case content
//	}
//
//	init(from decoder: Decoder) throws {
//		let value = try decoder.container(keyedBy: CodingKeys.self)
//		id = try value.decode(UUID.self, forKey: .id)
//		creatTime = try value.decode(Date.self, forKey: .creatTime)
//		type = try value.decode(Species.self, forKey: .type)
//
//		asHeadLinkIds = try value.decode(Array<UUID>.self, forKey: .asHeadLinkIds)
//		asTailLInkIds = try value.decode(Array<UUID>.self, forKey: .asTailLInkIds)
//
//		switch type {
//		case .link:
//			content = try value.decode(Alink.self, forKey: .content)
//		case .tag:
//			content = try value.decode(Atag.self, forKey: .content)
//		case .date:
//			content = try value.decode(Adate.self, forKey: .content)
//		case .image:
//			content = try value.decode(Aimage.self, forKey: .content)
//		case .sound:
//			content = try value.decode(Asound.self, forKey: .content)
//		case .markdown:
//			content = try value.decode(Amark.self, forKey: .content)
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
//		try v.encode(asTailLInkIds, forKey: .asTailLInkIds)
//		switch type {
//		case .link:
//			try v.encode(content as! Alink, forKey: .content)
//		case .tag:
//			try v.encode(content as! Atag, forKey: .content)
//		case .date:
//			try v.encode(content as! Adate, forKey: .content)
//		case .image:
//			try v.encode(content as! Aimage, forKey: .content)
//		case .sound:
//			try v.encode(content as! Asound, forKey: .content)
//		case .markdown:
//			try v.encode(content as! Amark, forKey: .content)
//		}
//
//	}
//}
