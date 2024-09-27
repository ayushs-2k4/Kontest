// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CodeForcesUserInfoQuery: GraphQLQuery {
  public static let operationName: String = "CodeForcesUserInfoQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    operationIdentifier: "c0c7994bab83928248dd4378286d20af7443acd5f267d95c6a118218c1a3b033"
  )

  public var username: String

  public init(username: String) {
    self.username = username
  }

  public var __variables: Variables? { ["username": username] }

  public struct Data: KontestGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("codeForcesQuery", CodeForcesQuery?.self),
    ] }

    ///  Query to fetch CodeForces user data by username
    public var codeForcesQuery: CodeForcesQuery? { __data["codeForcesQuery"] }

    /// CodeForcesQuery
    ///
    /// Parent Type: `CodeForcesQuery`
    public struct CodeForcesQuery: KontestGraphQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.CodeForcesQuery }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("user", User?.self, arguments: ["username": .variable("username")]),
      ] }

      ///  Fetch basic information about a CodeForces user
      public var user: User? { __data["user"] }

      /// CodeForcesQuery.User
      ///
      /// Parent Type: `CodeForcesUser`
      public struct User: KontestGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.CodeForcesUser }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("avatar", String.self),
          .field("contribution", Int.self),
          .field("friendOfCount", Int.self),
          .field("handle", String.self),
          .field("lastOnlineTimeSeconds", Int.self),
          .field("maxRank", String?.self),
          .field("maxRating", Int?.self),
          .field("rank", String?.self),
          .field("rating", Int?.self),
          .field("registrationTimeSeconds", Int.self),
          .field("titlePhoto", String.self),
        ] }

        ///  The user's handle/username
        public var avatar: String { __data["avatar"] }
        public var contribution: Int { __data["contribution"] }
        ///  Last online time in seconds since epoch
        public var friendOfCount: Int { __data["friendOfCount"] }
        ///  URL to the user's title photo
        public var handle: String { __data["handle"] }
        ///  The user's contribution score
        public var lastOnlineTimeSeconds: Int { __data["lastOnlineTimeSeconds"] }
        ///  Current rank of the user
        public var maxRank: String? { __data["maxRank"] }
        ///  Current rating of the user
        public var maxRating: Int? { __data["maxRating"] }
        ///  Maximum rating achieved by the user
        public var rank: String? { __data["rank"] }
        ///  Registration time in seconds since epoch
        public var rating: Int? { __data["rating"] }
        ///  URL to the user's avatar
        public var registrationTimeSeconds: Int { __data["registrationTimeSeconds"] }
        ///  Number of friends the user has
        public var titlePhoto: String { __data["titlePhoto"] }
      }
    }
  }
}
