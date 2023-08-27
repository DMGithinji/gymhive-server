/*
  Warnings:

  - You are about to drop the column `gymId` on the `user` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "user" DROP CONSTRAINT "user_gymId_fkey";

-- AlterTable
ALTER TABLE "user" DROP COLUMN "gymId";

-- CreateTable
CREATE TABLE "_GymMembers" (
    "A" UUID NOT NULL,
    "B" UUID NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "_GymMembers_AB_unique" ON "_GymMembers"("A", "B");

-- CreateIndex
CREATE INDEX "_GymMembers_B_index" ON "_GymMembers"("B");

-- AddForeignKey
ALTER TABLE "_GymMembers" ADD CONSTRAINT "_GymMembers_A_fkey" FOREIGN KEY ("A") REFERENCES "gym"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_GymMembers" ADD CONSTRAINT "_GymMembers_B_fkey" FOREIGN KEY ("B") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
