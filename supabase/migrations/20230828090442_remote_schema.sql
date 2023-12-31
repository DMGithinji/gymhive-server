create table "public"."gym" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone default now(),
    "name" text not null,
    "email" text,
    "phone" text,
    "logoUrl" text,
    "address" text,
    "estimateMemberCount" text,
    "creator" uuid not null default auth.uid()
);


create table "public"."user" (
    "id" uuid not null,
    "email" text,
    "firstname" text,
    "lastname" text,
    "role" text,
    "onboardStatus" integer not null default 0
);


create table "public"."user_gym" (
    "id" bigint generated by default as identity not null,
    "created_at" timestamp with time zone default now(),
    "gym_id" uuid not null,
    "user_id" uuid not null
);


alter table "public"."user_gym" enable row level security;

alter table "public"."Gym" enable row level security;

CREATE UNIQUE INDEX gyms_pkey ON public.gym USING btree (id);

CREATE UNIQUE INDEX user_gym_pkey ON public.user_gym USING btree (id);

CREATE UNIQUE INDEX users_pkey ON public."user" USING btree (id);

alter table "public"."gym" add constraint "gyms_pkey" PRIMARY KEY using index "gyms_pkey";

alter table "public"."user" add constraint "users_pkey" PRIMARY KEY using index "users_pkey";

alter table "public"."user_gym" add constraint "user_gym_pkey" PRIMARY KEY using index "user_gym_pkey";

alter table "public"."gym" add constraint "gym_creator_fkey" FOREIGN KEY (creator) REFERENCES "user"(id) not valid;

alter table "public"."gym" validate constraint "gym_creator_fkey";

alter table "public"."user_gym" add constraint "user_gym_user_id_fkey" FOREIGN KEY (user_id) REFERENCES "user"(id) not valid;

alter table "public"."user_gym" validate constraint "user_gym_user_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_boards_for_authenticated_user()
 RETURNS SETOF bigint
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
    select board_id
    from user_boards
    where user_id = auth.uid()
$function$
;

CREATE OR REPLACE FUNCTION public.handle_gym_added()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
  insert into public.user_gym (gym_id, user_id)
  values (new.id, auth.uid());
  return new;
end;
$function$
;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
  insert into public.user (id, email, firstname, lastname, role)
  values (new.id, new.email, new.raw_user_meta_data->>'firstname', new.raw_user_meta_data->>'lastname', new.raw_user_meta_data->>'role');
  return new;
end;
$function$
;

create policy "Enable read access for all users"
on "public"."Gym"
as permissive
for select
to public
using (true);


CREATE TRIGGER on_gym_created AFTER INSERT ON public.gym FOR EACH ROW EXECUTE FUNCTION handle_gym_added();


