//
//  Upload.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/10.
//

import Alamofire
import Combine
import Foundation

func uploadPublisher(data: Data, name: String, mimeType: String) -> AnyPublisher<
	uploadResponse, AFError
> {

	return AF.upload(
		multipartFormData: { multipartFormData in
			multipartFormData.append(
				data, withName: "file", fileName: name, mimeType: mimeType)
		}, to: server + "/upload"
	)
	.validate()
	.publishDecodable(type: uploadResponse.self)
	.value()
}

//func upload(data: Data?, name: String?) {
//
//	if let data = data, let name = name {
//		let fileType = name.split(separator: ".").last!
//		let mimeType: String
//		switch fileType {
//		case "png":
//			mimeType = "img/png"
//		case "mp3":
//			mimeType = "audio/mpeg"
//		default:
//			mimeType = ""
//		}
//		let token = SubscriptionToken()
//		uploadPublisher(data: data, name: name, mimeType: mimeType)
//			.sink(
//				receiveCompletion: { c in
//					print("\(c)")
//					createNotification()
//					token.unseal()
//				},
//				receiveValue: { value in
//					print(value)
//				}
//			)
//			.seal(in: token)
//	}
//}
func upload(data: Data?, name: String?) -> AnyPublisher<uploadResponse, AFError>? {

	if let data = data, let name = name {
		let fileType = name.split(separator: ".").last!
		let mimeType: String
		switch fileType {
		case "png":
			mimeType = "img/png"
		case "mp3":
			mimeType = "audio/mpeg"
		default:
			mimeType = ""
		}

		return uploadPublisher(data: data, name: name, mimeType: mimeType)
	}
	return nil
}

struct uploadResponse: Decodable {
	let name: String
	let savePath: String
	let size: Int
	let type: String
}
