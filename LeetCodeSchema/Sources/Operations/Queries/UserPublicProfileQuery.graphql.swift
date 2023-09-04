// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UserPublicProfileQuery: GraphQLQuery {
  public static let operationName: String = "userPublicProfile"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query userPublicProfile($username: String!) { matchedUser(username: $username) { __typename languageProblemCount { __typename languageName problemsSolved } contestBadge { __typename name expired hoverText icon } username githubUrl twitterUrl linkedinUrl profile { __typename ranking userAvatar realName aboutMe school websites countryName company jobTitle skillTags postViewCount postViewCountDiff reputation reputationDiff solutionCount solutionCountDiff categoryDiscussCount categoryDiscussCountDiff } } }"#
    ))

  public var username: String

  public init(username: String) {
    self.username = username
  }

  public var __variables: Variables? { ["username": username] }

  public struct Data: LeetCodeSchema.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { LeetCodeSchema.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("matchedUser", MatchedUser?.self, arguments: ["username": .variable("username")]),
    ] }

    public var matchedUser: MatchedUser? { __data["matchedUser"] }

    /// MatchedUser
    ///
    /// Parent Type: `MatchedUser`
    public struct MatchedUser: LeetCodeSchema.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { LeetCodeSchema.Objects.MatchedUser }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("languageProblemCount", [LanguageProblemCount?]?.self),
        .field("contestBadge", ContestBadge?.self),
        .field("username", String?.self),
        .field("githubUrl", String?.self),
        .field("twitterUrl", String?.self),
        .field("linkedinUrl", String?.self),
        .field("profile", Profile?.self),
      ] }

      public var languageProblemCount: [LanguageProblemCount?]? { __data["languageProblemCount"] }
      public var contestBadge: ContestBadge? { __data["contestBadge"] }
      public var username: String? { __data["username"] }
      public var githubUrl: String? { __data["githubUrl"] }
      public var twitterUrl: String? { __data["twitterUrl"] }
      public var linkedinUrl: String? { __data["linkedinUrl"] }
      public var profile: Profile? { __data["profile"] }

      /// MatchedUser.LanguageProblemCount
      ///
      /// Parent Type: `LanguageProblemCount`
      public struct LanguageProblemCount: LeetCodeSchema.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { LeetCodeSchema.Objects.LanguageProblemCount }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("languageName", String?.self),
          .field("problemsSolved", Int?.self),
        ] }

        public var languageName: String? { __data["languageName"] }
        public var problemsSolved: Int? { __data["problemsSolved"] }
      }

      /// MatchedUser.ContestBadge
      ///
      /// Parent Type: `ContestBadge`
      public struct ContestBadge: LeetCodeSchema.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { LeetCodeSchema.Objects.ContestBadge }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("name", String?.self),
          .field("expired", Bool?.self),
          .field("hoverText", String?.self),
          .field("icon", String?.self),
        ] }

        public var name: String? { __data["name"] }
        public var expired: Bool? { __data["expired"] }
        public var hoverText: String? { __data["hoverText"] }
        public var icon: String? { __data["icon"] }
      }

      /// MatchedUser.Profile
      ///
      /// Parent Type: `UserProfile`
      public struct Profile: LeetCodeSchema.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { LeetCodeSchema.Objects.UserProfile }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("ranking", Int?.self),
          .field("userAvatar", String?.self),
          .field("realName", String?.self),
          .field("aboutMe", String?.self),
          .field("school", String?.self),
          .field("websites", [String?]?.self),
          .field("countryName", String?.self),
          .field("company", String?.self),
          .field("jobTitle", String?.self),
          .field("skillTags", [String?]?.self),
          .field("postViewCount", Int?.self),
          .field("postViewCountDiff", Int?.self),
          .field("reputation", Int?.self),
          .field("reputationDiff", Int?.self),
          .field("solutionCount", Int?.self),
          .field("solutionCountDiff", Int?.self),
          .field("categoryDiscussCount", Int?.self),
          .field("categoryDiscussCountDiff", Int?.self),
        ] }

        public var ranking: Int? { __data["ranking"] }
        public var userAvatar: String? { __data["userAvatar"] }
        public var realName: String? { __data["realName"] }
        public var aboutMe: String? { __data["aboutMe"] }
        public var school: String? { __data["school"] }
        public var websites: [String?]? { __data["websites"] }
        public var countryName: String? { __data["countryName"] }
        public var company: String? { __data["company"] }
        public var jobTitle: String? { __data["jobTitle"] }
        public var skillTags: [String?]? { __data["skillTags"] }
        public var postViewCount: Int? { __data["postViewCount"] }
        public var postViewCountDiff: Int? { __data["postViewCountDiff"] }
        public var reputation: Int? { __data["reputation"] }
        public var reputationDiff: Int? { __data["reputationDiff"] }
        public var solutionCount: Int? { __data["solutionCount"] }
        public var solutionCountDiff: Int? { __data["solutionCountDiff"] }
        public var categoryDiscussCount: Int? { __data["categoryDiscussCount"] }
        public var categoryDiscussCountDiff: Int? { __data["categoryDiscussCountDiff"] }
      }
    }
  }
}
