import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


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
