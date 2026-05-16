//
//  LeagueEntity+CoreDataProperties.swift
//  Sport Mob
//
//  Created by Ehab Salah on 04/05/2026.
//
//

public import Foundation
public import CoreData


public typealias LeagueEntityCoreDataPropertiesSet = NSSet

extension LeagueEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LeagueEntity> {
        return NSFetchRequest<LeagueEntity>(entityName: "LeagueEntity")
    }

    @NSManaged public var countryImage: String?
    @NSManaged public var countryName: String?
    @NSManaged public var id: Int64
    @NSManaged public var leagueImage: String?
    @NSManaged public var leagueName: String?
    @NSManaged public var sportEndpoint: String?

}

extension LeagueEntity : Identifiable {

}
