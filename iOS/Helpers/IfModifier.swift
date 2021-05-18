//
//  IfModifier.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/5/17.
//

import SwiftUI

//struct IfModifier<Content:View>: ViewModifier {
//
//
//    let condition: Bool
//    let transform: (Content) -> Content
//    func body(content: Content) -> some View {
//        if confition {
//            transform(content)
//        }else {
//            content
//        }
//    }
//
//}

extension View {
	@ViewBuilder func `if`<Content: View>(
		_ condition: @autoclosure () -> Bool, transform: (Self) -> Content
	) -> some View {
		if condition() {
			transform(self)
		} else {
			self
		}
	}
}
