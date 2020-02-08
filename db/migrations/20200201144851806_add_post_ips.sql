-- +micrate Up
ALTER TABLE posts ADD ip_address VARCHAR;
-- SQL in section 'Up' is executed when this migration is applied

-- +micrate Down
ALTER TABLE posts DROP COLUMN ip_address;
-- SQL section 'Down' is executed when this migration is rolled back
