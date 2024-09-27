// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RegisterMutation: GraphQLMutation {
  public static let operationName: String = "Register"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    operationIdentifier: "595434ef2e52cea664427436985a1a6882f52e0d7674845ac8facf243366c4b1"
  )

  public var email: String
  public var password: String

  public init(
    email: String,
    password: String
  ) {
    self.email = email
    self.password = password
  }

  public var __variables: Variables? { [
    "email": email,
    "password": password
  ] }

  public struct Data: KontestGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("register", String.self, arguments: ["registerUserInput": [
        "email": .variable("email"),
        "password": .variable("password")
      ]]),
    ] }

    public var register: String { __data["register"] }
  }
}
