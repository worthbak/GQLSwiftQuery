# GQLSwiftQuery
A simple GraphQL query constructor for iOS, written in Swift. 

## Installation

GQLSwiftQuery is fully contained in one file, so if you're not on the Cocoapods train, feel free to simply drag `GQLSwiftQueryTests.swift` into your Xcode project. Otherwise, add the following to your Podfile: 

```
pod 'GQLSwiftQuery', :git => 'https://github.com/worthbak/GQLSwiftQuery'
```

## Usage

In GQLSwiftQuery, GraphQL queries are defined primarily through objects that conform to the `GQLQueryItemType` protocol, namely the `GQLQueryItem` struct, but also simple Swift `String`s. `GQLQueryItem`s are appropriate to use when creating a nested query, but a simple `String` type will do if a single parameter is being defined. 

This may sound more complex than it is. Consider this example: 

```swift
import GQLSwiftQuery

let pointsSubquery = GQLQueryItem(withKeyDesignation: "points", andSubqueryFields: ["id", "value"])
    
let userQueryItem = GQLQueryItem(
  withKeyDesignation: "user",
  andSubqueryFields: [
    "username",
    "email",
    pointsSubquery
  ]
)
```

`userQueryItem` defines the fields of a GraphQL query that seeks to fetch `user` data from a server, including a username, email, as well as information about a user's `points` (including the point value and its unique identifier). 

In order to turn this GQLQueryItem into a full query, simply pass it in to an instance of `GQLQuery` (along with any required query arguments): 

```swift
let args = [
  "userId": 1,
  "authToken": "123456abcd"
]

let userQuery = GQLQuery(withSchemaType: .Query, withQueryTitle: "users", withQueryArguments: args, withQuery: userQueryItem)
```

Once defined, you can simply access the `queryString` property of `userQuery` to access a full GraphQL query, suitable for use in a GET request to your server: 

```swift
print(userQuery.queryString)
// {users(userId:1,token:123456iadd){user{username,email,points{id,value}}}}
```

Finally, if you're building a `mutation` query, simply pass in `.Mutation` for the `GQLSchemaType`: 

```swift
let userQuery = GQLQuery(withSchemaType: .Mutation, withQueryTitle: "users", withQueryArguments: args, withQuery: userQueryItem)

print(userQuery.queryString)
// mutation{users(userId:1,token:123456iadd){user{username,email,points{id,value}}}}
```

## To-Do

- Expand unit tests
- Add proper integration with Alamofire, Maya, etc. 