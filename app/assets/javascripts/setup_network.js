import RelayClassic from 'react-relay/classic';

const csrfToken = document.head.querySelector('meta[name=csrf-token]').getAttribute('content');

RelayClassic.injectNetworkLayer(
  new RelayClassic.DefaultNetworkLayer('/graphql', {
    credentials: 'same-origin',
    headers: {
      'X-CSRF-Token': csrfToken,
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    }
  })
)
