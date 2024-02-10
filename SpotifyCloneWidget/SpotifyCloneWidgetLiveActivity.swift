//
//  SpotifyCloneWidgetLiveActivity.swift
//  SpotifyCloneWidget
//
//  Created by Edson Dario Toledo Gonzalez on 28/01/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SpotifyCloneWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SpotifyCloneWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SpotifyCloneWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension SpotifyCloneWidgetAttributes {
    fileprivate static var preview: SpotifyCloneWidgetAttributes {
        SpotifyCloneWidgetAttributes(name: "World")
    }
}

extension SpotifyCloneWidgetAttributes.ContentState {
    fileprivate static var smiley: SpotifyCloneWidgetAttributes.ContentState {
        SpotifyCloneWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: SpotifyCloneWidgetAttributes.ContentState {
         SpotifyCloneWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: SpotifyCloneWidgetAttributes.preview) {
   SpotifyCloneWidgetLiveActivity()
} contentStates: {
    SpotifyCloneWidgetAttributes.ContentState.smiley
    SpotifyCloneWidgetAttributes.ContentState.starEyes
}
