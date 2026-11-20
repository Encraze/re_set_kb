-- Rollback of 03_create_sign_in_attempt.up.sql: drops the live attempts with the table, which cannot be restored.
DROP TABLE accounts.sign_in_attempt;
