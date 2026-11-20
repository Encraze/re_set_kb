-- Rollback of 01_create_profile.up.sql: drops the profile rows with the table, which cannot be restored.
DROP TABLE accounts.profile;
DROP SCHEMA accounts;
