-- SignInAttempt (data-model.md): stored in the schema `accounts`.
CREATE TABLE accounts.sign_in_attempt (
    state         text        NOT NULL,
    nonce         text        NOT NULL,
    pkce_verifier text        NOT NULL,
    return_path   text        NOT NULL,
    created_at    timestamptz NOT NULL,
    CONSTRAINT sign_in_attempt_pkey PRIMARY KEY (state)
);
