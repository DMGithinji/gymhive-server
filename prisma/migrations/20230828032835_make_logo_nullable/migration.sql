-- AlterTable
ALTER TABLE "booking" ALTER COLUMN "createdAt" SET DEFAULT now();

-- AlterTable
ALTER TABLE "gym" ALTER COLUMN "logo" DROP NOT NULL,
ALTER COLUMN "createdAt" SET DEFAULT now();

-- AlterTable
ALTER TABLE "invoice" ALTER COLUMN "createdAt" SET DEFAULT now();

-- AlterTable
ALTER TABLE "membershipPlan" ALTER COLUMN "createdAt" SET DEFAULT now();

-- AlterTable
ALTER TABLE "payment" ALTER COLUMN "createdAt" SET DEFAULT now();

-- AlterTable
ALTER TABLE "session" ALTER COLUMN "createdAt" SET DEFAULT now();

-- AlterTable
ALTER TABLE "user" ALTER COLUMN "createdAt" SET DEFAULT now();
