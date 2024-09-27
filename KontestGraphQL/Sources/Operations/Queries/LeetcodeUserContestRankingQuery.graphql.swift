// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class LeetcodeUserContestRankingQuery: GraphQLQuery {
  public static let operationName: String = "LeetcodeUserContestRankingQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    operationIdentifier: "088f615729e9a2e250892282d780f783c125e0b460a5d6cbc03344568b808ebe"
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
      .field("leetcodeQuery", LeetcodeQuery?.self),
    ] }

    public var leetcodeQuery: LeetcodeQuery? { __data["leetcodeQuery"] }

    /// LeetcodeQuery
    ///
    /// Parent Type: `LeetcodeQuery`
    public struct LeetcodeQuery: KontestGraphQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.LeetcodeQuery }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("userContestRanking", UserContestRanking?.self, arguments: ["username": .variable("username")]),
      ] }

      public var userContestRanking: UserContestRanking? { __data["userContestRanking"] }

      /// LeetcodeQuery.UserContestRanking
      ///
      /// Parent Type: `UserContestRanking`
      public struct UserContestRanking: KontestGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.UserContestRanking }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("attendedContestsCount", Int?.self),
          .field("globalRanking", Int?.self),
          .field("rating", Double?.self),
          .field("topPercentage", Double?.self),
          .field("totalParticipants", Int?.self),
          .field("badge", Badge?.self),
        ] }

        public var attendedContestsCount: Int? { __data["attendedContestsCount"] }
        public var globalRanking: Int? { __data["globalRanking"] }
        public var rating: Double? { __data["rating"] }
        public var topPercentage: Double? { __data["topPercentage"] }
        public var totalParticipants: Int? { __data["totalParticipants"] }
        public var badge: Badge? { __data["badge"] }

        /// LeetcodeQuery.UserContestRanking.Badge
        ///
        /// Parent Type: `Badge`
        public struct Badge: KontestGraphQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.Badge }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("name", String?.self),
          ] }

          public var name: String? { __data["name"] }
        }
      }
    }
  }
}
