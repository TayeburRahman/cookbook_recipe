import { Request, Response } from 'express';
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';
import { IReqUser } from '../auth/auth.interface';
import { MealService } from './mealplan.service';

const addMealPlan = catchAsync(async (req: Request, res: Response) => {
    const query = req.query as {
        planId: string;
        day: string
        recipeId: string
    }
    const result = await MealService.addPlaneRecipes(query, req.user as IReqUser);
    sendResponse(res, {
        statusCode: 200,
        success: true,
        data: result,
        message: "Add Successfully!",
    });
});

const getMealPlanById = catchAsync(async (req: Request, res: Response) => {
    const id = req.params.id
    const result = await MealService.getMealPlanById(id as any);
    sendResponse(res, {
        statusCode: 200,
        success: true,
        data: result,
        message: "Add Successfully!",
    });
});

const createCustomPlane = catchAsync(async (req: Request, res: Response) => {
    const payload = req.body;
    const user = req.user;
    const result = await MealService.createCustomPlane(user as IReqUser, payload as any);
    sendResponse(res, {
        statusCode: 200,
        success: true,
        data: result,
        message: "Add Successfully!",
    });
});

const getCustomMealPlan = catchAsync(async (req: Request, res: Response) => {
    const user = req.user;
    const result = await MealService.getCustomMealPlan(user as IReqUser);
    sendResponse(res, {
        statusCode: 200,
        success: true,
        data: result,
        message: "Get Successfully!",
    });
});


const getFeaturedMealPlan = catchAsync(async (req: Request, res: Response) => {
    const user = req.user;
    const result = await MealService.getFeaturedMealPlan(user as IReqUser);
    sendResponse(res, {
        statusCode: 200,
        success: true,
        data: result,
        message: "Get Successfully!",
    });
});

const deleteCustomMealPlan = catchAsync(async (req: Request, res: Response) => {
    const id = req.params.id;
    const result = await MealService.deleteCustomMealPlan(id as string);
    sendResponse(res, {
        statusCode: 200,
        success: true,
        data: result,
        message: "Delete Successfully!",
    });
});




export const MealPlanController = {
    addMealPlan,
    getMealPlanById,
    createCustomPlane,
    getCustomMealPlan,
    getFeaturedMealPlan,
    deleteCustomMealPlan
};
