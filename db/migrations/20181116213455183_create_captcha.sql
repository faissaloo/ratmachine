-- +micrate Up
CREATE TABLE captchas (
  id BIGSERIAL PRIMARY KEY,
  value TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS captchas;
