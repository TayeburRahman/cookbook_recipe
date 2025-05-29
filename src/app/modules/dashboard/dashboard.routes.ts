import express from 'express';
import auth from '../../middlewares/auth';
import { ENUM_USER_ROLE } from '../../../enums/user';
import { DashboardController } from './dashboard.controller';
import { uploadFile } from '../../middlewares/fileUploader';

const router = express.Router();

// =============================
router.get('/get_total_count',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  DashboardController.totalCount,
);
router.get('/get_subscription_growth',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  DashboardController.getMonthlySubscriptionGrowth,
);
router.get('/get_user_growth',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  DashboardController.getMonthlyUserGrowth,
);

// =============================
router.get('/get_all_user',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  DashboardController.getAllUser,
);
router.post('/create_subscriptions',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  DashboardController.createSubscriptions,
);
router.patch('/update_subscriptions/:id',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  DashboardController.updateSubscription,
);
router.delete('/delete_subscriptions/:id',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  DashboardController.deleteSubscription,
);
router.get('/get_all_subscriptions',
  DashboardController.getAllSubscription,
);
// =========================================
router.post('/create_recipe',
  auth(ENUM_USER_ROLE.USER, ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  uploadFile(),
  DashboardController.createRecipes,
);
router.patch('/update_recipe/:id',
  uploadFile(),
  auth(ENUM_USER_ROLE.USER, ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  DashboardController.updateRecipes,
);
router.delete('/delete_recipe/:id',
  DashboardController.deleteRecipe,
);
router.get('/get_all_recipe',
  auth(ENUM_USER_ROLE.USER, ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  DashboardController.getAllRecipes,
);
router.get('/my_all_recipe',
  auth(ENUM_USER_ROLE.USER, ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  DashboardController.getMyRecipes,
);
router.get('/recipe_for_you',
  auth(ENUM_USER_ROLE.USER, ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  DashboardController.getRecipesForYou,
);
router.get('/get_recipe_details/:id',
  DashboardController.getRecipeDetails,
);
// ==================================================
router.post('/create-adds',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  uploadFile(),
  DashboardController.addsInsertIntoDB,
);
router.get(
  '/all-adds',
  DashboardController.allAdds,
);
router.patch(
  '/edit-adds/:id',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  uploadFile(),
  DashboardController.updateAdds,
);
router.delete(
  '/delete-adds/:id',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  DashboardController.deleteAdds,
);
// ========================
router.post('/add-faqs',
  DashboardController.addFaq,
);
router.patch('/update-faqs/:id',
  DashboardController.updateFaq,
);
router.delete('/delete-faqs/:id',
  DashboardController.deleteFaq,
);
router.get('/get-faqs',
  DashboardController.getFaq,
);
router.post('/addupdate-termsConditions',
  DashboardController.addTermsConditions,
);
router.get('/get-rules',
  DashboardController.getTermsConditions,
);

router.post('/addupdate-privacy-policy',
  DashboardController.addPrivacyPolicy,
);
router.get('/get-privacy-policy',
  DashboardController.getPrivacyPolicy,
);
// ================================
router.post('/send-message-support',
  auth(ENUM_USER_ROLE.USER),
  DashboardController.sendMessageSupport,
);
router.get('/get-message-support',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  DashboardController.getAllMessagesSupport,
);

// =================================================
// router.get('/get_recipe_details/:id',
//   DashboardController.getAllSubscription,
// );
router.patch('/toggle_favorite/:recipeId',
  auth(ENUM_USER_ROLE.USER),
  DashboardController.toggleFavorite
);
router.get('/get_user_favorites',
  auth(ENUM_USER_ROLE.USER),
  DashboardController.getUserFavorites
);
// =Reviews=================
router.post('/review/send',
  auth(ENUM_USER_ROLE.USER),
  DashboardController.createReviews)

router.post('/review/get/:id',
  auth(ENUM_USER_ROLE.USER),
  DashboardController.createRecipes)


export const DashboardRoutes = router;
