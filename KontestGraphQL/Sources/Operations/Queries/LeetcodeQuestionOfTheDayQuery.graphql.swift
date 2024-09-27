// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class LeetcodeQuestionOfTheDayQuery: GraphQLQuery {
  public static let operationName: String = "LeetcodeQuestionOfTheDayQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    operationIdentifier: "3f0337b2f0b6a5683427d79baf159175af4cc4017d3111495146daec96b9491a"
  )

  public init() {}

  public struct Data: KontestGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { KontestGraphQL.Objects.Query }
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

      public static var __parentType: ApolloAPI.ParentType { KontestGraphQL.Objects.LeetcodeQuery }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("activeDailyCodingChallengeQuestion", ActiveDailyCodingChallengeQuestion?.self),
      ] }

      public var activeDailyCodingChallengeQuestion: ActiveDailyCodingChallengeQuestion? { __data["activeDailyCodingChallengeQuestion"] }

      /// LeetcodeQuery.ActiveDailyCodingChallengeQuestion
      ///
      /// Parent Type: `DailyCodingChallengeQuestion`
      public struct ActiveDailyCodingChallengeQuestion: KontestGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { KontestGraphQL.Objects.DailyCodingChallengeQuestion }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("date", String?.self),
          .field("link", String?.self),
          .field("userStatus", String?.self),
          .field("question", Question?.self),
        ] }

        public var date: String? { __data["date"] }
        public var link: String? { __data["link"] }
        public var userStatus: String? { __data["userStatus"] }
        public var question: Question? { __data["question"] }

        /// LeetcodeQuery.ActiveDailyCodingChallengeQuestion.Question
        ///
        /// Parent Type: `Question`
        public struct Question: KontestGraphQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { KontestGraphQL.Objects.Question }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("acRate", Double?.self),
            .field("difficulty", String?.self),
            .field("freqBar", String?.self),
            .field("hasSolution", Bool?.self),
            .field("hasVideoSolution", Bool?.self),
            .field("isFavor", Bool?.self),
            .field("isPaidOnly", Bool?.self),
            .field("questionFrontendId", String?.self),
            .field("status", String?.self),
            .field("title", String?.self),
            .field("titleSlug", String?.self),
            .field("topicTags", [TopicTag?]?.self),
          ] }

          public var acRate: Double? { __data["acRate"] }
          public var difficulty: String? { __data["difficulty"] }
          public var freqBar: String? { __data["freqBar"] }
          public var hasSolution: Bool? { __data["hasSolution"] }
          public var hasVideoSolution: Bool? { __data["hasVideoSolution"] }
          public var isFavor: Bool? { __data["isFavor"] }
          public var isPaidOnly: Bool? { __data["isPaidOnly"] }
          public var questionFrontendId: String? { __data["questionFrontendId"] }
          public var status: String? { __data["status"] }
          public var title: String? { __data["title"] }
          public var titleSlug: String? { __data["titleSlug"] }
          public var topicTags: [TopicTag?]? { __data["topicTags"] }

          /// LeetcodeQuery.ActiveDailyCodingChallengeQuestion.Question.TopicTag
          ///
          /// Parent Type: `TopicTag`
          public struct TopicTag: KontestGraphQL.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { KontestGraphQL.Objects.TopicTag }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", String?.self),
              .field("name", String?.self),
              .field("slug", String?.self),
            ] }

            public var id: String? { __data["id"] }
            public var name: String? { __data["name"] }
            public var slug: String? { __data["slug"] }
          }
        }
      }
    }
  }
}
