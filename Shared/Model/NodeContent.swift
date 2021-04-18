//
//  NodeContent.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/3/26.
//

import Foundation

struct NodeContent: Codable {

	//image,sound
	var data: Data?
	var fileName: String?
	//image
	var path: String?
	//date
	var time: Date?

	//mark
	var markdown: String?

	//link
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
