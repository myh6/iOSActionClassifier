//
//  yogaActionClassification+Singleton.swift
//  PoseNetDetection
//
//  Created by curry敏 on 2021/5/11.
//

import CoreML

extension yogaActionClassification {
    /// Creates a shared Exercise Classifier instance for the app at launch.
    static let shared: yogaActionClassification = {
        // Use a default model configuration.
        let defaultConfig = MLModelConfiguration()

        // Create an Exercise Classifier instance.
        guard let yogaClassifier = try? yogaActionClassification(configuration: defaultConfig) else {
            // The app requires the action classifier to function.
            fatalError("yoga Classifier failed to initialize.")
        }

        // Ensure the Exercise Classifier.Label cases match the model's classes.
        yogaClassifier.checkLabels()

        return yogaClassifier
    }()
}
