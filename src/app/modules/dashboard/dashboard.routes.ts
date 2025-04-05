import express from 'express';
import auth from '../../middlewares/auth';
import { ENUM_USER_ROLE } from '../../../enums/user';
import { DashboardController } from './dashboard.controller';
import { uploadFile } from '../../middlewares/fileUploader';

const router = express.Router();

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
  DashboardController.createRecipes,
);
router.patch('/update_recipe/:id',
  auth(ENUM_USER_ROLE.USER, ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  DashboardController.updateRecipes,
);
router.delete('/delete_recipe/:id',
  DashboardController.deleteRecipe,
);
router.get('/get_all_recipe',
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



// =================================================
router.get('/get_recipe_details/:id',
  DashboardController.getAllSubscription,
);

export const DashboardRoutes = router;
