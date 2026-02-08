import express from 'express';
import validationMiddleware from '../../middlewares/validationMiddleware';
import CategoryController from './Category.controller';
import auth from '../../middlewares/auth';
import { ENUM_USER_ROLE } from '../../../enums/user';
import upload from '../../../helpers/upload';
import { createCategorySchema, updateCategorySchema } from './Category.validation';

const router = express.Router();

router.post(
  '/create-category',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  upload.single('image'),
  validationMiddleware(createCategorySchema),
  CategoryController.createCategory,
);
router.get(
  '/get-categories',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  CategoryController.getCategories,
);
router.get('/get-category-drop-down', CategoryController.getCategoryDropDown);
router.patch(
  '/update-category/:categoryId',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  upload.single('image'),
  validationMiddleware(updateCategorySchema),
  CategoryController.updateCategory,
);
router.delete(
  '/delete-category/:categoryId',
  auth(ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
  CategoryController.deleteCategory,
);

const CategoryRoutes = router;
export default CategoryRoutes;
