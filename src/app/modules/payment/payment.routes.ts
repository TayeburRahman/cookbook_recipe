import express from 'express';
import auth from '../../middlewares/auth';
import { ENUM_USER_ROLE } from '../../../enums/user';
import { PaymentController } from './payment.controller';

const router = express.Router();

router.post('/create_checkout_session',
    auth(ENUM_USER_ROLE.USER, ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
    PaymentController.createCheckoutSessionStripe);
router.get('/stripe-webhooks',
    // auth(ENUM_USER_ROLE.USER, ENUM_USER_ROLE.ADMIN, ENUM_USER_ROLE.SUPER_ADMIN),
    PaymentController.stripeCheckAndUpdateStatusSuccess);


export const PaymentRoutes = router;