//
//  GetImageUC.swift
//  RemindersMacOS
//
//  Created by Thomas on 20.09.23.
//

import Foundation
import Siesta
import SwiftUI
import Reminders_Domain

// MARK: - Implementation -

public class DefaultGetImageUC: GetImageUCProtocol {
    private let repository: ImageWebRepositoryProtocol
    
    public init(repository: ImageWebRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(imageURL: URLParams, onCompletion: @escaping (_ image: NSImage) -> Void) {
        let _ = SiestaResourceHandler<NSImage, URLParams>.init(getResource: repository.imageResource, params: imageURL, { image in
            onCompletion(isNull(image, Constants.Images.defaultImage!))
        } )
    }
}

public class MockedGetImageUC: GetImageUCProtocol {
    public func execute(imageURL: URLParams, onCompletion: @escaping (_ image: NSImage) -> Void) {
        onCompletion(Constants.Images.defaultImage!)
    }
    
    public init() {
    }
}
