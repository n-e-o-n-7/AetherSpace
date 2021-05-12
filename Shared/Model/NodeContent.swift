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
//protocol NodeContent {}
//extension NodeContent {
//
//}
//
//struct Alink: Codable, NodeContent {
//	var url: String
//}
//struct Amark: Codable, NodeContent {
//	var markdown: String
//}
//struct Atag: Codable, NodeContent {
//    var text:String
//}
//struct Asound: Codable, NodeContent {
//    var data: Data
//    var fileName: String
//}
//struct Aimage: Codable, NodeContent {
//    var data: Data?
//    var fileName: String
//    var path: String?
//}
//
//struct Adate: Codable, NodeContent {
//    var time: Date
//}
