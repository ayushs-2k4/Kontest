// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UpdateUserMutation: GraphQLMutation {
  public static let operationName: String = "UpdateUser"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    operationIdentifier: "fbf3821569285c737ab1b60ec95caec701820c9e2497af49c157e4192551c43d"
  )

  public var firstName: GraphQLNullable<String>
  public var lastName: GraphQLNullable<String>
  public var selectedCollegeState: GraphQLNullable<String>
  public var selectedCollege: GraphQLNullable<String>
  public var leetcodeUsername: GraphQLNullable<String>
  public var codechefUsername: GraphQLNullable<String>
  public var codeforcesUsername: GraphQLNullable<String>

  public init(
    firstName: GraphQLNullable<String>,
    lastName: GraphQLNullable<String>,
    selectedCollegeState: GraphQLNullable<String>,
    selectedCollege: GraphQLNullable<String>,
    leetcodeUsername: GraphQLNullable<String>,
    codechefUsername: GraphQLNullable<String>,
    codeforcesUsername: GraphQLNullable<String>
  ) {
    self.firstName = firstName
    self.lastName = lastName
    self.selectedCollegeState = selectedCollegeState
    self.selectedCollege = selectedCollege
    self.leetcodeUsername = leetcodeUsername
    self.codechefUsername = codechefUsername
    self.codeforcesUsername = codeforcesUsername
  }

  public var __variables: Variables? { [
    "firstName": firstName,
    "lastName": lastName,
    "selectedCollegeState": selectedCollegeState,
    "selectedCollege": selectedCollege,
    "leetcodeUsername": leetcodeUsername,
    "codechefUsername": codechefUsername,
    "codeforcesUsername": codeforcesUsername
  ] }

  public struct Data: KontestGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("updateUser", String?.self, arguments: ["updateUserInput": [
        "firstName": .variable("firstName"),
        "lastName": .variable("lastName"),
        "selectedCollegeState": .variable("selectedCollegeState"),
        "selectedCollege": .variable("selectedCollege"),
        "leetcodeUsername": .variable("leetcodeUsername"),
        "codechefUsername": .variable("codechefUsername"),
        "codeforcesUsername": .variable("codeforcesUsername")
      ]]),
    ] }

    public var updateUser: String? { __data["updateUser"] }
  }
}
