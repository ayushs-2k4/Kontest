// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class QuestionOfTodayQuery: GraphQLQuery {
  public static let operationName: String = "questionOfToday"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    operationIdentifier: "1ea44845d7b6ba3ab4b34012ba7a0b22c19df69ad40b4681f8e1da98d147f4c4"
  )

  public init() {}

  public struct Data: KontestGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("activeDailyCodingChallengeQuestion", ActiveDailyCodingChallengeQuestion?.self),
    ] }

    public var activeDailyCodingChallengeQuestion: ActiveDailyCodingChallengeQuestion? { __data["activeDailyCodingChallengeQuestion"] }

    /// ActiveDailyCodingChallengeQuestion
    ///
    /// Parent Type: `DailyCodingChallengeQuestion`
    public struct ActiveDailyCodingChallengeQuestion: KontestGraphQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.DailyCodingChallengeQuestion }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("date", String?.self),
        .field("userStatus", String?.self),
        .field("link", String?.self),
        .field("question", Question?.self),
      ] }

      public var date: String? { __data["date"] }
      public var userStatus: String? { __data["userStatus"] }
      public var link: String? { __data["link"] }
      public var question: Question? { __data["question"] }

      /// ActiveDailyCodingChallengeQuestion.Question
      ///
      /// Parent Type: `Question`
      public struct Question: KontestGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.Question }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("acRate", Double?.self),
          .field("difficulty", String?.self),
          .field("freqBar", String?.self),
          .field("questionFrontendId", String?.self),
          .field("isFavor", Bool?.self),
          .field("isPaidOnly", Bool?.self),
          .field("status", String?.self),
          .field("title", String?.self),
          .field("titleSlug", String?.self),
          .field("hasVideoSolution", Bool?.self),
          .field("hasSolution", Bool?.self),
          .field("topicTags", [TopicTag?]?.self),
        ] }

        public var acRate: Double? { __data["acRate"] }
        public var difficulty: String? { __data["difficulty"] }
        public var freqBar: String? { __data["freqBar"] }
        public var questionFrontendId: String? { __data["questionFrontendId"] }
        public var isFavor: Bool? { __data["isFavor"] }
        public var isPaidOnly: Bool? { __data["isPaidOnly"] }
        public var status: String? { __data["status"] }
        public var title: String? { __data["title"] }
        public var titleSlug: String? { __data["titleSlug"] }
        public var hasVideoSolution: Bool? { __data["hasVideoSolution"] }
        public var hasSolution: Bool? { __data["hasSolution"] }
        public var topicTags: [TopicTag?]? { __data["topicTags"] }

        /// ActiveDailyCodingChallengeQuestion.Question.TopicTag
        ///
        /// Parent Type: `TopicTag`
        public struct TopicTag: KontestGraphQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.TopicTag }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("name", String?.self),
            .field("id", String?.self),
            .field("slug", String?.self),
          ] }

          public var name: String? { __data["name"] }
          public var id: String? { __data["id"] }
          public var slug: String? { __data["slug"] }
        }
      }
    }
  }
}
