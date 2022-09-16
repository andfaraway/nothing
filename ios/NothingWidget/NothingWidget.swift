//
//  NothingWidget.swift
//  NothingWidget
//
//  Created by 李斌 on 2022/9/15.
//

import WidgetKit
import SwiftUI
import Intents
import SDWebImageSwiftUI

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct NothingWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
//        WebImage(url: URL(string: "https://i.loli.net/2019/09/24/rX2RkVWeGKIuJvc.jpg"))
//        Text(entry.date, style: .time).foregroundColor(Color.red)
        
        Image("handsomeman")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

@main
struct NothingWidget: Widget {
    let kind: String = "NothingWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            return Image("handsomeman")
                .resizable()
                .aspectRatio(contentMode: .fit)
//            return NothingWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Nothing")
        .description("Love your love.")
    }
}

struct NothingWidget_Previews: PreviewProvider {
    static var previews: some View {
        NothingWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

private let url = URL(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fhbimg.huabanimg.com%2Fe0a25a7cab0d7c2431978726971d61720732728a315ae-57EskW_fw658&refer=http%3A%2F%2Fhbimg.huabanimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1665830020&t=11bb77fbed9b64a3593321438619f924")!
struct ContentView: View {
    var body: some View {
        NavigationView{
            List{
                NavigationLink(
                    destination: WebImageExample(url: url),
                    label: {
                        Text("WebImageExample")
                    })
            }
            .navigationBarHidden(true)
        }
    }
}

struct WebImageExample: View {
    let url: URL?
    @State var isAnimating: Bool = true
    var body: some View {
        VStack {
            WebImage(url: url)
                .placeholder{Color.gray}
                .resizable()
                .onSuccess(perform: { _, _, _ in
                    print("Success")
                    SDWebImageManager.shared.imageCache.clear(with: .all, completion: nil)//清除图片缓存
                })
                .onFailure(perform: { _ in
                    print("Failure")
                })
                .scaledToFit()
                .frame(height:300)
                .clipped()
            
            WebImage(url: URL(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fhbimg.b0.upaiyun.com%2Fd24885b5b1a6643685ddba5bda3b17866b6c614c33fbd-XtBuP4_fw658&refer=http%3A%2F%2Fhbimg.b0.upaiyun.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1630205128&t=1964ae7a79ad3fcb3d4ca970b19b53b9"), isAnimating: $isAnimating) // 支持动图
                .customLoopCount(.max) // 播放次数
                .playbackRate(1.0) // 播放速度
                .playbackMode(.normal)
        }
    }
}
