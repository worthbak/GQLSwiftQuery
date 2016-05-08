//
//  GQLSwiftQueryTests.swift
//  GQLSwiftQueryTests
//
//  Created by David Baker on 5/8/16.
//  Copyright © 2016 worthbak.com. All rights reserved.
//

import XCTest
@testable import GQLSwiftQuery

class GQLSwiftQueryTests: XCTestCase {
  
  
  func testQueryGeneration() {
    let pointsSubquery = GQLQueryItem(withKeyDesignation: "points", andSubqueryFields: ["id", "value"])
    
    let userQueryItem = GQLQueryItem(
      withKeyDesignation: "user",
      andSubqueryFields: [
        "username",
        "email",
        pointsSubquery
      ]
    )
    
    let args = [
      "userId": 1,
      "token": "123456iadd"
    ]
    
    let userQuery = GQLQuery(withSchemaType: .Query, withQueryTitle: "users", withQueryArguments: args, withQuery: userQueryItem)
    
    XCTAssertEqual(userQuery.queryString, "{users(userId:1,token:123456iadd){user{username,email,points{id,value}}}}")
  }
  
  func testMutationGeneration() {
    let pointsSubquery = GQLQueryItem(withKeyDesignation: "points", andSubqueryFields: ["id", "value"])
    
    let userQueryItem = GQLQueryItem(
      withKeyDesignation: "user",
      andSubqueryFields: [
        "username",
        "email",
        pointsSubquery
      ]
    )
    
    let args = [
      "userId": 1,
      "token": "123456iadd"
    ]
    
    let userQuery = GQLQuery(withSchemaType: .Mutation, withQueryTitle: "users", withQueryArguments: args, withQuery: userQueryItem)
    
    XCTAssertEqual(userQuery.queryString, "mutation{users(userId:1,token:123456iadd){user{username,email,points{id,value}}}}")
  }
  
}
