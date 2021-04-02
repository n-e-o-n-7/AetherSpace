//
//  AboutView.swift
//  AetherSpace (iOS)
//
//  Created by 许滨麟 on 2021/4/2.
//

import SwiftUI

struct AboutView: View {
	var body: some View {

		Form {
			//			HStack {
			//				Spacer()
			//				Image("Icon")
			//					.renderingMode(.original)
			//					.resizable()
			//					.aspectRatio(contentMode: .fill)
			//					.frame(
			//						width: /*@START_MENU_TOKEN@*/ 100 /*@END_MENU_TOKEN@*/,
			//						height: /*@START_MENU_TOKEN@*/ 100 /*@END_MENU_TOKEN@*/,
			//						alignment: /*@START_MENU_TOKEN@*/ .center /*@END_MENU_TOKEN@*/)
			//				Spacer()
			//			}

			Section {
				Text("privacy policy")
				Text("content licenses")
			}
		}
		.listStyle(InsetListStyle())
		.navigationTitle("about")
	}
}

struct AboutView_Previews: PreviewProvider {
	static var previews: some View {
		AboutView()
	}
}
