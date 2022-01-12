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
        let entry: SimpleEntry
        
        if let dailyTotalInfo = DailyCovidInfo.dailyTotalInfo {
            entry = SimpleEntry(date: dailyTotalInfo.standardDay, totalInfo: dailyTotalInfo)
        } else {
            entry = SimpleEntry(date: Date(), totalInfo: nil)
        }

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let totalInfo: CovidInfo?
}

struct CovidWidgetEntryView : View {
    var entry: Provider.Entry
    
    let dateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter
    }()
    
    var body: some View {
        VStack {
            Text(dateFormatter.string(from: entry.totalInfo?.standardDay ?? Date()))
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
    let kind: String = "com.wickedrun.CheckCovid"

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
