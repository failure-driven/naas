import React, { useState } from 'react';
import { ApolloProvider, Query } from 'react-apollo';
import { gql } from 'apollo-boost';
import {
  Button, Popover, PopoverHeader, PopoverBody,
} from 'reactstrap';

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
  const [popoverOpen, setPopoverOpen] = useState();
  const toggle = (event) => {
    const { id } = event.target.dataset;
    setPopoverOpen(popoverOpen === id ? undefined : id);
  };

  return (
    <ApolloProvider client={ApolloClient}>
      <Query query={GET_NOTIFICATIONS} pollInterval={1000}>
        {({ loading, error, data: responseData }) => {
          if (loading) return 'loading ...';
          if (error) return `Error! ${error.message}`;
          return (
            <ul className="list-group">
              {responseData.notifications.map(({
                id, data, createdAt, updatedAt,
              }) => (
                <li key={id} style={{ backgroundColor: data.color }} className="list-group-item">
                  <div data-testid="data">{data.msg}</div>
                  <small>{createdAt}</small>
                  <Button id={`Popover${id}`} type="button" className="float-right" data-id={id} onClick={toggle}>
                    <i className="fas fa-info" id={`Popover${id}`} />
                  </Button>
                  <Popover placement="left" isOpen={popoverOpen === id} target={`Popover${id}`} data-id={id} toggle={toggle}>
                    <PopoverHeader>Details</PopoverHeader>
                    <PopoverBody>
                      {JSON.stringify(data)}
                      <p>
                        created at:
                        {createdAt}
                      </p>
                      <p>
                        updated at:
                        {updatedAt}
                      </p>
                    </PopoverBody>
                  </Popover>
                </li>
              ))}
            </ul>
          );
        }}
      </Query>
    </ApolloProvider>
  );
}

Widget.propTypes = {
};

Widget.defaultProps = {
};
