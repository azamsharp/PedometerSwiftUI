//
//  ContentView.swift
//  Shared
//
//  Created by Mohammad Azam on 7/7/20.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    
    @AppStorage("stepCount", store: UserDefaults(suiteName: "group.com.azamsharp.JustWalking"))
    var stepCount: Int = 0
    
    private let pedometer: CMPedometer = CMPedometer()
    
    @State private var steps: Int?
    @State private var distance: Double?
    
    private var isPedometerAvailable: Bool {
           return CMPedometer.isPedometerEventTrackingAvailable() && CMPedometer.isDistanceAvailable() && CMPedometer.isStepCountingAvailable()
       }
    
    private func updateUI(data: CMPedometerData) {
        
        stepCount = data.numberOfSteps.intValue
        steps = data.numberOfSteps.intValue
        
        guard let pedometerDistance = data.distance else { return }
        
        let distanceInMeters = Measurement(value: pedometerDistance.doubleValue, unit: UnitLength.meters)
        
        distance = distanceInMeters.converted(to: .miles).value
        
    }
    
    private func initializePedometer() {
       
        if isPedometerAvailable {
            
            guard let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else {
                return
            }
            
            pedometer.queryPedometerData(from: startDate, to: Date()) { (data, error) in
                
                guard let data = data, error == nil else { return }
                
                updateUI(data: data)
                
                
            }
            
            
        }
        
    }
    
    var body: some View {
        VStack {
          
            Text(steps != nil ? "\(steps!) steps" : "").padding()
            Text(distance != nil ? String(format: "%.2f miles",distance!) : "").padding()
                
            Button("Update Steps") {
                stepCount = Int.random(in: 5000...9999)
            }
            
                .onAppear {
                    initializePedometer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
