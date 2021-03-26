//
//  ContentView.swift
//  Shared
//
//  Created by 许滨麟 on 2021/3/26.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: AetherSpaceDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(AetherSpaceDocument()))
    }
}
