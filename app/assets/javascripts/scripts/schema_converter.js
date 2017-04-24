import fs from 'fs';
import {
  buildClientSchema,
  printSchema,
} from 'graphql/utilities';

console.log(__dirname);

const schema = buildClientSchema(require('../../../graphql/schema.json').data);

fs.writeFileSync(
  `./app/graphql/schema.graphql`,
  printSchema(schema),
);
