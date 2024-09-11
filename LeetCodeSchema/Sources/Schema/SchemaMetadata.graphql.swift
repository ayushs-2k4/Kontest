// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public typealias ID = String

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == LeetCodeSchema.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == LeetCodeSchema.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == LeetCodeSchema.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == LeetCodeSchema.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> Object? {
    switch typename {
    case "Query": return LeetCodeSchema.Objects.Query
    case "DailyCodingChallengeQuestion": return LeetCodeSchema.Objects.DailyCodingChallengeQuestion
    case "Question": return LeetCodeSchema.Objects.Question
    case "TopicTag": return LeetCodeSchema.Objects.TopicTag
    case "UserContestRanking": return LeetCodeSchema.Objects.UserContestRanking
    case "Badge": return LeetCodeSchema.Objects.Badge
    case "UserContestRankingHistory": return LeetCodeSchema.Objects.UserContestRankingHistory
    case "Contest": return LeetCodeSchema.Objects.Contest
    case "MatchedUser": return LeetCodeSchema.Objects.MatchedUser
    case "LanguageProblemCount": return LeetCodeSchema.Objects.LanguageProblemCount
    case "ContestBadge": return LeetCodeSchema.Objects.ContestBadge
    case "UserProfile": return LeetCodeSchema.Objects.UserProfile
    case "ProblemSolvedBeatsStats": return LeetCodeSchema.Objects.ProblemSolvedBeatsStats
    case "SubmitStatsGlobal": return LeetCodeSchema.Objects.SubmitStatsGlobal
    case "ACSubmissionNum": return LeetCodeSchema.Objects.ACSubmissionNum
    case "LeetcodeQuery": return LeetCodeSchema.Objects.LeetcodeQuery
    case "KontestQuery": return LeetCodeSchema.Objects.KontestQuery
    case "KontestError": return LeetCodeSchema.Objects.KontestError
    case "Kontests": return LeetCodeSchema.Objects.Kontests
    case "Kontest": return LeetCodeSchema.Objects.Kontest
    case "CodeChefUser": return LeetCodeSchema.Objects.CodeChefUser
    case "HeatMapEntry": return LeetCodeSchema.Objects.HeatMapEntry
    case "CodeForcesUser": return LeetCodeSchema.Objects.CodeForcesUser
    case "CodeForcesUserInfo": return LeetCodeSchema.Objects.CodeForcesUserInfo
    case "CodeForcesUserRating": return LeetCodeSchema.Objects.CodeForcesUserRating
    case "CodeForcesUserBasicInfo": return LeetCodeSchema.Objects.CodeForcesUserBasicInfo
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
