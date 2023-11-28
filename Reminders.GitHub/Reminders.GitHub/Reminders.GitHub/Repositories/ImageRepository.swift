//
//  ImageWebRepository.swift
//  RemindersMacOS
//
//  Created by Thomas on 03.09.23.
//

import Siesta
import SwiftUI
import Reminders_Domain

public let ImageRepository = _ImageWebRepository()

public class _ImageWebRepository: ImageWebRepositoryProtocol {
    // MARK: - Configuration

    private let service = Service()
        //baseURL: "https://api.github.com",
        //standardTransformers: [.text, .image])
    
    /// Optional image transform applyed to placeholderImage and downloaded image
    @objc
    public var imageTransform: (NSImage?) -> NSImage? = { $0 }

    fileprivate init() {
    }
    
    public func imageResource(imageURL: URLParams) -> Resource {
        return service
            .resource(absoluteURL: imageURL.url)
    }
}
