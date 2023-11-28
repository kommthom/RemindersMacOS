//
//  RemoteImage.swift
//  RemindersMacOS
//
//  Created by Thomas on 08.09.23.
//

import SwiftUI
import Siesta
import Reminders_Domain

struct RemoteImage: View {
    @Inject private var getImageUseCase: GetImageUCProtocol
    let imageURL: URL
    @State var image: NSImage = Constants.Images.defaultImage!
    var width: CGFloat = 80.0
    var height: CGFloat = 80.0
    
    var body: some View {
        Image(nsImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
            .onAppear(perform: {
                getImageUseCase.execute(imageURL: URLParams(url: imageURL),
                                        onCompletion: setImage )
            })
    }
    func setImage(loadedImage: NSImage) -> Void {
        image = loadedImage
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(imageURL: URL(string: "https://flagcdn.com/w640/us.jpg")!)
    }
}
