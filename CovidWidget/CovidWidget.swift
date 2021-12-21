//
//  CovidWidget.swift
//  CovidWidget
//
//  Created by wickedRun on 2021/12/18.
//

import WidgetKit
import SwiftUI
import Intents
import Pods_CheckCovid

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), totalInfo: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), totalInfo: nil)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let entry: SimpleEntry
        if let data = UserDefaults.shared.value(forKey: "DailyTotal") as? Data, let totalInfo = try? JSONDecoder().decode(CovidInfo.self, from: data) {
            entry = SimpleEntry(date: totalInfo.standardDay, totalInfo: totalInfo)
        } else {
            entry = SimpleEntry(date: Date(), totalInfo: nil)
        }
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let totalInfo: CovidInfo?
}

struct CovidWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(CovidInfo.dateFormatter.string(from: entry.totalInfo?.standardDay ?? Date()))
                .font(.title2)
            Text("총 확진자")
                .font(.title2)
            Text("\(entry.totalInfo?.incDec ?? 0)명")
                .font(.title)
                .bold()
                .foregroundColor(.red)
        }
    }
}

@main
struct CovidWidget: Widget {
    let kind: String = "CovidWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CovidWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("CheckCovid Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct CovidWidget_Previews: PreviewProvider {
    static var previews: some View {
        CovidWidgetEntryView(entry: SimpleEntry(date: Date(), totalInfo: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
