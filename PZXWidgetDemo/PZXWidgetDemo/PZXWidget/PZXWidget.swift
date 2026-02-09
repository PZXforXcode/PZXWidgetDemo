//
//  PZXWidget.swift
//  PZXWidget
//
//  Created by KpengS on 2026/2/5.
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct PZXSmallView: View {

    var isOn: Bool = false

    var body: some View {
        VStack(spacing: 12) {
            Text(isOn ? "已开启" : "已关闭")
                .font(.headline)

            Button(intent: ToggleWidgetIntent()) {
                Text(isOn ? "关闭" : "开启")
            }
            .buttonStyle(.borderedProminent)
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct MediumMotorWidgetView: View {
    var isOn: Bool = false

    var body: some View {
        HStack(alignment: .top) {
            // 左侧信息与控制区
            VStack(alignment: .leading, spacing: 0) {
                // 标题
                Text("无极机车")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                
                // 地址
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.caption2)
                    Text("隆鑫C区")
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundStyle(.gray)
                .padding(.top, 4)

                Spacer()

                // 控制按钮组
                HStack(spacing: 15) {
                    // 开锁/锁定按钮
                    Button(intent: ToggleWidgetIntent()) {
                        VStack(spacing: 3) {
                            Image(systemName: isOn ? "lock.open.fill" : "lock.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(isOn ? .green : .white)
                            Text(isOn ? "已开锁" : "已锁定")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .frame(width: 64, height: 50)
                        .background(Color.white.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)

                    // 闪灯按钮
                    Button(intent: OpenUnlockIntent(action: WidgetConstants.Actions.flash)) {

                        VStack(spacing: 3) {
                            Image(systemName: "light.beacon.max.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(.yellow)
                            Text("闪灯")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .frame(width: 64, height: 50)
                        .background(Color.white.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 4)
            }
            .padding(.vertical, 8)
            
            Spacer()

            // 右侧摩托车图片展示
            ZStack {
                // 背景光晕效果
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)
                
                Image(systemName: "motorcycle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 110, height: 80)
                    .foregroundStyle(.linearGradient(colors: [.white, .gray], startPoint: .top, endPoint: .bottom))
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                    // 轻微旋转增加动感
                    .rotationEffect(.degrees(-5))
            }
            .offset(x: 10, y: 15) // 调整位置使其更饱满
        }
        .containerBackground(for: .widget) {
            // 深蓝色渐变背景
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.1, blue: 0.3), // 深蓝
                    Color(red: 0.02, green: 0.05, blue: 0.15)  // 深邃夜空蓝
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

struct PZXWidgetEntryView: View {
    let entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    @AppStorage(WidgetConstants.Keys.isOn, store: UserDefaults(suiteName: WidgetConstants.appGroupIdentifier))
    var isOn: Bool = false

    var body: some View {
        switch family {
          case .systemSmall:
            PZXSmallView(isOn: isOn)
          case .systemMedium:
            MediumMotorWidgetView(isOn: isOn)
          case .systemLarge:
            PZXSmallView(isOn: isOn)
          case .systemExtraLarge:
            PZXSmallView(isOn: isOn)
          default:
            PZXSmallView(isOn: isOn)
          }
    }
}

struct PZXWidget: Widget {
    let kind: String = "PZXWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                PZXWidgetEntryView(entry: entry)
            } else {
                PZXWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    PZXWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
