//
//  Geometries.swift
//  RemindersMacOS
//
//  Created by Thomas on 25.11.23.
//

import Foundation
import SwiftUI

enum AppSection: Int {
    case reminders = 0
    case gitHub = 1
    case homeBrew = 2
}

struct Rect {
    var width: CGFloat
    var height: CGFloat
}

class Geometries {
    static var main: Geometries = Geometries()
    
    var screen: Rect
    var windowWidthScale: [CGFloat]
    var windowHeightScale: [CGFloat]
    var window: [Rect]
    var headerHeight: CGFloat
    var frameWidth: CGFloat
    var content: [Rect]
    var sidebarScale: CGFloat
    var sidebarMinWidth: [CGFloat]
    var sidebarWidth: [CGFloat]
    var detailWidth: [CGFloat]
    
    init() {
        self.screen = Rect(width: NSScreen.main!.visibleFrame.size.width, height: NSScreen.main!.visibleFrame.height)
        self.windowWidthScale = [0.5, 0.475, 0.45]
        self.windowHeightScale = [0.55, 0.55, 0.55]
        self.window = []
        for index in 0...2 {
            self.window.append(Rect(width: self.screen.width * self.windowWidthScale[0], height: self.screen.height * self.windowHeightScale[index]))
        }
        self.headerHeight = 70
        self.frameWidth = 4
        self.content = []
        for index in 0...2 {
            self.content.append(Rect(width: self.window[index].width - (2 * self.frameWidth), height: self.window[index].height - self.headerHeight - (2 * self.frameWidth)))
        }
        self.sidebarScale = 0.33
        self.sidebarMinWidth = [350, 350, 350]
        self.sidebarWidth = []
        self.detailWidth = []
        for index in 0...2 {
            self.sidebarWidth.append(max(self.content[index].width * self.sidebarScale, self.sidebarMinWidth[index]))
            self.detailWidth.append(max(self.content[index].width - self.sidebarWidth[index], self.sidebarMinWidth[index]))
        }
    }
}
