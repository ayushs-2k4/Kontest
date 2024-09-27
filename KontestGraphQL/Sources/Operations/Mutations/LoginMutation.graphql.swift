// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class LoginMutation: GraphQLMutation {
  public static let operationName: String = "Login"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    operationIdentifier: "e8cc36a2a6aefb4c34327e2fa15e7ea924733d8af08cc622a40e16994b977910"
  )

  public var email: String
  public var password: String
  public var deviceId: String

  public init(
    email: String,
    password: String,
    deviceId: String
  ) {
    self.email = email
    self.password = password
    self.deviceId = deviceId
  }

  public var __variables: Variables? { [
    "email": email,
    "password": password,
    "deviceId": deviceId
  ] }

  public struct Data: KontestGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { KontestGraphQL.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("login", Login.self, arguments: ["loginUserInput": [
        "email": .variable("email"),
        "password": .variable("password"),
        "deviceId": .variable("deviceId")
      ]]),
    ] }

    public var login: Login { __data["login"] }

    /// Login
    ///
    /// Parent Type: `LoginResponse`
    public struct Login: KontestGraphQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { KontestGraphQL.Objects.LoginResponse }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("jwtToken", String.self),
        .field("refreshToken", String.self),
        .field("userId", String.self),
      ] }

      public var jwtToken: String { __data["jwtToken"] }
      public var refreshToken: String { __data["refreshToken"] }
      public var userId: String { __data["userId"] }
    }
  }
}
