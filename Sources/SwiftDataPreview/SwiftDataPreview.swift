import SwiftData
import SwiftUI

@attached(extension, conformances: PreviewModifier,
          names: named(body), named(makeSharedContext))
public macro SwiftDataPreview(for values: any PersistentModel.Type...) =
#externalMacro(module: "SwiftDataPreviewMacros",
               type: "SwiftDataPreviewMacro")
