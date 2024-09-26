// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RegisterMutation: GraphQLMutation {
  public static let operationName: String = "Register"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    operationIdentifier: "b26424187f3f6f01cc1105b146406b40d17d9bf3542a8414b950306262e8fc6f",
    definition: .init(
      #"mutation Register($email: String!, $password: String!) { register(registerUserInput: {email: $email, password: $password}) }"#
    ))

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

    public static var __parentType: ApolloAPI.ParentType { KontestGraphQL.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("register", String.self, arguments: ["registerUserInput": [
        "email": .variable("email"),
        "password": .variable("password")
      ]]),
    ] }

    public var register: String { __data["register"] }
  }
}
