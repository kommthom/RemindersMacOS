//
//  HomeBrewToolbar.swift
//  RemindersMacOS
//
//  Created by Thomas on 19.11.23.
//

import SwiftUI

struct HomeBrewToolbar: CustomizableToolbarContent {
    let upgradeDisabled: Bool //homeBrewMainVM.brewData.outdatedPackages.count == 0
    var onButtonTapped: (_ buttonTapped: HomeBrewPackages.Action) -> Void

    var body: some CustomizableToolbarContent {
        ToolbarItem(id: "upgradePackages", placement: .primaryAction) {
            Button {
                onButtonTapped( .packagesUpdateTapped)
            } label: {
                Label {
                    Text("navigation.upgrade-packages")
                } icon: {
                    Image(systemName: "arrow.clockwise")
                }
            }
            .help("navigation.upgrade-packages.help")
            .disabled(upgradeDisabled)
        }
        ToolbarItem(id: "addTap", placement: .primaryAction) {
            Button {
                onButtonTapped( .addTapTapped)
            } label: {
                Label {
                    Text("navigation.add-tap")
                } icon: {
                    Image(systemName: "spigot")
                }
            }
            .help("navigation.add-tap.help")
        }
        ToolbarItem(id: "installPackage", placement: .primaryAction) {
            Button {
                onButtonTapped( .installPackageTapped)
            } label: {
                Label {
                    Text("navigation.install-package")
                } icon: {
                    Image(systemName: "plus")
                }
            }
            .help("navigation.install-package.help")
        }
    }
}
