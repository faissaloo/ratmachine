-- +micrate Up
CREATE TABLE filters (
  id BIGSERIAL PRIMARY KEY,
  regex VARCHAR,
  severity INT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS filters;
