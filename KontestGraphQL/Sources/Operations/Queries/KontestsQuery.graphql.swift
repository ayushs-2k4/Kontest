// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class KontestsQuery: GraphQLQuery {
  public static let operationName: String = "Kontests"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    operationIdentifier: "dae7d9b90b7c6b5ee8d5ff3497ff530bffdaa7fe8cbb12299c48a7aa771cc339"
  )

  public var page: Int
  public var perPage: Int
  public var sites: GraphQLNullable<[String]>

  public init(
    page: Int,
    perPage: Int,
    sites: GraphQLNullable<[String]>
  ) {
    self.page = page
    self.perPage = perPage
    self.sites = sites
  }

  public var __variables: Variables? { [
    "page": page,
    "perPage": perPage,
    "sites": sites
  ] }

  public struct Data: KontestGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("kontestQuery", KontestQuery?.self),
    ] }

    public var kontestQuery: KontestQuery? { __data["kontestQuery"] }

    /// KontestQuery
    ///
    /// Parent Type: `KontestQuery`
    public struct KontestQuery: KontestGraphQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.KontestQuery }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("kontests", Kontests?.self, arguments: [
          "page": .variable("page"),
          "perPage": .variable("perPage"),
          "sites": .variable("sites")
        ]),
      ] }

      public var kontests: Kontests? { __data["kontests"] }

      /// KontestQuery.Kontests
      ///
      /// Parent Type: `Kontests`
      public struct Kontests: KontestGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.Kontests }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("kontests", [Kontest]?.self),
        ] }

        public var kontests: [Kontest]? { __data["kontests"] }

        /// KontestQuery.Kontests.Kontest
        ///
        /// Parent Type: `Kontest`
        public struct Kontest: KontestGraphQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { KontestGraphQL.Objects.Kontest }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("endTime", String.self),
            .field("location", String.self),
            .field("name", String.self),
            .field("startTime", String.self),
            .field("url", String.self),
          ] }

          public var endTime: String { __data["endTime"] }
          public var location: String { __data["location"] }
          public var name: String { __data["name"] }
          public var startTime: String { __data["startTime"] }
          public var url: String { __data["url"] }
        }
      }
    }
  }
}
