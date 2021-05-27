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

//enum NodeContent{
//    case image(Array<Aimage>)
//    case sound (Asound)
//    case link (Alink)
//    case date (Adate)
//    case tag (Atag)
//    case markdown (Amark)
//
//    var systemImage: String {
//        switch self {
//        case .link:
//            return "link"
//        case .tag:
//            return "drop"
//        case .date:
//            return "calendar.badge.clock"
//        case .image:
//            return "photo.fill"
//        case .sound:
//            return "wave.3.right.circle.fill"
//        case .markdown:
//            return "doc.append.fill"
//        }
//    }
//}
//struct Alink: Codable {
//    var url: String
//}
//struct Amark: Codable {
//    var markdown: String
//}
//struct Atag: Codable {
//    var text:String
//}
//struct Asound: Codable {
//    var data: Data
//    var fileName: String
//}
//struct Aimage: Codable {
//    var data: Data?
//    var fileName: String
//    var path: String?
//}
//
//struct Adate: Codable {
//    var time: Date
//}


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
