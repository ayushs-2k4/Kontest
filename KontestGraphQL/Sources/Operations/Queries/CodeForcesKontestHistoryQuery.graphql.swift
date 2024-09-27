// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CodeForcesKontestHistoryQuery: GraphQLQuery {
  public static let operationName: String = "CodeForcesKontestHistoryQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    operationIdentifier: "6cae5492033c8f61d4d6d4ad803552879797dd7004f5dbfa66a008a84231d016"
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
        .field("userContestHistory", [UserContestHistory]?.self, arguments: ["username": .variable("username")]),
      ] }

      ///  Fetch the contest history for a CodeForces user
      public var userContestHistory: [UserContestHistory]? { __data["userContestHistory"] }

      /// CodeForcesQuery.UserContestHistory
      ///
      /// Parent Type: `CodeForcesUserRating`
      public struct UserContestHistory: KontestGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.CodeForcesUserRating }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("contestId", Int.self),
          .field("contestName", String.self),
          .field("handle", String.self),
          .field("newRating", Int.self),
          .field("oldRating", Int.self),
          .field("rank", Int.self),
          .field("ratingUpdateTimeSeconds", Int.self),
        ] }

        public var contestId: Int { __data["contestId"] }
        ///  Unique ID of the contest
        public var contestName: String { __data["contestName"] }
        ///  Name of the contest
        public var handle: String { __data["handle"] }
        ///  User's rating before the contest
        public var newRating: Int { __data["newRating"] }
        ///  Time of the rating update in seconds since epoch
        public var oldRating: Int { __data["oldRating"] }
        ///  The user's handle/username
        public var rank: Int { __data["rank"] }
        ///  The rank achieved in the contest
        public var ratingUpdateTimeSeconds: Int { __data["ratingUpdateTimeSeconds"] }
      }
    }
  }
}
