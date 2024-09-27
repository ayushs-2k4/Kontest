// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UserQuery: GraphQLQuery {
  public static let operationName: String = "User"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    operationIdentifier: "f3974fde4ddf505be1fbe6018f31b80a57b4cd99d79390498efec7b93fcd6a80"
  )

  public init() {}

  public struct Data: KontestGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("user", User?.self),
    ] }

    public var user: User? { __data["user"] }

    /// User
    ///
    /// Parent Type: `User`
    public struct User: KontestGraphQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("codechefUsername", String?.self),
        .field("codeforcesUsername", String?.self),
        .field("firstName", String.self),
        .field("lastName", String.self),
        .field("email", String?.self),
        .field("leetcodeUsername", String?.self),
        .field("selectedCollege", String?.self),
        .field("selectedCollegeState", String?.self),
      ] }

      public var codechefUsername: String? { __data["codechefUsername"] }
      public var codeforcesUsername: String? { __data["codeforcesUsername"] }
      public var firstName: String { __data["firstName"] }
      public var lastName: String { __data["lastName"] }
      public var email: String? { __data["email"] }
      public var leetcodeUsername: String? { __data["leetcodeUsername"] }
      public var selectedCollege: String? { __data["selectedCollege"] }
      public var selectedCollegeState: String? { __data["selectedCollegeState"] }
    }
  }
}
