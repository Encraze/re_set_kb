-- Session (data-model.md): stored in the schema `accounts`.
CREATE TABLE accounts.session (
    session_hash varchar(64) NOT NULL,
    subject      text        NOT NULL,
    state_token  text        NOT NULL,
    created_at   timestamptz NOT NULL,
    last_seen_at timestamptz NOT NULL,
    CONSTRAINT session_pkey PRIMARY KEY (session_hash),
    CONSTRAINT session_session_hash_hex CHECK (session_hash ~ '^[0-9a-f]{64}$')
);
