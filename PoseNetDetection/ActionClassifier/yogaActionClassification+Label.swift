//
//  yogaActionClassification+Label.swift
//  PoseNetDetection
//
//  Created by curry敏 on 2021/5/11.
//

extension yogaActionClassifier {
    /// Represents the app's knowledge of the Exercise Classifier model's labels.
    enum Label: String, CaseIterable {
        case lotus = "lotus"
        case tree = "tree"
        case squat = "squat"

        /// Creates a label from a string.
        /// - Parameter label: The name of an action class.
        init(_ string: String) {
            guard let label = Label(rawValue: string) else {
                let typeName = String(reflecting: Label.self)
                print(typeName)
                fatalError("Add the `\(string)` label to the `\(typeName)` type.")
            }

            self = label
        }
    }
}
