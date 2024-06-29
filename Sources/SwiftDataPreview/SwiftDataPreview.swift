import SwiftData
import SwiftUI

/// An extension macro for SwiftData PreviewModifiers.
/// The user specifies the PersistentModel Type or Types
/// as arguments to the macro. Although the macro doesn't test for it,
/// it is assumed that we are applying it to a struct which contains a
/// static method named addData() that adds the sample data to the
/// ModelContext it takes as its argument. In other words, this is the
/// call site:
///```
///@SwiftDataPreview(for: Mix.self, Temp.self)
///struct MixPreviewData {
///  static func addData(context: ModelContext) {
///    for mix in Mix.sampleMixes {
///      context.insert(mix)
///    }
///  }
///}
///```
/// This adds the extension:
/// ```
///extension MixPreviewData: PreviewModifier {
///
///  static func makeSharedContext() throws -> ModelContainer {
///    let config = ModelConfiguration(isStoredInMemoryOnly: true)
///    let container = try ModelContainer(for: Mix.self, Temp.self, configurations: config)
///    let context = ModelContext(container)
///    addData(context: context)
///    try context.save()
///    return container
///  }
///
///  func body(content: Content, context: ModelContainer) -> some View {
///    content.modelContainer(context)
///  }
///}
///```

@attached(extension, conformances: PreviewModifier,
          names: named(body), named(makeSharedContext))
public macro SwiftDataPreview(for values: any PersistentModel.Type...) =
#externalMacro(module: "SwiftDataPreviewMacros",
               type: "SwiftDataPreviewMacro")
