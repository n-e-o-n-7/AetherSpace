//
//  SpaceEditor.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/3/25.
//

import SwiftUI

struct SpaceEditor: View {
	@EnvironmentObject var svm: SpaceVM

	//MARK: - nodeTrigger
	@State var position = CGPoint.zero
	@State var listPresented = false

	//MARK: - MagnificationGesture
	@GestureState var magnifyBy = CGFloat(1.0)
	var magnification: some Gesture {
		MagnificationGesture()
			.updating($magnifyBy) { currentState, gestureState, transaction in
				gestureState = currentState
			}
	}

	//MARK: - Notification
	@StateObject var delegate = NotificationDelegate()

	var body: some View {

		ZStack {
			if svm.space.mode == Space.ModeType.link {
				Background { location in
					listPresented.toggle()
					position = location
				}.background(Color("CanvasBackground"))

				LinkLayer()

				NodeLayer()

				NodeTrigger(position: $position, isPresented: $listPresented)

				ToolLayer(showSearch: $showSearch)

			}

		}
		.onAppear(
			perform: { accessNotifications(delegate: delegate) }
		)
		.scaleEffect(magnifyBy)
		.gesture(magnification)
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) { backout }
			ToolbarItem(placement: .principal) { mode }
			ToolbarItem(placement: .navigationBarTrailing) { search }
			ToolbarItem(placement: .navigationBarTrailing) { more }
		}

		.navigationBarTitleDisplayMode(.inline)
		//        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
		//        .navigationBarHidden(false)

	}

	//    @GestureState var isDetectingLongPress = false
	//    @State var completedLongPress = false
	//    var longPress: some Gesture {
	//        LongPressGesture(minimumDuration: 1)
	//            .updating($isDetectingLongPress) {
	//                currentstate, gestureState,
	//                transaction in
	//                gestureState = currentstate
	//                transaction.animation = Animation.easeIn(duration: 2.0)
	//            }
	//            .onEnded { finished in
	//                self.completedLongPress = finished
	//                showHistory.toggle()
	//            }
	//    }
	@ViewBuilder
	var backout: some View {

		Button(
			action: {
				print(":")
			},
			label: {
				Label("backout", systemImage: "arrow.uturn.left.circle")
			}
		)

	}

	var mode: some View {
		Picker(
			selection: $svm.space.mode,
			label: Text("mode")
		) {
			ForEach(Space.ModeType.allCases, id: \.self) { type in
				Label(type.rawValue, systemImage: "lasso.sparkles")
					.tag(Optional(type.rawValue))
					.labelStyle(TitleOnlyLabelStyle())
			}
		}.pickerStyle(SegmentedPickerStyle())
			.frame(width: 300)
	}

	@State private var showSearch = false
	@State var searchText = "s"
	@ViewBuilder
	var search: some View {
		if !showSearch {
			Button(
				action: {
					showSearch = true
				},
				label: {
					Label("search", systemImage: "magnifyingglass")
				}
			)
		}
	}

	@State var showAlert = false
	var more: some View {
		Menu {
			Button(
				action: { showAlert.toggle() },
				label: { Label("other", systemImage: "magnifyingglass") }
			)
			Button(
				action: { svm.saveSubject.send(1) },
				label: { Label("save", systemImage: "magnifyingglass") }
			)
		} label: {
			Label("more", systemImage: "ellipsis.circle.fill").font(.title2)

		}
		.menuStyle(DefaultMenuStyle())
		.alert(isPresented: $showAlert) {
			Alert(
				title: Text("success"), message: Text("?"),
				primaryButton: .destructive(Text("确认")) {},
				secondaryButton: .cancel())
		}
	}
}

//struct SpaceEditor_Previews: PreviewProvider {
//    @State static var space = Space(
//        title: "Aether"
//    )
//    static var previews: some View {
//        SpaceEditor(space: $space)
//    }
//}
