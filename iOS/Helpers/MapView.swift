//
//  MapView.swift
//  Aether
//
//  Created by 许滨麟 on 2021/3/21.
//

import MapKit
import SwiftUI

struct MapViewR: UIViewRepresentable {
	func makeUIView(context: Context) -> MKMapView {
		MKMapView(frame: .zero)
	}

	func updateUIView(_ view: MKMapView, context: Context) {
		let coordinate = CLLocationCoordinate2D(
			latitude: -33.523065, longitude: 151.394551)
		let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
		let region = MKCoordinateRegion(center: coordinate, span: span)
		view.setRegion(region, animated: true)
	}
}

struct MapView: View {
	var coordinate: CLLocationCoordinate2D
	@State private var region = MKCoordinateRegion()

	var body: some View {
		Map(coordinateRegion: $region)
			.onAppear {
				setRegion(coordinate)
			}
	}

	private func setRegion(_ coordinate: CLLocationCoordinate2D) {
		region = MKCoordinateRegion(
			center: coordinate,
			span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
		)
	}
}

struct MapView_Previews: PreviewProvider {
	static var previews: some View {
		MapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
	}
}
