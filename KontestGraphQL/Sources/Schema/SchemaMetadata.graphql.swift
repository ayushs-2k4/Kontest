// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == KontestGraphQL.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == KontestGraphQL.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == KontestGraphQL.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == KontestGraphQL.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "Query": return KontestGraphQL.Objects.Query
    case "KontestQuery": return KontestGraphQL.Objects.KontestQuery
    case "Kontests": return KontestGraphQL.Objects.Kontests
    case "Kontest": return KontestGraphQL.Objects.Kontest
    case "DailyCodingChallengeQuestion": return KontestGraphQL.Objects.DailyCodingChallengeQuestion
    case "Question": return KontestGraphQL.Objects.Question
    case "TopicTag": return KontestGraphQL.Objects.TopicTag
    case "UserContestRanking": return KontestGraphQL.Objects.UserContestRanking
    case "Badge": return KontestGraphQL.Objects.Badge
    case "UserContestRankingHistory": return KontestGraphQL.Objects.UserContestRankingHistory
    case "Contest": return KontestGraphQL.Objects.Contest
    case "MatchedUser": return KontestGraphQL.Objects.MatchedUser
    case "LanguageProblemCount": return KontestGraphQL.Objects.LanguageProblemCount
    case "ContestBadge": return KontestGraphQL.Objects.ContestBadge
    case "UserProfile": return KontestGraphQL.Objects.UserProfile
    case "ProblemSolvedBeatsStats": return KontestGraphQL.Objects.ProblemSolvedBeatsStats
    case "SubmitStatsGlobal": return KontestGraphQL.Objects.SubmitStatsGlobal
    case "ACSubmissionNum": return KontestGraphQL.Objects.ACSubmissionNum
    case "LeetcodeQuery": return KontestGraphQL.Objects.LeetcodeQuery
    case "CodeChefQuery": return KontestGraphQL.Objects.CodeChefQuery
    case "CodeChefUser": return KontestGraphQL.Objects.CodeChefUser
    case "CodeChefContest": return KontestGraphQL.Objects.CodeChefContest
    case "CodeForcesQuery": return KontestGraphQL.Objects.CodeForcesQuery
    case "CodeForcesUser": return KontestGraphQL.Objects.CodeForcesUser
    case "CodeForcesUserRating": return KontestGraphQL.Objects.CodeForcesUserRating
    case "Mutation": return KontestGraphQL.Objects.Mutation
    case "LoginResponse": return KontestGraphQL.Objects.LoginResponse
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
