import React from 'react';

const Shows = ({shows}) => (
  <ol>
    {shows.map(show => (
      <li key={show.name}>{show.name}</li>
    ))}
  </ol>
)

export default Shows
