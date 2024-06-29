import SwiftDataPreview
import SwiftUI
import SwiftData

@SwiftDataPreview(for: Mix.self, Temp.self)
struct MixPreviewData {
  static func addData(context: ModelContext) {
    for mix in Mix.sampleMixes {
      context.insert(mix)
    }
  }
}



// Data source

@Model
public class Mix {
  public var name: String = ""
  public var lastUsed: Date = Date()
  public var hasPreferment: Bool = false
  public var desiredDoughTemperature: Double = 76
  public var frictionCoefficient: Double = 2
    
  public init(name: String,
              desiredDoughTemperature: Double,
              frictionCoefficient: Double,
              hasPreferment: Bool) {
    self.name = name
    self.desiredDoughTemperature = desiredDoughTemperature
    self.frictionCoefficient = frictionCoefficient
    self.hasPreferment = hasPreferment
    self.lastUsed = Date()
  }
}

@Model
class Temp {
  init() {}
}

extension Mix {
  public static var sampleMixes: [Mix] {
    [Mix(name: "Epi",
        desiredDoughTemperature: 78,
        frictionCoefficient: 2,
        hasPreferment: false),
     Mix(name: "Batard",
         desiredDoughTemperature: 80,
         frictionCoefficient: 2,
         hasPreferment: false),
      Mix(name: "Sour Dough",
          desiredDoughTemperature: 82,
          frictionCoefficient: 12,
          hasPreferment: true),
       Mix(name: "Rye",
           desiredDoughTemperature: 76,
           frictionCoefficient: 12,
           hasPreferment: true)]

  }
}


