//  Database.swift
//  RestServer
//  Created by Fahad Alswailem on 10/25/20.

import SQLite3
import Foundation

class Database {
    
    static var dbObj : Database!
    let dbname = "/Users/fs/Desktop/ClaimDB.sqlite" //DataBase Directory
    var conn : OpaquePointer?

    //Initialize DB
    init() {
        if sqlite3_open(dbname, &conn) == SQLITE_OK {
            initializeDB()
            sqlite3_close(conn)
        } else {
            let errcode = sqlite3_errcode(conn)
            print("Open database failed due to error \(errcode)")
        }
    }
    
    //Create Table
    private func initializeDB() {
        //SQL
        let sqlStmt = "create table if not exists Claim (id int, title text, date text, isSolved int)"
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK {
            let errcode = sqlite3_errcode(conn)
            print("Create table failed due to error \(errcode)")
        }
    }
    
    //Connect to DB
    func getDbConnection() -> OpaquePointer? {
        var conn : OpaquePointer?
        
        if sqlite3_open(dbname, &conn) == SQLITE_OK {
            return conn
        } else {
            let errcode = sqlite3_errcode(conn)
            print("Open database failed due to error \(errcode)")
            
            let errmsg = sqlite3_errmsg(conn)
            print("Open database failed due to error \(errmsg!)")
            
            let _ = String(format:"%@", errmsg!)
        }
        return conn
    }
    
    
    static func getInstance() -> Database {
        if dbObj == nil {
            dbObj = Database()
        }
        return dbObj
    }
}
