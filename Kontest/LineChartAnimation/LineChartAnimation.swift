//
//  LineChartAnimation.swift
//  Kontest
//
//  Created by Ayush Singhal on 1/17/24.
//

import Charts
import SwiftUI

struct LineChartAnimation: View {
    @State private var trimVal: CGFloat = 0

    @State private var arrayOfData: [(Int, Int)] = []

    let maxX = 10
    let maxY = 10

    var body: some View {
        VStack {
            Text("Hello, World!")

            GeometryReader { geo in
                Chart {
                    ForEach(arrayOfData, id: \.0) { dataPoint in
                        PointMark(x: .value("X", dataPoint.0), y: .value("Y", dataPoint.1))
                            .annotation {
                                Text("(\(dataPoint.0), \(dataPoint.1))")
                            }
                            .offset(.zero)
                    }
                }
                .offset(.zero)
//                .position(CGPoint(x: geo.size.width / 2, y: geo.size.height / 2))
                .chartXScale(domain: 0...maxX)
                .chartYScale(domain: 0...maxY)
                .overlay(content: {
                    let size = geo.size

                    Text("width: \(size.width), height: \(size.height)")
                        .position(CGPoint(x: 125.0, y: 10.0))

                    Path { path in
                        path.move(to: .init(x: 0, y: Int(geo.size.height / CGFloat(maxY)) * Int(maxY)))

                        for dataPoint in arrayOfData {
                            let originalX = dataPoint.0
                            let originalY = dataPoint.1

                            let convertedX = Int(geo.size.width / CGFloat(maxX)) * Int(originalX)
                            let convertedY = Int(size.height) - (Int(geo.size.height / CGFloat(maxY)) * Int(originalY))

                            path.addLine(to: CGPoint(x: convertedX, y: convertedY))
                        }
                    }
                    .trim(from: 0.0, to: trimVal)
                    .stroke(style: .init(lineWidth: 1))
                    .fill(Color.accentColor)
                    .padding(20)
                    .navigationTitle(Text("Square View"))
                })
                .onAppear(perform: {
                    for num in 0...maxX {
                        arrayOfData.append((num, num))
                    }

                    withAnimation(.easeInOut(duration: 2)) {
                        trimVal = 1
                    }
                })
            }
        }
    }
}

func mapValue(value: Int, inRange: ClosedRange<Int>, toRange: ClosedRange<Int>) -> Double {
    let fromRange = inRange.upperBound - inRange.lowerBound
    let ansToRange = toRange.upperBound - toRange.lowerBound
    let scaledValue = (value - inRange.lowerBound) / fromRange
    return Double(toRange.lowerBound + scaledValue * ansToRange)
}

#Preview {
    LineChartAnimation()
        .frame(width: 400, height: 400)
}
