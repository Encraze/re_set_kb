-- Rollback of 02_create_session.up.sql: drops the sessions with the table, which cannot be restored.
DROP TABLE accounts.session;
