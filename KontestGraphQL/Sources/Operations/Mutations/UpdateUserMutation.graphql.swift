// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UpdateUserMutation: GraphQLMutation {
  public static let operationName: String = "UpdateUser"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    operationIdentifier: "b6b709c4f22d551dee2d48a17c012b99c2dd584d919a4361982ac77e2dd27339"
  )

  public var codechefUsername: GraphQLNullable<String>
  public var firstName: GraphQLNullable<String>
  public var lastName: GraphQLNullable<String>
  public var leetcodeUsername: GraphQLNullable<String>
  public var codeforcesUsername: GraphQLNullable<String>
  public var selectedCollege: GraphQLNullable<String>
  public var selectedCollegeState: GraphQLNullable<String>

  public init(
    codechefUsername: GraphQLNullable<String>,
    firstName: GraphQLNullable<String>,
    lastName: GraphQLNullable<String>,
    leetcodeUsername: GraphQLNullable<String>,
    codeforcesUsername: GraphQLNullable<String>,
    selectedCollege: GraphQLNullable<String>,
    selectedCollegeState: GraphQLNullable<String>
  ) {
    self.codechefUsername = codechefUsername
    self.firstName = firstName
    self.lastName = lastName
    self.leetcodeUsername = leetcodeUsername
    self.codeforcesUsername = codeforcesUsername
    self.selectedCollege = selectedCollege
    self.selectedCollegeState = selectedCollegeState
  }

  public var __variables: Variables? { [
    "codechefUsername": codechefUsername,
    "firstName": firstName,
    "lastName": lastName,
    "leetcodeUsername": leetcodeUsername,
    "codeforcesUsername": codeforcesUsername,
    "selectedCollege": selectedCollege,
    "selectedCollegeState": selectedCollegeState
  ] }

  public struct Data: KontestGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("updateUser", String?.self, arguments: ["updateUserInput": [
        "codechefUsername": .variable("codechefUsername"),
        "firstName": .variable("firstName"),
        "lastName": .variable("lastName"),
        "leetcodeUsername": .variable("leetcodeUsername"),
        "codeforcesUsername": .variable("codeforcesUsername"),
        "selectedCollege": .variable("selectedCollege"),
        "selectedCollegeState": .variable("selectedCollegeState")
      ]]),
    ] }

    public var updateUser: String? { __data["updateUser"] }
  }
}
