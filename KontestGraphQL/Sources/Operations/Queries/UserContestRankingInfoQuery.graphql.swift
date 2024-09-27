// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UserContestRankingInfoQuery: GraphQLQuery {
  public static let operationName: String = "userContestRankingInfo"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    operationIdentifier: "2fe35cd0c7a15a71648811916b5cedf6f9835c94adf432a813e510a31750a5d6"
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
      .field("userContestRanking", UserContestRanking?.self, arguments: ["username": .variable("username")]),
      .field("userContestRankingHistory", [UserContestRankingHistory?]?.self, arguments: ["username": .variable("username")]),
    ] }

    public var userContestRanking: UserContestRanking? { __data["userContestRanking"] }
    public var userContestRankingHistory: [UserContestRankingHistory?]? { __data["userContestRankingHistory"] }

    /// UserContestRanking
    ///
    /// Parent Type: `UserContestRanking`
    public struct UserContestRanking: KontestGraphQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { KontestGraphQL.Objects.UserContestRanking }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("attendedContestsCount", Int?.self),
        .field("rating", Double?.self),
        .field("globalRanking", Int?.self),
        .field("totalParticipants", Int?.self),
        .field("topPercentage", Double?.self),
        .field("badge", Badge?.self),
      ] }

      public var attendedContestsCount: Int? { __data["attendedContestsCount"] }
      public var rating: Double? { __data["rating"] }
      public var globalRanking: Int? { __data["globalRanking"] }
      public var totalParticipants: Int? { __data["totalParticipants"] }
      public var topPercentage: Double? { __data["topPercentage"] }
      public var badge: Badge? { __data["badge"] }

      /// UserContestRanking.Badge
      ///
      /// Parent Type: `Badge`
      public struct Badge: KontestGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { KontestGraphQL.Objects.Badge }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String?.self),
        ] }

        public var name: String? { __data["name"] }
      }
    }

    /// UserContestRankingHistory
    ///
    /// Parent Type: `UserContestRankingHistory`
    public struct UserContestRankingHistory: KontestGraphQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { KontestGraphQL.Objects.UserContestRankingHistory }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("attended", Bool?.self),
        .field("trendDirection", String?.self),
        .field("problemsSolved", Int?.self),
        .field("totalProblems", Int?.self),
        .field("finishTimeInSeconds", Int?.self),
        .field("rating", Double?.self),
        .field("ranking", Int?.self),
        .field("contest", Contest?.self),
      ] }

      public var attended: Bool? { __data["attended"] }
      public var trendDirection: String? { __data["trendDirection"] }
      public var problemsSolved: Int? { __data["problemsSolved"] }
      public var totalProblems: Int? { __data["totalProblems"] }
      public var finishTimeInSeconds: Int? { __data["finishTimeInSeconds"] }
      public var rating: Double? { __data["rating"] }
      public var ranking: Int? { __data["ranking"] }
      public var contest: Contest? { __data["contest"] }

      /// UserContestRankingHistory.Contest
      ///
      /// Parent Type: `Contest`
      public struct Contest: KontestGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { KontestGraphQL.Objects.Contest }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("title", String?.self),
          .field("startTime", String?.self),
        ] }

        public var title: String? { __data["title"] }
        public var startTime: String? { __data["startTime"] }
      }
    }
  }
}
