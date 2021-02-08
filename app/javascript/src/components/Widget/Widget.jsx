import React from 'react';
import { ApolloProvider, Query } from 'react-apollo';
import { gql } from 'apollo-boost';

import ApolloClient from '../../api/ApolloClient';

const GET_NOTIFICATIONS = gql`
  query Notifications {
    notifications {
      id
      data
      createdAt
      updatedAt
    }
  }
`;

export default function Widget() {
  return (
    <ApolloProvider client={ApolloClient}>
      <Query query={GET_NOTIFICATIONS} pollInterval={1000}>
        {({ loading, error, data: responseData }) => {
          if (loading) return 'loading ...';
          if (error) return `Error! ${error.message}`;
          return responseData.notifications.map(({
            id, data, createdAt, updatedAt,
          }) => (
            <div key={id} style={{ backgroundColor: data.color }}>
              <div data-testid="data">{JSON.stringify(data)}</div>
              <div>{createdAt}</div>
              <div>{updatedAt}</div>
            </div>
          ));
        }}
      </Query>
    </ApolloProvider>
  );
}

Widget.propTypes = {
};

Widget.defaultProps = {
};
