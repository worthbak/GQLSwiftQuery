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

let userQuery = GQLQuery(
	withSchemaType: .Query, 
	withQueryTitle: "users", 
	withQueryArguments: args, 
	withQuery: userQueryItem
)
```

Once defined, you can simply access the `queryString` property of `userQuery` to access a full GraphQL query, suitable for use in a GET request to your server: 

```swift
print(userQuery.queryString)
// {users(userId:1,token:"123456abcd"){user{username,email,points{id,value}}}}
```

Finally, if you're building a `mutation` query, simply pass in `.Mutation` for the `GQLSchemaType`: 

```swift
let userQuery = GQLQuery(
	withSchemaType: .Mutation, 
	withQueryTitle: "users", 
	withQueryArguments: args, 
	withQuery: userQueryItem
)

print(userQuery.queryString)
// mutation{users(userId:1,token:"123456abcd"){user{username,email,points{id,value}}}}
```

## Full Example Usage (w/ NSURLSession)

In this example, we're constructing a mutation query for creating a Facebook user on a hypothetical social media platform. Upon a successful creation, we're requestion some user data and an API token. 

```swift
let userDataQuery = GQLQueryItem(
  withKeyDesignation: "user",
  andSubqueryFields: ["id", "username", "email", "facebookId"]
)

let fullQuery = GQLQuery(
  withSchemaType: .Mutation,
  withQueryTitle: "createFacebookUser",
  withQueryArguments: ["facebookToken": facebookTokenString, "username": "worthbak"],
  withQueryItems: [userDataQuery, "apiToken"]
)

let components = NSURLComponents()
components.scheme = "http"
components.host = "localhost"
components.port = 3000
components.path = "/graphql"

components.query = fullQuery.queryString
guard let url = components.URL else { return }

let request = NSMutableURLRequest(URL: url)
request.HTTPMethod = "POST"

let session = NSURLSession.sharedSession()
let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
  if (error != nil) {
    print(error)
  } else {
    guard let data = data else { return }
    
    do {
      let dict = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? NSDictionary
      
      if let dict = dict {
        print(dict)
      }
      
    } catch (let error) {
      print(error)
    }
    
  }
})

dataTask.resume()
```

## To-Do

- Expand unit tests
- Add proper integration with Alamofire, Maya, etc. 