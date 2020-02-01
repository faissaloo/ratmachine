-- +micrate Up
CREATE TABLE bans (
  id BIGSERIAL PRIMARY KEY,
  ip_address VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP

);

-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
DROP TABLE IF EXISTS bans;
-- SQL section 'Down' is executed when this migration is rolled back
