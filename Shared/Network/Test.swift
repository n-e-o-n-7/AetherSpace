//
//  Test.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/11.
//

import Alamofire
import Combine
import Foundation

func test() {
	AF.request("http://10.64.64.163:8081/api/test", method: .get)
		.responseJSON(completionHandler: { res in
			print(res)
		})
}
