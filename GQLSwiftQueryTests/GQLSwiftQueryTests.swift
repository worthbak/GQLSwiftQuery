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
    
    let userQuery = GQLQuery(with: .query, with: "users", with: args, with: [userQueryItem, "token"], includeQueryKey: true)
    
    XCTAssertEqual(userQuery.queryString, "query={users(token:\"123456iadd\",userId:1){user{username,email,points{id,value}},token}}")
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
    
    let userQuery = GQLQuery(with: .mutation, with: "users", with: args, with: [userQueryItem, "token"], includeQueryKey: true)
    
    XCTAssertEqual(userQuery.queryString, "query=mutation{users(token:\"123456iadd\",userId:1){user{username,email,points{id,value}},token}}")
  }
  
}
