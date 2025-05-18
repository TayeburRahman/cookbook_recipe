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
router.patch(
    '/swap_plane_recipe',
    auth(ENUM_USER_ROLE.USER),
    MealPlanController.swapPlanRecipes,
);

router.delete(
    '/remove_plan_recipes',
    auth(ENUM_USER_ROLE.USER),
    MealPlanController.removePlanRecipes,
);
router.get(
    '/get_weekly_plane',
    auth(ENUM_USER_ROLE.USER),
    MealPlanController.getWeeklyMealPlan,
);

// =Grocery List====================
router.get(
    '/get_grocery_list/:id',
    auth(ENUM_USER_ROLE.USER),
    MealPlanController.getGroceryList,
);
router.patch(
    '/toggle_ingredient_buy_status/:id',
    auth(ENUM_USER_ROLE.USER),
    MealPlanController.toggleIngredientBuyStatus,
);

// =======================
router.get(
    '/get_notifications',
    auth(ENUM_USER_ROLE.USER),
    MealPlanController.getUserNotifications,
);

router.patch(
    '/seen_notifications',
    auth(ENUM_USER_ROLE.USER),
    MealPlanController.seenNotifications,
);



export const MealPlanRoutes = router;