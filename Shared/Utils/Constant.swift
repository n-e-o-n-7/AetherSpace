//
//  Constant.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/12.
//

import CoreGraphics

let curveOffset: CGFloat = 100
let server: String = "http://47.103.214.73:8081"
let urlReg =
	#"^(http(s)?:\/\/)?[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+(:[0-9]{1,5})?[-a-zA-Z0-9()@:%_\\\+\.~#?&//=]*$"#
	.toReg()!
