import { Prisma, PrismaClient } from "@prisma/client";

const client = new PrismaClient();

const getGymOwners = () : Prisma.userCreateInput[]=> [
  {
    firstName: 'Denis',
    lastName: "Githinji",
    phone: "0712224283",
    email: "dmwaigithinji@gmail.com",
    role: 'GymOwner'
  }
]