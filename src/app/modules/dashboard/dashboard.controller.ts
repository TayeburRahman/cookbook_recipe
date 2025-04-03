import { Request, RequestHandler, Response } from 'express';
import sendResponse from '../../../shared/sendResponse';
import catchAsync from '../../../shared/catchasync';
import { DashbaordService } from './dashboard.service';
import { ISubscriptions } from './dsashbaord.interface';
import { Subscription } from './dashboard.model';
import { IReqUser } from '../auth/auth.interface';
import { Types } from 'mongoose';

const getAllUser: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const query = req.query as any;
    const result = await DashbaordService.getAllUser(query as any);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Get all user!`,
      data: result,
    });
  },
);

const createSubscriptions: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const body = req.body as any;
    const result = await DashbaordService.createSubscriptions(body as any);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Create Sucessfully!`,
      data: result,
    });
  },
);

const updateSubscription: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const body = req.body as ISubscriptions;
    const id = req.params.id
    const result = await DashbaordService.updateSubscription(id as string, body as ISubscriptions);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Update Sucessfully!`,
      data: result,
    });
  },
);

const deleteSubscription: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const id = req.params.id
    const result = await DashbaordService.deleteSubscription(id as string);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Delate sucessfully`,
      data: result,
    });
  },
);

const getAllSubscription: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const result = await Subscription.find();
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Delate sucessfully`,
      data: result,
    });
  },
);
//   ===============================================================

const getAllRecipes: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const query = req.query as any;
    const body = req.body;
    const result = await DashbaordService.getAllRecipes(query as any, body as any);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Get all recipes sucessfully!`,
      data: result,
    });
  },
);

const createRecipes: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const body = req.body as any;
    const user = req.user as IReqUser;
    const result = await DashbaordService.createRecipes(body as any, user);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Create Sucessfully!`,
      data: result,
    });
  },
);

const updateRecipes: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const body = req.body as ISubscriptions;
    const id = req.params.id
    const result = await DashbaordService.updateRecipes(id as string, body as ISubscriptions);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Update Sucessfully!`,
      data: result,
    });
  },
);

const deleteRecipe: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const id = req.params.id
    const result = await DashbaordService.deleteRecipe(id as string);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Delate sucessfully`,
      data: result,
    });
  });

const getMyRecipes: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const user = req.user
    const result = await DashbaordService.getMyRecipes(user as IReqUser);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Delate sucessfully`,
      data: result,
    });
  });

const getRecipeDetails: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const id = req.params.id
    const result = await DashbaordService.getRecipeDetails(id as any);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Delate sucessfully`,
      data: result,
    });
  });


export const DashboardController = {
  getAllUser,
  createSubscriptions,
  updateSubscription,
  deleteSubscription,
  getAllSubscription,
  getAllRecipes,
  createRecipes,
  updateRecipes,
  deleteRecipe,
  getMyRecipes,
  getRecipeDetails
};
