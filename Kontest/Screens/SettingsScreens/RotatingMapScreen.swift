//
//  RotatingMapScreen.swift
//  Kontest
//
//  Created by Ayush Singhal on 30/09/23.
//

import MapKit
import SwiftUI

struct ParkingSpot: Identifiable, Hashable {
    var id: String { self.name }
    let name: String
    let location: CLLocation
    var cameraDistance: Double = 1000
}

struct City: Identifiable, Hashable {
    var id: String { self.name }
    let name: String
    let parkingSpots: [ParkingSpot]
}

struct RandomRotatingMapScreen: View {
    let navigationTitle: String?

    var body: some View {
        let cities: [City] = [.cupertino, .london, .sanFrancisco]
        let selectedCity = cities.randomElement()!

        let parkingSpots = selectedCity.parkingSpots
        let selectedParkingSpot = parkingSpots.randomElement()!

        RotatingMapScreen(parkingSpot: selectedParkingSpot)
            .navigationTitle(self.navigationTitle ?? "")
    }
}

struct RotatingMapScreen: View {
    let parkingSpot: ParkingSpot

    var body: some View {
        TimelineView(.animation) { context in
            VStack {
                let seconds = context.date.timeIntervalSince1970
                let rotationPeriod = 240.0
                let headingDelta = seconds.percent(truncation: rotationPeriod)

                RotatingMapView(coordinates: self.parkingSpot.location, distance: 1000, pitch: 60, heading: headingDelta * 360)
            }
        }
    }
}

struct RotatingMapView: View {
    let coordinates: CLLocation
    let distance: Double
    let pitch: Double
    let heading: CGFloat

    @State private var cameraPosition: MapCameraPosition

    init(coordinates: CLLocation, distance: Double, pitch: Double, heading: CGFloat) {
        self.coordinates = coordinates
        self.distance = distance
        self.pitch = pitch
        self.heading = heading

        self._cameraPosition = State(wrappedValue: .camera(MapCamera(centerCoordinate: coordinates.coordinate, distance: distance, heading: heading, pitch: pitch)))
    }

    var body: some View {
        Map(position: self.$cameraPosition, interactionModes: [])
            .onChange(of: self.heading) { _, _ in
                self.cameraPosition = .camera(MapCamera(centerCoordinate: self.coordinates.coordinate, distance: self.distance, heading: self.heading, pitch: self.pitch))
            }
    }
}

#Preview("RotatingMapScreen") {
    RotatingMapScreen(parkingSpot: City.cupertino.parkingSpots[0])
}

#Preview("RandomRotatingMapScreen") {
    RandomRotatingMapScreen(navigationTitle: "RandomRotatingMapScreen")
}

public extension BinaryFloatingPoint {
    func percent(truncation: Self) -> Self {
        assert(self.isFinite)
        assert(!truncation.isZero && truncation.isFinite)
        return self.truncatingRemainder(dividingBy: truncation) / truncation
    }
}

extension City {
    static let sanFrancisco = City(
        name: "San Francisco",
        parkingSpots: [
            ParkingSpot(
                name: "Coit Tower",
                location: CLLocation(latitude: 37.8024, longitude: -122.4058),
                cameraDistance: 300
            ),
            ParkingSpot(
                name: "Fisherman's Wharf",
                location: CLLocation(latitude: 37.8099, longitude: -122.4103),
                cameraDistance: 700
            ),
            ParkingSpot(
                name: "Ferry Building",
                location: CLLocation(latitude: 37.7956, longitude: -122.3935),
                cameraDistance: 450
            ),
            ParkingSpot(
                name: "Golden Gate Bridge",
                location: CLLocation(latitude: 37.8199, longitude: -122.4783),
                cameraDistance: 2000
            ),
            ParkingSpot(
                name: "Oracle Park",
                location: CLLocation(latitude: 37.7786, longitude: -122.3893),
                cameraDistance: 650
            ),
            ParkingSpot(
                name: "The Castro Theatre",
                location: CLLocation(latitude: 37.7609, longitude: -122.4350),
                cameraDistance: 400
            ),
            ParkingSpot(
                name: "Sutro Tower",
                location: CLLocation(latitude: 37.7552, longitude: -122.4528)
            ),
            ParkingSpot(
                name: "Bay Bridge",
                location: CLLocation(latitude: 37.7983, longitude: -122.3778)
            )
        ]
    )

    static let cupertino = City(
        name: "Cupertino",
        parkingSpots: [
            ParkingSpot(
                name: "Apple Park",
                location: CLLocation(latitude: 37.3348, longitude: -122.0090),
                cameraDistance: 1100
            ),
            ParkingSpot(
                name: "Infinite Loop",
                location: CLLocation(latitude: 37.3317, longitude: -122.0302)
            )
        ]
    )

    static let london = City(
        name: "London",
        parkingSpots: [
            ParkingSpot(
                name: "Big Ben",
                location: CLLocation(latitude: 51.4994, longitude: -0.1245),
                cameraDistance: 850
            ),
            ParkingSpot(
                name: "Buckingham Palace",
                location: CLLocation(latitude: 51.5014, longitude: -0.1419),
                cameraDistance: 750
            ),
            ParkingSpot(
                name: "Marble Arch",
                location: CLLocation(latitude: 51.5131, longitude: -0.1589)
            ),
            ParkingSpot(
                name: "Piccadilly Circus",
                location: CLLocation(latitude: 51.510067, longitude: -0.133869)
            ),
            ParkingSpot(
                name: "Shakespeare's Globe",
                location: CLLocation(latitude: 51.5081, longitude: -0.0972)
            ),
            ParkingSpot(
                name: "Tower Bridge",
                location: CLLocation(latitude: 51.5055, longitude: -0.0754)
            )
        ]
    )

    static let all = [cupertino, sanFrancisco, london]

    static func identified(by id: City.ID) -> City {
        guard let result = all.first(where: { $0.id == id }) else {
            fatalError("Unknown City ID: \(id)")
        }
        return result
    }
}
