import express from 'express';
import { AuthRoutes } from '../modules/auth/auth.routes';
import { MessageRoutes } from '../modules/messages/message.routes';
import { NotificationRoutes } from '../modules/notifications/notifications.routes';
import { DashboardRoutes } from '../modules/dashboard/dashboard.routes';
import { PaymentRoutes } from '../modules/payment/payment.routes';

const router = express.Router();

const moduleRoutes = [
  // -- done
  {
    path: '/auth',
    route: AuthRoutes,
  },
  // -- done
  {
    path: '/message',
    route: MessageRoutes,
  },
  {
    path: '/dashboard',
    route: DashboardRoutes,
  },
  {
    path: '/payment',
    route: PaymentRoutes,
  },
  // -- progressing
  {
    path: '/notification',
    route: NotificationRoutes,
  },
];
moduleRoutes.forEach(route => router.use(route.path, route.route));

export default router;
