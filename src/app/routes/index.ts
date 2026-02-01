import express from 'express';
import { AuthRoutes } from '../modules/auth/auth.routes';
import { DashboardRoutes } from '../modules/dashboard/dashboard.routes';
import { PaymentRoutes } from '../modules/payment/payment.routes';
import { MealPlanRoutes } from '../modules/meal-plan/mealplan.routes';
import CategoryRoutes from '../modules/category/Category.route';

const router = express.Router();

const moduleRoutes = [
  // -- done
  {
    path: '/auth',
    route: AuthRoutes,
  },
  // -- done
  {
    path: '/meal_plan',
    route: MealPlanRoutes,
  },
  {
    path: '/dashboard',
    route: DashboardRoutes,
  },
  {
    path: '/payment',
    route: PaymentRoutes,
  },
  {
    path: '/category',
    route: CategoryRoutes,
  },
];
moduleRoutes.forEach(route => router.use(route.path, route.route));

export default router;
