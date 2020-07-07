//
//  JustWalking.swift
//  JustWalking
//
//  Created by Mohammad Azam on 7/7/20.
//

import WidgetKit
import SwiftUI

struct StepEntry: TimelineEntry {
    var date: Date = Date()
    var steps: Int
}

struct Provider: TimelineProvider {
    
    typealias Entry = StepEntry
    
    @AppStorage("stepCount", store: UserDefaults(suiteName: "group.com.azamsharp.JustWalking"))
    var stepCount: Int = 0
    
    func snapshot(with context: Context, completion: @escaping (Entry) -> ()) {
        let entry = StepEntry(steps: stepCount)
        completion(entry)
    }
    
    func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = StepEntry(steps: stepCount)
        completion(Timeline(entries: [entry], policy: .atEnd))
    }
    
}

struct StepView: View {
    let entry: Provider.Entry
    
    var body: some View {
        Text("\(entry.steps)")
    }
}

@main
struct StepWidget: Widget {
    private let kind = "StepWidget"
    
    var body: some WidgetConfiguration {
        
        StaticConfiguration(kind: kind, provider: Provider(), placeholder: Text("Step Count")) { entry in
            StepView(entry: entry)
        }
        
    }
}

