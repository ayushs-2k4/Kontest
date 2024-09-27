// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ChangePasswordMutation: GraphQLMutation {
  public static let operationName: String = "ChangePassword"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    operationIdentifier: "a89d24a7d0be0c8777d7b17267d026ee9991e454629ed5b40b25704e35a9a2d5"
  )

  public var newPassword: String

  public init(newPassword: String) {
    self.newPassword = newPassword
  }

  public var __variables: Variables? { ["newPassword": newPassword] }

  public struct Data: KontestGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("changePassword", String.self, arguments: ["newPassword": .variable("newPassword")]),
    ] }

    public var changePassword: String { __data["changePassword"] }
  }
}
