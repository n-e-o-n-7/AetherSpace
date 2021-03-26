//
//  AetherSpaceApp.swift
//  Shared
//
//  Created by 许滨麟 on 2021/3/26.
//

import SwiftUI

@main
struct AetherSpaceApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: AetherSpaceDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
