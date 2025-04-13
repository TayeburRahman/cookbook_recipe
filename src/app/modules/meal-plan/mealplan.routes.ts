import express from 'express';
import auth from '../../middlewares/auth';
import { ENUM_USER_ROLE } from '../../../enums/user';
import { MealPlanController } from './mealplan.controller';

const router = express.Router();

router.post(
    '/add_recipes',
    auth(ENUM_USER_ROLE.USER),
    MealPlanController.addMealPlan,
);

router.get(
    '/get_mealPlan_details/:id',
    auth(ENUM_USER_ROLE.USER),
    MealPlanController.getMealPlanById,
);

router.post(
    '/create_custom_plane',
    auth(ENUM_USER_ROLE.USER),
    MealPlanController.createCustomPlane,
);

router.get(
    '/get_custom_plane',
    auth(ENUM_USER_ROLE.USER),
    MealPlanController.getCustomMealPlan,
);

router.get(
    '/get_featured_plane',
    auth(ENUM_USER_ROLE.USER),
    MealPlanController.getFeaturedMealPlan,
);

router.delete(
    '/delete_custom_plane/:id',
    auth(ENUM_USER_ROLE.USER),
    MealPlanController.deleteCustomMealPlan,
);





export const MealPlanRoutes = router;