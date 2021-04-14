//
//  SpaceEditor.swift
//  AetherSpace
//
//  Created by 许滨麟 on 2021/3/25.
//

import MobileCoreServices
import SwiftUI

struct SpaceEditor: View {
	@EnvironmentObject var svm: SpaceVM
	@EnvironmentObject var autoSave: AutoSave
	@State var save = CGPoint.zero
	@State var extra = CGSize.zero
	@State var showSet = false
	//MARK: - nodeTrigger
	@State var position = CGPoint.zero
	@State var showPicker = false
	//MARK: - MagnificationGesture
	@GestureState var magnifyBy = CGFloat(1.0)
	@AppStorage("autosave") var autosave: TimeInterval = 60
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
				GeometryReader { proxy in
					Background { offset in
						showPicker.toggle()
						position = offset
					}
					.onDrop(
						of: [String(kUTTypeURL)], isTargeted: nil,
						perform: { (items, point) in
							if let item = items.first {
								if item.canLoadObject(ofClass: URL.self) {
									let _ = item.loadObject(
										ofClass: URL.self,
										completionHandler: { (url, error) in
											let id = UUID(uuidString: url!.path)!
											if self.svm.nodes[id] == nil {
												DispatchQueue.main.async {
													let center = CGPoint(
														x: proxy.size.width / 2,
														y: proxy.size.height / 2)
													let extra = CGPoint(
														x: 0,
														y: UIScreen.main.bounds.size.height
															- proxy.size.height)
													withAnimation(.easeOut) {
														self.svm.nodePosition[id] = PositionVM(
															offset: point.subtract(extra).subtract(
																center
															).subtract(
																self.save))
														self.svm.nodes[id] = id
													}
												}
											}
										})
								}
							}
							return true
						}
					)
					.gesture(
						DragGesture()
							.onChanged { value in
								extra = value.translation
							}.onEnded { value in
								save = CGPoint(x: save.x + extra.width, y: save.y + extra.height)
								extra = CGSize.zero
							}
					)
					.padding(100)
					.background(Color("CanvasBackground"))
				}.edgesIgnoringSafeArea(.vertical)
				Group {
					LinkLayer()
					NodeLayer()
				}
				.scaleEffect(magnifyBy)
				.offset(x: save.x + extra.width, y: save.y + extra.height)

				NodeTrigger(position: $position, save: $save, isPresented: $showPicker)

				ToolLayer(showSearch: $showSearch)

			}
		}
		.gesture(magnification)
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) { quit }
			ToolbarItem(placement: .navigationBarLeading) { backout }
			ToolbarItem(placement: .principal) { mode }
			ToolbarItem(placement: .navigationBarTrailing) { search }
			ToolbarItem(placement: .navigationBarTrailing) { more }
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarHidden(showSearch)

		//MARK: - save
		.onAppear {
			autoSave.setSave(frequency: autosave)
		}
		.onDisappear {
			autoSave.setSave(frequency: 0)
		}
		.onChange(of: autosave) { time in
			autoSave.setSave(frequency: time)
		}

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
	@Environment(\.loading) var showLoad: Binding<Bool>
	var quit: some View {
		Button(
			action: {
				showLoad.wrappedValue.toggle()
				autoSave.save()
				DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
					UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
					{}
				}
			},
			label: {
				Label("home", systemImage: "tray.full")
			}
		)
	}

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

	var more: some View {
		Menu {
			Button(
				action: { autoSave.save() },
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
