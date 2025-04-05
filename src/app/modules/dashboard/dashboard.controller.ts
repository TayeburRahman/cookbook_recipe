import { Request, RequestHandler, Response } from 'express';
import sendResponse from '../../../shared/sendResponse';
import catchAsync from '../../../shared/catchasync';
import { DashbaordService } from './dashboard.service';
import { IAdds, ISubscriptions } from './dsashbaord.interface';
import { Subscription } from './dashboard.model';
import { IReqUser } from '../auth/auth.interface';

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

// ===============================================================
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

const getRecipesForYou: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const id = req.params.id
    const user = req.user;
    const result = await DashbaordService.getRecipesForYou(user as IReqUser);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Delate sucessfully`,
      data: result,
    });
  });

const addsInsertIntoDB = catchAsync(async (req: Request, res: Response) => {
  const result = await DashbaordService.addsInsertIntoDB(req.files, req.body);
  sendResponse<IAdds>(res, {
    statusCode: 200,
    success: true,
    message: 'Adds create successfully',
    data: result,
  });
});

const updateAdds = catchAsync(async (req: Request, res: Response) => {
  const result = await DashbaordService.updateAdds(req);
  sendResponse<IAdds>(res, {
    statusCode: 200,
    success: true,
    message: 'Adds update successfully',
    data: result,
  });
});

const deleteAdds = catchAsync(async (req: Request, res: Response) => {
  const result = await DashbaordService.deleteAdds(req.params.id);
  sendResponse<IAdds>(res, {
    statusCode: 200,
    success: true,
    message: 'Adds delete successfully',
    data: result,
  });
});

const allAdds = catchAsync(async (req: Request, res: Response) => {
  const result = await DashbaordService.allAdds(req.query);
  sendResponse<IAdds[]>(res, {
    statusCode: 200,
    success: true,
    message: 'Adds Retrieved successfully',
    meta: result.meta,
    data: result.data,
  });
});
// ===========================
const addFaq = catchAsync(async (req: Request, res: Response) => {
  const result = await DashbaordService.addFaq(req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Successfully create!',
    data: result,
  });
});
const updateFaq = catchAsync(async (req: Request, res: Response) => {
  const result = await DashbaordService.updateFaq(req);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Successfully Update!',
    data: result,
  });
});
const deleteFaq = catchAsync(async (req: Request, res: Response) => {
  const result = await DashbaordService.deleteFaq(req);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Successfully Delete!',
    data: result,
  });
});
const getFaq = catchAsync(async (req: Request, res: Response) => {
  const result = await DashbaordService.getFaq();
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Successfully get!',
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
  getRecipeDetails,
  getRecipesForYou,
  addsInsertIntoDB,
  updateAdds,
  deleteAdds,
  allAdds,
  getFaq,
  deleteFaq,
  updateFaq,
  addFaq
};
