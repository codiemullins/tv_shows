import { gql } from 'react-apollo';

export default gql`
  query ($where: [Where], $offset: Int, $limit: Int) {
    shows(where: $where, offset: $offset, limit: $limit) {
      id
      name
      network {
        name
        country {
          name
        }
      }
      created_at
      show_type
      thetvdb_id
      status
    }
  }
`
