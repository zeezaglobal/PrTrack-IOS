//
//  Workout+CoreDataProperties.swift
//  FitCanada
//
//  Created by Vijin Raj on 03/12/24.
//
//

import Foundation
import CoreData


extension Workout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    @NSManaged public var desc: String?
    @NSManaged public var name: String?
    @NSManaged public var workout_id: UUID?
    @NSManaged public var bodyPart: BodyPart?
    @NSManaged public var workoutLogs: NSSet?

}

// MARK: Generated accessors for workoutLogs
extension Workout {

    @objc(addWorkoutLogsObject:)
    @NSManaged public func addToWorkoutLogs(_ value: WorkoutLog)

    @objc(removeWorkoutLogsObject:)
    @NSManaged public func removeFromWorkoutLogs(_ value: WorkoutLog)

    @objc(addWorkoutLogs:)
    @NSManaged public func addToWorkoutLogs(_ values: NSSet)

    @objc(removeWorkoutLogs:)
    @NSManaged public func removeFromWorkoutLogs(_ values: NSSet)

}

extension Workout : Identifiable {

}
