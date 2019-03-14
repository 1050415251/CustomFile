//
//  RealmManager.swift
//  Test
//
//  Created by 国投 on 2019/3/14.
//  Copyright © 2019 FlyKite. All rights reserved.
//

import Foundation
import RealmSwift




class RealmManager<T: Object>: NSObject {

    //MARK: 增
    class func insert<U: Object>(objects: [U]) {
        guard RelamDb.openDB() else { return }
        do {
            try RelamDb.realmDb.write {
                RelamDb.realmDb.add(objects)
            }
        }catch(let error) {
            print("Realm 数据库插入失败：\(error.localizedDescription)")
        }
    }

    //MARK: 删
    class func delete<U: Object>(objects: [U]) {
        guard RelamDb.openDB() else { return }
        do {
            try RelamDb.realmDb.write {
                RelamDb.realmDb.delete(objects)
            }
        }catch(let error) {
            print("Realm 数据库删除失败：\(error.localizedDescription)")
        }
    }

    //MARK: 改
    class func update<U: Object>(object: [U]) {
        guard RelamDb.openDB() else { return }
        do {
            try RelamDb.realmDb.write {
                RelamDb.realmDb.add(object, update: true)
            }
        }catch(let error) {
            print("Realm 数据库删除失败：\(error.localizedDescription)")
        }
    }

    //MARK: 查
    class func find<U>(primaryKey: U) -> T? {
        guard RelamDb.openDB() else { return nil }
        return RelamDb.realmDb.object(ofType: T.self, forPrimaryKey: primaryKey)
    }

    /// 查询所有
    class func findAll() -> Results<T>? {
        guard RelamDb.openDB() else { return nil }
        return RelamDb.realmDb.objects(T.self)
    }

    /// 条件筛选根据谓词
    class func find(predicate: NSPredicate) -> Results<T>? {

        if let objects = findAll() {
            return objects.filter(predicate)
        }
        return nil
    }

    class func openDB() {
        RelamDb.openDB()
    }

    class func closeDB() {
        RelamDb.closeDB()
    }
}


private struct RelamDb {

    static var realmDb: Realm!

    @discardableResult
    static func openDB() -> Bool {
        if realmDb == nil {
            /// 如果要存储的数据模型属性发生变化,需要配置当前版本号比之前大
            let dbVersion : UInt64 = 2
            let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
            let dbPath = docPath.appending("/defaultDB.realm")
            debugPrint(dbPath)
            let config = Realm.Configuration(fileURL: URL.init(string: dbPath), inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: dbVersion, migrationBlock: { (migration, oldSchemaVersion) in

            }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
            Realm.Configuration.defaultConfiguration = config
            Realm.asyncOpen { (realm, error) in
                if let r = realm {
                    print("Realm 服务器配置成功!")
                    realmDb = r
                }else if let error = error {
                    print("Realm 数据库配置失败：\(error.localizedDescription)")
                }
            }
        }
        return realmDb != nil
    }

    static func closeDB() {
        realmDb.invalidate()
        realmDb = nil
    }
}

extension URL: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String

    public init(stringLiteral value: StringLiteralType) {
        guard let url = URL(string: "\(value)") else {
            preconditionFailure("This url: \(value) is not invalid")
        }
        self = url
    }

}

