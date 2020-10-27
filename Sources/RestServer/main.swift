//  main.swift
//  RestServer
//  Created by Fahad Alswailem on 10/25/20.

import Kitura
import Cocoa

let router = Router()
let dbObj = Database.getInstance()

router.all("/ClaimService/add", middleware: BodyParser())

router.get("/"){
    request, response, next in
    response.send("Hello! Welcome to the service.")
    next()
}

//.get - getAll
router.get("ClaimService/getAll"){
    request, response, next in
    
    let cList = ClaimDao().getAll()
    let jsonData : Data = try JSONEncoder().encode(cList)
    let jsonStr = String(data: jsonData, encoding: .utf8)

  //  response.status(.OK)
  //  response.headers["Content-Type"] = "application/json"
    response.send(jsonStr)
    next()
}

//.post - add
router.post("ClaimService/add") {
    request, response, next in

    let body = request.body
    let jObj = body?.asJSON //JSON object
    
    if let jDict = jObj as? [String:String] {
        if let T = jDict["title"],
            let D = jDict["date"]{
            let id = UUID()
            let S = false
            let cObj = Claim(UUID: id.uuidString, t: T, d: D, s: S)
            ClaimDao().addClaim(cObj: cObj)
        }
    }
    response.send("The Claim record was successfully inserted (via POST Method).")
    next()
}

Kitura.addHTTPServer(onPort: 8020, with: router)
Kitura.run()
