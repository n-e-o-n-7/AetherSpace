//
//  Constant.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/12.
//

import Foundation
import SwiftUI

let curveOffset: CGFloat = 100
let server: String = "http://47.103.214.73:8081"
let urlReg =
	#"^(?=^.{3,255}$)(http(s)?:\/\/)?(www\.)?[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+(:\d+)*(\/\w+\.\w+)*$"#
	.toReg()!
