//
//  CoreDataManager.swift
//  FitCanada
//
//  Created by Vijin Raj on 03/12/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "FitCanada")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }

        insertDefaultBodyParts() // Insert default body parts if needed
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }

    private func insertDefaultBodyParts() {
        let fetchRequest: NSFetchRequest<BodyPart> = BodyPart.fetchRequest()
        do {
            let count = try context.count(for: fetchRequest)
            if count == 0 {
                let defaultBodyParts = [
                    "Chest", "Biceps", "Triceps", "Shoulder", "Back", "Core", "Legs"
                ]

                for name in defaultBodyParts {
                    let bodyPart = BodyPart(context: context)
                    bodyPart.body_part_id = UUID()
                    bodyPart.name = name
                }

                saveContext()
                print("Default body parts inserted.")
            }
        } catch {
            print("Failed to check or insert default body parts: \(error)")
        }
    }
}
