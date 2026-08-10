import { Request, Response } from "express";
import catchAsync from "../../../shared/catchasync";
import sendResponse from "../../../shared/sendResponse";
import { PaymentServices } from "./payment.service";
import { IReqUser } from "../auth/auth.interface";

const createCheckoutSessionStripe = catchAsync(async (req: Request, res: Response) => {
    const result = await PaymentServices.createCheckoutSessionStripe(req);

    sendResponse(res, {
        statusCode: 200,
        success: true,
        message: "Create Checkout Session Successfully",
        data: result,
    });
});

const stripeCheckAndUpdateStatusSuccess = catchAsync(async (req: Request, res: Response) => {
    const result = await PaymentServices.stripeCheckAndUpdateStatusSuccess(req);

    sendResponse(res, {
        statusCode: 200,
        success: true,
        message: "Update Session Successfully",
        data: result,
    });
});


const getAllTransactions = catchAsync(async (req: Request, res: Response) => {
    const result = await PaymentServices.getAllTransactions(req.query);

    sendResponse(res, {
        statusCode: 200,
        success: true,
        message: "Get Successfully",
        data: result,
    });
});

const createFreePlan = catchAsync(async (req: Request, res: Response) => {
    const result = await PaymentServices.createFreePlan(req.user as IReqUser, req.params.planId);

    sendResponse(res, {
        statusCode: 200,
        success: true,
        message: "Free Plan Active Successfully",
        data: result,
    });
});



export const PaymentController = {
    createCheckoutSessionStripe,
    stripeCheckAndUpdateStatusSuccess,
    getAllTransactions,
    createFreePlan
}