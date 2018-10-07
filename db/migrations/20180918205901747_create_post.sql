-- +micrate Up
CREATE TABLE posts (
  id BIGSERIAL PRIMARY KEY,
  parent INT,
  message TEXT,
  last_reply INT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS posts;
