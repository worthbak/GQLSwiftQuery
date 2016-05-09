import Foundation

// MARK: Schema Types

extension Dictionary where Key: StringLiteralConvertible, Value: AnyObject {
  
  public var queryArgumentLiteral: String {
    let argKeys = Array(self.keys)
    
    var argumentString = ""
    for item in argKeys {
      argumentString += "\(item):\(self[item]!)"
      if argKeys.last != item {
        argumentString += ","
      }
    }
    
    return argumentString
  }
  
}

public enum GQLSchemaType {
  case Query, Mutation
}

public struct GQLQuery {
  
  public init(withSchemaType schemaType: GQLSchemaType, withQueryTitle title: String, withQueryArguments arguments: [String: AnyObject]? = nil, withQueryItems queryItems: [GQLQueryItemType]) {
    self.schemaType = schemaType
    self.queryTitle = title
    self.arguments = arguments
    self.queryItems = queryItems
  }
  
  public let schemaType: GQLSchemaType
  public let queryTitle: String
  public let arguments: [String: AnyObject]?
  public let queryItems: [GQLQueryItemType]
  
  public var queryString: String {
    
    let argumentString: String
    if let args = self.arguments {
      argumentString = "(\(args.queryArgumentLiteral))"
    } else { argumentString = "" }
    
    let fullQuery = "{\(self.queryTitle)\(argumentString){\(self.queryItems.map { return $0.queryRepresentation }.joinWithSeparator(","))}}"
    
    switch self.schemaType {
    case .Query:
      return "query=\(fullQuery)"
    case .Mutation:
      return "query=mutation\(fullQuery)"
    }
  }
}

// MARK: Query Item Types / Extensions

public protocol GQLQueryItemType {
  var keyDesignation: String { get }
  var queryRepresentation: String { get }
}

extension String: GQLQueryItemType {
  public var keyDesignation: String {
    return self
  }
  
  public var queryRepresentation: String {
    return self
  }
}

public struct GQLQueryItem: GQLQueryItemType {
  
  public init(_ keyDesignation: String) {
    self.init(withKeyDesignation: keyDesignation, andSubqueryFields: nil)
  }
  
  public init(withKeyDesignation keyDesignation: String, andSubqueryFields fields: [GQLQueryItemType]?) {
    self.keyDesignation = keyDesignation
    self.fields = fields
  }
  
  public let keyDesignation: String
  public let fields: [GQLQueryItemType]?
  
  public var queryRepresentation: String {
    if let fields = self.fields {
      let subqueryString = fields.map { return $0.queryRepresentation }.joinWithSeparator(",")
      return "\(self.keyDesignation){\(subqueryString)}"
    } else {
      return "\(self.keyDesignation)"
    }
  }
  
}