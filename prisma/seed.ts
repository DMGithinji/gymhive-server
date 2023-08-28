import { PrismaClient, UserRole } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  await prisma.user.createMany({
    data: [
      {
        firstName: 'John',
        lastName: 'Doe',
        phone: '1234567890',
        email: 'john.doe@example.com',
        role: UserRole.GYM_OWNER,
        createdAt: new Date(),
      },
      {
        firstName: 'Jane',
        lastName: 'Smith',
        phone: '0987654321',
        email: 'jane.smith@example.com',
        role: UserRole.GYM_OWNER,
        createdAt: new Date(),
      },
    ],
  });

  const owners = await prisma.user.findMany();
  console.log(`Created ${owners.length} owners`)

  await prisma.gym.createMany({
    data: [
      {
        name: 'Gym A',
        phone: '1234567890',
        email: 'gymA@example.com',
        address: '123 Street, City',
        ownerId: owners[0].id,
        createdAt: new Date(),
      },
      {
        name: 'Gym B',
        phone: '1234567890',
        email: 'gymB@example.com',
        address: '456 Street, City',
        ownerId: owners[0].id,
        createdAt: new Date(),
      },
      {
        name: 'Gym C',
        phone: '1234567890',
        email: 'gymC@example.com',
        address: '789 Street, City',
        ownerId: owners[1].id,
        createdAt: new Date(),
      },
    ],
  });

  const gyms = await prisma.gym.findMany();
  console.log(`Created ${gyms.length} gyms`)


  for (let gym of gyms) {

    // Add Membership Plans
    for (let i = 1; i <= 3; i++) {
      await prisma.membershipPlan.create({
        data: {
          gymId: gym.id,
          name: `Plan${i}`,
          price: i * 50,
          periodInSeconds: i * 10000,
          createdAt: new Date(),
        },
      });
    }

    // Add Gym Sessions/Classes
    for (let i = 1; i <= 3; i++) {
      await prisma.session.create({
        data: {
          gymId: gym.id,
          name: `Session${i}`,
          startTime: new Date(),
          period: i * 10,
          type: `Type${i}`,
          createdAt: new Date(),
        },
      });
    }

    const sessions = await prisma.session.findMany({ where: { gymId: gym.id } });
    console.log(`Created ${sessions.length} sessions for gym ${gym.name}`)

    const members = [];
    for (let i = 1; i <= 3; i++) {
      const member = await prisma.user.create({
        data: {
          firstName: `Member${i}`,
          lastName: `From${gym.name}`,
          phone: `1234567${i}90`,
          email: `member${i}@${gym.name.toLowerCase()}.com`,
          role: UserRole.MEMBER,
          createdAt: new Date(),
        },
      });

      members.push(member);

      await prisma.gymMembership.create({
        data: {
          userId: member.id,
          gymId: gym.id,
        },
      });

      console.log(`Added member ${member.firstName} for gym ${gym.name}`)

      // Sample invoices for members
      if (i % 2 === 0) {
        await prisma.invoice.create({
          data: {
            gymId: gym.id,
            memberId: member.id,
            total: 100,
            createdAt: new Date(),
          },
        });

        const invoice = await prisma.invoice.findFirst();
        console.log(`Added invoice for member ${member.firstName}`)

        await prisma.payment.create({
          data: {
            gymId: gym.id,
            memberId: member.id,
            amount: invoice.total,
            createdAt: new Date(),
          },
        });
        console.log(`Added payment for member ${member.firstName}`)
      }

      // Sample booking for members
      if (i !== 3) {
        await prisma.booking.create({
          data: {
            gymId: gym.id,
            memberId: member.id,
            sessionId: sessions[i - 1].id, // accounting for 0-based indexing
            createdAt: new Date(),
          },
        });
        console.log(`Added booking for member ${member.firstName}`)
      }
    }

  }
}

main().catch(e => {
  console.error(e);
});