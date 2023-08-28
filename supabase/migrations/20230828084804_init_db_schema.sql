create type "public"."UserRole" as enum ('GYM_OWNER', 'STAFF', 'MEMBER');

create table "public"."Booking" (
    "id" uuid not null default gen_random_uuid(),
    "gymId" uuid not null,
    "sessionId" uuid not null,
    "memberId" uuid not null,
    "createdAt" timestamp(3) without time zone not null default now()
);


create table "public"."Gym" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "phone" text not null,
    "email" text not null,
    "address" text not null,
    "logo" text,
    "ownerId" uuid not null,
    "createdAt" timestamp(3) without time zone not null default now()
);


create table "public"."GymMembership" (
    "userId" uuid not null,
    "gymId" uuid not null
);


create table "public"."Invoice" (
    "id" uuid not null default gen_random_uuid(),
    "gymId" uuid not null,
    "memberId" uuid not null,
    "total" integer not null,
    "createdAt" timestamp(3) without time zone not null default now()
);


create table "public"."MembershipPlan" (
    "id" uuid not null default gen_random_uuid(),
    "gymId" uuid not null,
    "name" text not null,
    "price" integer not null,
    "periodInSeconds" integer not null,
    "createdAt" timestamp(3) without time zone not null default now()
);


create table "public"."Payment" (
    "id" uuid not null default gen_random_uuid(),
    "gymId" uuid not null,
    "memberId" uuid not null,
    "amount" integer not null,
    "createdAt" timestamp(3) without time zone not null default now()
);


create table "public"."Session" (
    "id" uuid not null default gen_random_uuid(),
    "gymId" uuid not null,
    "name" text not null,
    "startTime" timestamp(3) without time zone not null,
    "period" integer not null,
    "type" text not null,
    "createdAt" timestamp(3) without time zone not null default now()
);


create table "public"."User" (
    "id" uuid not null default gen_random_uuid(),
    "firstName" text not null,
    "lastName" text not null,
    "phone" text not null,
    "email" text not null,
    "role" "UserRole" not null,
    "createdAt" timestamp(3) without time zone not null default now()
);


create table "public"."_prisma_migrations" (
    "id" character varying(36) not null,
    "checksum" character varying(64) not null,
    "finished_at" timestamp with time zone,
    "migration_name" character varying(255) not null,
    "logs" text,
    "rolled_back_at" timestamp with time zone,
    "started_at" timestamp with time zone not null default now(),
    "applied_steps_count" integer not null default 0
);


CREATE UNIQUE INDEX "Booking_pkey" ON public."Booking" USING btree (id);

CREATE UNIQUE INDEX "GymMembership_pkey" ON public."GymMembership" USING btree ("userId", "gymId");

CREATE UNIQUE INDEX "Gym_pkey" ON public."Gym" USING btree (id);

CREATE UNIQUE INDEX "Invoice_pkey" ON public."Invoice" USING btree (id);

CREATE UNIQUE INDEX "MembershipPlan_pkey" ON public."MembershipPlan" USING btree (id);

CREATE UNIQUE INDEX "Payment_pkey" ON public."Payment" USING btree (id);

CREATE UNIQUE INDEX "Session_pkey" ON public."Session" USING btree (id);

CREATE UNIQUE INDEX "User_pkey" ON public."User" USING btree (id);

CREATE UNIQUE INDEX _prisma_migrations_pkey ON public._prisma_migrations USING btree (id);

alter table "public"."Booking" add constraint "Booking_pkey" PRIMARY KEY using index "Booking_pkey";

alter table "public"."Gym" add constraint "Gym_pkey" PRIMARY KEY using index "Gym_pkey";

alter table "public"."GymMembership" add constraint "GymMembership_pkey" PRIMARY KEY using index "GymMembership_pkey";

alter table "public"."Invoice" add constraint "Invoice_pkey" PRIMARY KEY using index "Invoice_pkey";

alter table "public"."MembershipPlan" add constraint "MembershipPlan_pkey" PRIMARY KEY using index "MembershipPlan_pkey";

alter table "public"."Payment" add constraint "Payment_pkey" PRIMARY KEY using index "Payment_pkey";

alter table "public"."Session" add constraint "Session_pkey" PRIMARY KEY using index "Session_pkey";

alter table "public"."User" add constraint "User_pkey" PRIMARY KEY using index "User_pkey";

alter table "public"."_prisma_migrations" add constraint "_prisma_migrations_pkey" PRIMARY KEY using index "_prisma_migrations_pkey";

alter table "public"."Booking" add constraint "Booking_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "Gym"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."Booking" validate constraint "Booking_gymId_fkey";

alter table "public"."Booking" add constraint "Booking_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES "User"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."Booking" validate constraint "Booking_memberId_fkey";

alter table "public"."Booking" add constraint "Booking_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "Session"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."Booking" validate constraint "Booking_sessionId_fkey";

alter table "public"."Gym" add constraint "Gym_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."Gym" validate constraint "Gym_ownerId_fkey";

alter table "public"."GymMembership" add constraint "GymMembership_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "Gym"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."GymMembership" validate constraint "GymMembership_gymId_fkey";

alter table "public"."GymMembership" add constraint "GymMembership_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."GymMembership" validate constraint "GymMembership_userId_fkey";

alter table "public"."Invoice" add constraint "Invoice_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "Gym"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."Invoice" validate constraint "Invoice_gymId_fkey";

alter table "public"."Invoice" add constraint "Invoice_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES "User"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."Invoice" validate constraint "Invoice_memberId_fkey";

alter table "public"."MembershipPlan" add constraint "MembershipPlan_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "Gym"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."MembershipPlan" validate constraint "MembershipPlan_gymId_fkey";

alter table "public"."Payment" add constraint "Payment_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "Gym"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."Payment" validate constraint "Payment_gymId_fkey";

alter table "public"."Payment" add constraint "Payment_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES "User"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."Payment" validate constraint "Payment_memberId_fkey";

alter table "public"."Session" add constraint "Session_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "Gym"(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."Session" validate constraint "Session_gymId_fkey";


