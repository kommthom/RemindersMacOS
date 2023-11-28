//
//  CachedDownloadsFolderInfoView.swift
//  RemindersMacOS
//
//  Created by Thomas on 22.10.23.
//

import SwiftUI

struct CachedDownloadsFolderInfoView: View {
    var cachedDownloadsFolderSize: Int64
    var onButtonTapped: ( _ buttonTapped: ButtonTapped) -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Image(systemName: "archivebox")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
                VStack(alignment: .leading, spacing: 2) {
                    Text("start-page.cached-downloads-\(cachedDownloadsFolderSize.formatted(.byteCount(style: .file)))")
                    Text("start-page.cached-downloads.description")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(2)
            Spacer()
            Button {
                onButtonTapped(.fastCacheDeletion)
            } label: {
                Text("start-page.cached-downloads.action")
            }
        }
    }
}

/*#Preview {
    CachedDownloadsFolderInfoView()
}*/
