import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

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


public struct SwiftDataPreviewMacro: ExtensionMacro {
  public static func expansion(of node: AttributeSyntax,
                               attachedTo declaration: some DeclGroupSyntax,
                               providingExtensionsOf type: some TypeSyntaxProtocol,
                               conformingTo protocols: [TypeSyntax],
                               in context: some MacroExpansionContext)
  throws -> [ExtensionDeclSyntax] {
    let types = persistenceTypes(from: node)
    
    return [ try ExtensionDeclSyntax(
    """
    extension \(type.trimmed): PreviewModifier {
      
      static func makeSharedContext() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(\(raw: types), configurations: config)
        let context = ModelContext(container)
        addData(context: context)
        try context.save()
        return container
      }
      
      func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
      }
    }
    """)
    ]
  }
}

private func persistenceTypes(from node: AttributeSyntax) -> String {
  guard case .argumentList(let arguments) = node.arguments,
        let _ = arguments.first?.expression else {
    fatalError("no arguments")
  }
  return "\(arguments)"
}

@main
struct SwiftDataPreviewPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SwiftDataPreviewMacro.self,
    ]
}
