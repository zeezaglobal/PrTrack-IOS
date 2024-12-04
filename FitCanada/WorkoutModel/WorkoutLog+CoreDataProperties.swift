//
//  WorkoutLog+CoreDataProperties.swift
//  FitCanada
//
//  Created by Vijin Raj on 03/12/24.
//
//

import Foundation
import CoreData


extension WorkoutLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutLog> {
        return NSFetchRequest<WorkoutLog>(entityName: "WorkoutLog")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var sets: Int32
    @NSManaged public var weight: Double
    @NSManaged public var workout: Workout?

}

extension WorkoutLog : Identifiable {

}
