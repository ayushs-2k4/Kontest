// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ChangePasswordMutation: GraphQLMutation {
  public static let operationName: String = "ChangePassword"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation ChangePassword($newPassword: String!) { changePassword(newPassword: $newPassword) }"#
    ))

  public var newPassword: String

  public init(newPassword: String) {
    self.newPassword = newPassword
  }

  public var __variables: Variables? { ["newPassword": newPassword] }

  public struct Data: KontestGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { KontestGraphQL.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("changePassword", String.self, arguments: ["newPassword": .variable("newPassword")]),
    ] }

    public var changePassword: String { __data["changePassword"] }
  }
}
