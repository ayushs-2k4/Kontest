// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CodeChefUserKontestHistoryQuery: GraphQLQuery {
  public static let operationName: String = "CodeChefUserKontestHistoryQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query CodeChefUserKontestHistoryQuery($username: String!) { codeChefQuery { __typename userKontestHistory(username: $username) { __typename code color day endDate month name penalisedIn rank rating reason year } } }"#
    ))

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
        .field("userKontestHistory", [UserKontestHistory?]?.self, arguments: ["username": .variable("username")]),
      ] }

      ///  Fetch the contest history for a CodeChef user
      public var userKontestHistory: [UserKontestHistory?]? { __data["userKontestHistory"] }

      /// CodeChefQuery.UserKontestHistory
      ///
      /// Parent Type: `CodeChefContest`
      public struct UserKontestHistory: KontestGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { KontestGraphQL.Objects.CodeChefContest }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("code", String.self),
          .field("color", String.self),
          .field("day", Int.self),
          .field("endDate", String.self),
          .field("month", Int.self),
          .field("name", String.self),
          .field("penalisedIn", Bool.self),
          .field("rank", Int.self),
          .field("rating", Int.self),
          .field("reason", String.self),
          .field("year", Int.self),
        ] }

        public var code: String { __data["code"] }
        ///  The end date of the contest
        public var color: String { __data["color"] }
        ///  The month the contest took place
        public var day: Int { __data["day"] }
        ///  The name of the contest
        public var endDate: String { __data["endDate"] }
        ///  The year the contest took place
        public var month: Int { __data["month"] }
        ///  The rank achieved in the contest
        public var name: String { __data["name"] }
        ///  The reason for the rating change (e.g., penalties)
        public var penalisedIn: Bool { __data["penalisedIn"] }
        ///  The rating achieved in the contest
        public var rank: Int { __data["rank"] }
        ///  Indicates if the user was penalized in the contest
        public var rating: Int { __data["rating"] }
        ///  The day the contest took place
        public var reason: String { __data["reason"] }
        ///  The unique code for the contest
        public var year: Int { __data["year"] }
      }
    }
  }
}
