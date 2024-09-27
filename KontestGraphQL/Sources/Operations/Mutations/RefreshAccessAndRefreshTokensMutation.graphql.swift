// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RefreshAccessAndRefreshTokensMutation: GraphQLMutation {
  public static let operationName: String = "RefreshAccessAndRefreshTokens"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    operationIdentifier: "269acccc265186e8153d05dbbcc187c50163109243503cc1297db971f5afba1b"
  )

  public var refreshToken: String

  public init(refreshToken: String) {
    self.refreshToken = refreshToken
  }

  public var __variables: Variables? { ["refreshToken": refreshToken] }

  public struct Data: KontestGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("refreshAccessAndRefreshTokens", RefreshAccessAndRefreshTokens.self, arguments: ["refreshTokenInput": ["refreshToken": .variable("refreshToken")]]),
    ] }

    public var refreshAccessAndRefreshTokens: RefreshAccessAndRefreshTokens { __data["refreshAccessAndRefreshTokens"] }

    /// RefreshAccessAndRefreshTokens
    ///
    /// Parent Type: `LoginResponse`
    public struct RefreshAccessAndRefreshTokens: KontestGraphQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.LoginResponse }
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
