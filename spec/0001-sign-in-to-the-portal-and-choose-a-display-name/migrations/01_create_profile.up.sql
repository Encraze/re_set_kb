-- Profile (data-model.md): the schema `accounts` and its first table.
CREATE SCHEMA accounts;

CREATE TABLE accounts.profile (
    id           uuid        NOT NULL DEFAULT gen_random_uuid(),
    subject      text        NOT NULL,
    member_id    text        NOT NULL,
    display_name text        NOT NULL DEFAULT '',
    version      integer     NOT NULL,
    created_at   timestamptz NOT NULL,
    changed_at   timestamptz NOT NULL,
    CONSTRAINT profile_pkey PRIMARY KEY (id),
    CONSTRAINT profile_subject_key UNIQUE (subject),
    CONSTRAINT profile_member_id_key UNIQUE (member_id)
);
