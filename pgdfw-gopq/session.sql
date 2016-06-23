create table public.login_session
(
    cookie          udig primary key,	--  is just a sha1

    create_time     timestamp,
    active_time     timestamp
);
