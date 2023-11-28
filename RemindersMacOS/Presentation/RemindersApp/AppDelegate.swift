//
//  AppDelegate.swift
//  RemindersMacOS
//
//  Created by Thomas on 21.10.23.
//

import SwiftUI
import Reminders_Domain
import Combine

class AppDelegate: NSObject, NSApplicationDelegate {
    @AppStorage("showInMenuBar") var showInMenuBar = false
    @MainActor let homeBrewState = HomeBrewState()
    @MainActor let gitHubState = GitHubState()
    @MainActor let remindersState = RemindersState()
    var window: NSWindow?
    var subscribers = Set<AnyCancellable>()

    func applicationDidBecomeActive(_ notification: Notification) {
        self.window = NSApp.mainWindow
        if let _ = self.window {
            self.window!.center()
            self.window!.makeKeyAndOrderFront(nil)
            self.window!.contentRect(forFrameRect: NSRect(x: 0, y: 0, width: Geometries.main.window[AppSection.reminders.rawValue].width, height: Geometries.main.window[AppSection.reminders.rawValue].height))
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupResizeNotification()
    }

    private func setupResizeNotification() {
        NotificationCenter.default.publisher(for: MainTabCoordinatorView.needsNewSize)
            .sink(receiveCompletion: {_ in}) { [unowned self] notification in
                if let size = notification.object as? CGSize, self.window != nil {
                    var frame = self.window!.frame
                    let old = self.window!.contentRect(forFrameRect: frame).size
                    let dX = size.width - old.width
                    let dY = size.height - old.height
                    frame.origin.y -= dY // origin in flipped coordinates
                    frame.size.width += dX
                    frame.size.height += dY
                    NSAnimationContext.runAnimationGroup({ context in
                        context.timingFunction = CAMediaTimingFunction(name: .easeIn)
                        window!.animator().setFrame(frame, display: true, animate: true)
                    }, completionHandler: {
                    })
                }
            }
            .store(in: &subscribers)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        return !showInMenuBar
    }

    func applicationWillTerminate(_ notification: Notification) {
        AppLogger.homeBrew.log("Will die...")
        //do {
            //try saveTaggedIDsToDisk(appState: appState)
        //} catch let dataSavingError as NSError {
        //    AppLogger.homeBrew.log("Failed while trying to save data to disk: \(dataSavingError)")
        //}
        AppLogger.homeBrew.log("Died")
    }
    
    private var aboutWindowController: NSWindowController?

    func showAboutPanel() {
        if aboutWindowController == nil {
            let styleMask: NSWindow.StyleMask = [.closable, .miniaturizable, .titled]
            let window = NSWindow()
            window.styleMask = styleMask
            window.title = NSLocalizedString("about.title", comment: "")
            window.contentView = NSHostingView(rootView: AboutView())
            aboutWindowController = NSWindowController(window: window)
        }
        aboutWindowController?.window?.center()
        aboutWindowController?.showWindow(aboutWindowController?.window)
    }
}

