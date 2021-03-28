//
//  NodeContent.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/3/26.
//

import Foundation

struct NodeContent: Codable {
	var title: String?

	var data: Data?
	var path: String?
	var fileName: String?

	var time: Date?

	var markdown: String?

	var url: String?
}
//protocol NodeContent {
//	var title: String { get set }
//}
//
//struct Alink: Codable, NodeContent {
//	var title: String
//	var url: String
//}
//struct Amark: Codable, NodeContent {
//	var title: String
//	var markdown: String
//}
//struct Atag: Codable, NodeContent {
//	var title: String
//}
//struct Asound: Codable, NodeContent {
//	var title: String
//	var savePath: String?
//	var soundName: String
//	var data: Data?
//}
//struct Aimage: Codable, NodeContent {
//	var title: String
//	var savePath: String?
//	var imageName: String
//	var data: Data?
//}
//
//struct Adate: Codable, NodeContent {
//	var title: String
//	var time: Date
//}
