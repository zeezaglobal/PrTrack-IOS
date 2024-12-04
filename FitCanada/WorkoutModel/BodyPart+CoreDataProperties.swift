//
//  BodyPart+CoreDataProperties.swift
//  FitCanada
//
//  Created by Vijin Raj on 03/12/24.
//
//

import Foundation
import CoreData


extension BodyPart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BodyPart> {
        return NSFetchRequest<BodyPart>(entityName: "BodyPart")
    }

    @NSManaged public var body_part_id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var workouts: NSSet?

}

// MARK: Generated accessors for workouts
extension BodyPart {

    @objc(addWorkoutsObject:)
    @NSManaged public func addToWorkouts(_ value: Workout)

    @objc(removeWorkoutsObject:)
    @NSManaged public func removeFromWorkouts(_ value: Workout)

    @objc(addWorkouts:)
    @NSManaged public func addToWorkouts(_ values: NSSet)

    @objc(removeWorkouts:)
    @NSManaged public func removeFromWorkouts(_ values: NSSet)

}

extension BodyPart : Identifiable {

}
