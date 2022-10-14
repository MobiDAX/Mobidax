import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gql/language.dart';

class GraphQLClientAPI {
  static String gqlServerHost = 'trade.mobidax.io';

  static client() => GraphQLClient(
        cache: InMemoryCache(),
        link: HttpLink(
          uri: 'https://$gqlServerHost/graphql',
        ),
      );

  static GraphQLClient wsclient = GraphQLClient(
    cache: InMemoryCache(),
    link: WebSocketLink(
      url: 'wss://$gqlServerHost/graphql',
      config: SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: Duration(seconds: 20000),
      ),
    ),
  );

  static Stream<FetchResult> subStream(String operationName, String query,
          [Map<String, dynamic> variables]) =>
      GraphQLClientAPI.wsclient.subscribe(Operation(
        operationName: operationName,
        documentNode: parseString(query),
        variables: variables,
      ));

  static Future<QueryResult> query(QueryOptions options) async {
    return await client().query(options);
  }
}
