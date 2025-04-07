import express from 'express';
import auth from '../../middlewares/auth';
import { ENUM_USER_ROLE } from '../../../enums/user';
import { MealPlanController } from './mealplan.controller';

const router = express.Router();

router.post(
    '/send-message/:id',
    auth(ENUM_USER_ROLE.USER, ENUM_USER_ROLE.USER, ENUM_USER_ROLE.ADMIN),
    MealPlanController.sendMessage,
);


export const MealPlanRoutes = router;
