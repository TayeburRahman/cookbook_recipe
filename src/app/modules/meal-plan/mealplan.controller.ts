import { Request, Response } from 'express';
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';
import { IReqUser } from '../auth/auth.interface';
import { MealService } from './mealplan.service';
import { NotificationService } from './notification.service';

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


const swapPlanRecipes = catchAsync(async (req: Request, res: Response) => {
    const query = req.query as {
        removeId: string;
        newId: string;
        day: string;
        planId: string;
    };
    const result = await MealService.swapPlanRecipes(query);
    sendResponse(res, {
        statusCode: 200,
        success: true,
        data: result,
        message: 'Recipe swapped successfully'
    });
});

const removePlanRecipes = catchAsync(async (req: Request, res: Response) => {
    const query = req.query as {
        removeId: string;
        day: string;
        planId: string;
    };
    const result = await MealService.removePlanRecipes(query);
    sendResponse(res, {
        statusCode: 200,
        success: true,
        data: result,
        message: 'Remove swapped successfully'
    });
});

const getWeeklyMealPlan = catchAsync(async (req: Request, res: Response) => {
    const user = req.user;
    const result = await MealService.getWeeklyMealPlan(user as IReqUser);
    sendResponse(res, {
        statusCode: 200,
        success: true,
        data: result,
        message: "Get Successfully!",
    });
});

const getGroceryList = catchAsync(async (req: Request, res: Response) => {
    const id = req.params.id;
    const result = await MealService.getGroceryList(id as string);
    sendResponse(res, {
        statusCode: 200,
        success: true,
        data: result,
        message: "Get Successfully!",
    });
});

const toggleIngredientBuyStatus = catchAsync(async (req: Request, res: Response) => {
    const id = req.params.id;
    const result = await MealService.toggleIngredientBuyStatus(id as string);
    sendResponse(res, {
        statusCode: 200,
        success: true,
        data: result,
        message: "Update Successfully!",
    });
});

const seenNotifications = catchAsync(async (req, res) => {
    const result = await NotificationService.seenNotifications(req);
    sendResponse(res, {
        statusCode: 200,
        success: true,
        message: "Notification update successfully",
        data: result,
    });
});

const getUserNotifications = catchAsync(async (req, res) => {
    const user = req.user;
    const result = await NotificationService.getUserNotifications(user as IReqUser);
    sendResponse(res, {
        statusCode: 200,
        success: true,
        message: "Notification retrieved successfully",
        data: result,
    });
});


const getWeekendPrepAdvice = catchAsync(async (req: Request, res: Response) => {
    const { planId } = req.params;
    const result = await MealService.generateWeekendPrepAdvice(planId);
    
    sendResponse(res, {
        statusCode: 200,
        success: true,
        data: result,
        message: "Weekend prep advice retrieved successfully!",
    });
});

const toggleSpeedPrepStep = catchAsync(async (req: Request, res: Response) => {
    const { planId, stepId } = req.body; 
    
    const result = await MealService.toggleSpeedPrepStep(planId, stepId);
    
    sendResponse(res, {
        statusCode: 200,
        success: true,
        data: result,
        message: "Step status updated!",
    });
});

const resetMealPlan = catchAsync(async (req: Request, res: Response) => {
    const { id } = req.params;
    const result = await MealService.resetMealPlan(id as string);
    sendResponse(res, {
        statusCode: 200,
        success: true,
        data: result,
        message: "Meal plan reset successfully!",
    });
});
const getGroceryListAdvice = catchAsync(async (req: Request, res: Response) => {
    const { planId } = req.params;
    const result = await MealService.generateWeeklyGroceryList(planId);
    sendResponse(res, {
        statusCode: 200,
        success: true,
        data: result,
        message: "Grocery list generated successfully!",
    });
});
export const MealPlanController = {
    addMealPlan,
    getMealPlanById,
    createCustomPlane,
    getCustomMealPlan,
    getFeaturedMealPlan,
    deleteCustomMealPlan,
    swapPlanRecipes,
    removePlanRecipes,
    getWeeklyMealPlan,
    getGroceryList,
    toggleIngredientBuyStatus,
    seenNotifications,
    getUserNotifications,
    getWeekendPrepAdvice, toggleSpeedPrepStep,
    resetMealPlan, getGroceryListAdvice
};
