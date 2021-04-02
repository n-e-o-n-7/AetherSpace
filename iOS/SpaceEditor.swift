//
//  SpaceEditor.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/3/25.
//

import SwiftUI

struct SpaceEditor: View {
	@EnvironmentObject var svm: SpaceVM
	@State var save = CGPoint.zero
	@State var extra = CGSize.zero

	@State var showSet = false
	//MARK: - nodeTrigger
	@State var position = CGPoint.zero
	@State var showPicker = false

	//MARK: - MagnificationGesture
	@GestureState var magnifyBy = CGFloat(1.0)
	var magnification: some Gesture {
		MagnificationGesture()
			.updating($magnifyBy) { currentState, gestureState, transaction in
				gestureState = currentState
			}
	}
	@State var a = false
	var body: some View {

		ZStack {
			if svm.space.mode == Space.ModeType.link {
				Background { location in
					showPicker.toggle()
					position = location
				}
				.background(Color("CanvasBackground"))
				.edgesIgnoringSafeArea(.bottom)

				.gesture(
					DragGesture()
						.onChanged { value in

							extra = value.translation

						}.onEnded { value in
							save = CGPoint(x: save.x + extra.width, y: save.y + extra.height)
							extra = CGSize.zero
						}
				)

				Group {
					LinkLayer()

					NodeLayer()
				}
				.scaleEffect(magnifyBy)
				.offset(x: save.x + extra.width, y: save.y + extra.height)

				NodeTrigger(position: $position, isPresented: $showPicker)

				ToolLayer(showSearch: $showSearch)

			}

		}
		.gesture(magnification)
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) { backout }
			ToolbarItem(placement: .principal) { mode }
			ToolbarItem(placement: .navigationBarTrailing) { search }
			ToolbarItem(placement: .navigationBarTrailing) { more }
		}
		.navigationBarTitleDisplayMode(.inline)

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
		if svm.stack.count != 0 {
			Button(
				action: {
					svm.backout()
				},
				label: {
					Label("backout", systemImage: "arrow.uturn.left.circle")
				}
			)
		}
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
			Button(
				action: { showSet.toggle() },
				label: { Label("set", systemImage: "magnifyingglass") }
			)
		} label: {
			Label("more", systemImage: "ellipsis.circle.fill").font(.title2)

		}
		.menuStyle(DefaultMenuStyle())
		.sheet(isPresented: $showSet) {
			SetHome()
		}
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
