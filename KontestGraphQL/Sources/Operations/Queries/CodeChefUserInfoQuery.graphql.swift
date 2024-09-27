// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CodeChefUserInfoQuery: GraphQLQuery {
  public static let operationName: String = "CodeChefUserInfoQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    operationIdentifier: "6f332b429dbb6524ae8f10fc81fa19fc358db2b5b7afaff39f53f9bae060572a"
  )

  public var username: String

  public init(username: String) {
    self.username = username
  }

  public var __variables: Variables? { ["username": username] }

  public struct Data: KontestGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { KontestGraphQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("codeChefQuery", CodeChefQuery?.self),
    ] }

    ///  Query to fetch CodeChef user data by username
    public var codeChefQuery: CodeChefQuery? { __data["codeChefQuery"] }

    /// CodeChefQuery
    ///
    /// Parent Type: `CodeChefQuery`
    public struct CodeChefQuery: KontestGraphQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { KontestGraphQL.Objects.CodeChefQuery }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("user", User?.self, arguments: ["username": .variable("username")]),
      ] }

      ///  Fetch information about a CodeChef user
      public var user: User? { __data["user"] }

      /// CodeChefQuery.User
      ///
      /// Parent Type: `CodeChefUser`
      public struct User: KontestGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { KontestGraphQL.Objects.CodeChefUser }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("countryFlag", String.self),
          .field("countryName", String.self),
          .field("countryRank", Int.self),
          .field("currentRating", Int.self),
          .field("globalRank", Int.self),
          .field("highestRating", Int.self),
          .field("name", String.self),
          .field("profile", String.self),
          .field("stars", String.self),
          .field("success", Bool.self),
        ] }

        ///  The user's highest rating achieved
        public var countryFlag: String { __data["countryFlag"] }
        ///  URL to the user's country flag image
        public var countryName: String { __data["countryName"] }
        ///  The user's global rank
        public var countryRank: Int { __data["countryRank"] }
        ///  The user's name
        public var currentRating: Int { __data["currentRating"] }
        ///  The name of the user's country
        public var globalRank: Int { __data["globalRank"] }
        ///  The user's current rating
        public var highestRating: Int { __data["highestRating"] }
        ///  URL to the user's profile
        public var name: String { __data["name"] }
        ///  Indicates if the user data was fetched successfully
        public var profile: String { __data["profile"] }
        ///  The user's rank within their country
        public var stars: String { __data["stars"] }
        public var success: Bool { __data["success"] }
      }
    }
  }
}
