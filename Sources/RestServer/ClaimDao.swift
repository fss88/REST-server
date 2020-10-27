//  ClaimDao.swift
//  RestServer
//  Created by Fahad Alswailem on 10/25/20.

import SQLite3
import Cocoa

struct Claim : Codable {
    var id : String
    var title : String?
    var date : String?
    var isSolved : Bool
    

    init(UUID: String, t:String?, d : String?, s : Bool) {
        id = UUID
        title = t
        date = d
        isSolved = s
    }
    
}


class ClaimDao {
    
    func addClaim(cObj : Claim) {
        
        let sqlStmt = String(format:"insert into Claim (id, title, date, isSolved) values ('%@','%@', '%@', '0')", (cObj.id), (cObj.title)!, (cObj.date)!)

        let conn = Database.getInstance().getDbConnection()

        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK {
            let errcode = sqlite3_errcode(conn)
            print("Failed to insert a Claim record due to error \(errcode)")
        }
        sqlite3_close(conn)
    }
    
    
    func getAll() -> [Claim] {
        
        var cList = [Claim]()
        var resultSet : OpaquePointer?
        
        let sqlStr = "select id, title, date, isSolved from claim"
        let conn = Database.getInstance().getDbConnection()
        
        if sqlite3_prepare_v2(conn, sqlStr, -1, &resultSet, nil) == SQLITE_OK {
            while(sqlite3_step(resultSet) == SQLITE_ROW) {

                let ID_val = sqlite3_column_text(resultSet, 0)
                let id = String(cString: ID_val!)
              
                let T_val = sqlite3_column_text(resultSet, 1)
                let T = String(cString: T_val!)
                
                let D_val = sqlite3_column_text(resultSet, 2)
                let D = String(cString: D_val!)
               
                let S_val = sqlite3_column_int(resultSet, 3)
                let S = Bool(truncating: S_val as NSNumber)
               
                cList.append(Claim(UUID: id, t: T, d: D, s: S))
            }
        }
        return cList
    }
}
