import { Request, RequestHandler, Response } from 'express';
import sendResponse from '../../../shared/sendResponse';
import catchAsync from '../../../shared/catchasync';
import { DashboardService } from './dashboard.service';
import { IAdds, IRecipe, ISubscriptions } from './dsashbaord.interface';
import { Subscription } from './dashboard.model';
import { IReqUser } from '../auth/auth.interface';


const totalCount: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const result = await DashboardService.totalCount();
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Get all count sucess!`,
      data: result,
    });
  },
);
const getMonthlySubscriptionGrowth: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const year = req.query.year
      ? parseInt(req.query.year as string, 10)
      : undefined;
    const result = await DashboardService.getMonthlySubscriptionGrowth(year);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Get all count sucess!`,
      data: result,
    });
  },
);

const getMonthlyUserGrowth: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const year = req.query.year
      ? parseInt(req.query.year as string, 10)
      : undefined;
    const result = await DashboardService.getMonthlyUserGrowth(year);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Get all count sucess!`,
      data: result,
    });
  },
);


const getAllUser: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const query = req.query as any;
    const result = await DashboardService.getAllUser(query as any);
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
    const result = await DashboardService.createSubscriptions(body as any);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Create Successfully!`,
      data: result,
    });
  },
);

const updateSubscription: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const body = req.body as ISubscriptions;
    const id = req.params.id
    const result = await DashboardService.updateSubscription(id as string, body as ISubscriptions);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Update Successfully!`,
      data: result,
    });
  },
);

const deleteSubscription: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const id = req.params.id
    const result = await DashboardService.deleteSubscription(id as string);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Delate successfully`,
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
      message: `Get successfully`,
      data: result,
    });
  },
);

// ===============================================================
const getAllRecipes: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const query = req.query as any;
    const body = req.body;
    const user = req.user as IReqUser;
    const result = await DashboardService.getAllRecipes(user, query as any, body as any);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Get all recipes successfully!`,
      data: result,
    });
  },
);

const createRecipes: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const body = req.body as any;
    const user = req.user as IReqUser;
    const result = await DashboardService.createRecipes(req.files, body as any, user);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Create Successfully!`,
      data: result,
    });
  },
);

const updateRecipes: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const payload = req.body as IRecipe;
    const files = req.files;
    const user = req.user;
    const id = req.params.id
    const result = await DashboardService.updateRecipes(id as string, files as any, user as any, payload as IRecipe);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Update Successfully!`,
      data: result,
    });
  },
);

const deleteRecipe: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const id = req.params.id
    const result = await DashboardService.deleteRecipe(id as string);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Delate successfully`,
      data: null,
    });
  });

const getMyRecipes: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const user = req.user
    const result = await DashboardService.getMyRecipes(user as IReqUser);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Get My Recipes successfully`,
      data: result,
    });
  });

const getRecipeDetails: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const id = req.params.id
    const result = await DashboardService.getRecipeDetails(id as any);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Get Recipes successfully`,
      data: result,
    });
  });

const getRecipesForYou: RequestHandler = catchAsync(
  async (req: Request, res: Response) => {
    const id = req.params.id
    const user = req.user;
    const result = await DashboardService.getRecipesForYou(user as IReqUser);
    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: `Get successfully`,
      data: result,
    });
  });

const addsInsertIntoDB = catchAsync(async (req: Request, res: Response) => {
  const result = await DashboardService.addsInsertIntoDB(req.files, req.body);
  sendResponse<IAdds>(res, {
    statusCode: 200,
    success: true,
    message: 'Adds create successfully',
    data: result,
  });
});

const updateAdds = catchAsync(async (req: Request, res: Response) => {
  const result = await DashboardService.updateAdds(req);
  sendResponse<IAdds>(res, {
    statusCode: 200,
    success: true,
    message: 'Adds update successfully',
    data: result,
  });
});

const deleteAdds = catchAsync(async (req: Request, res: Response) => {
  const result = await DashboardService.deleteAdds(req.params.id);
  sendResponse<IAdds>(res, {
    statusCode: 200,
    success: true,
    message: 'Adds delete successfully',
    data: result,
  });
});

const allAdds = catchAsync(async (req: Request, res: Response) => {
  const result = await DashboardService.allAdds(req.query);
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
  const result = await DashboardService.addFaq(req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Successfully create!',
    data: result,
  });
});
const updateFaq = catchAsync(async (req: Request, res: Response) => {
  const result = await DashboardService.updateFaq(req);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Successfully Update!',
    data: result,
  });
});

const deleteFaq = catchAsync(async (req: Request, res: Response) => {
  const result = await DashboardService.deleteFaq(req);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Successfully Delete!',
    data: result,
  });
});

const getFaq = catchAsync(async (req: Request, res: Response) => {
  const result = await DashboardService.getFaq();
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Successfully get!',
    data: result,
  });
});

const addTermsConditions = catchAsync(async (req: Request, res: Response) => {
  const result = await DashboardService.addTermsConditions(req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Successful',
    data: result,
  });
});

const getTermsConditions = catchAsync(async (req: Request, res: Response) => {
  const result = await DashboardService.getTermsConditions();
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Successful',
    data: result,
  });
});

const addPrivacyPolicy = catchAsync(async (req: Request, res: Response) => {
  const result = await DashboardService.addPrivacyPolicy(req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Successful',
    data: result,
  });
});

const getPrivacyPolicy = catchAsync(async (req: Request, res: Response) => {
  const result = await DashboardService.getPrivacyPolicy();
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Successful',
    data: result,
  });
});
// ================================

const sendMessageSupport = catchAsync(async (req: Request, res: Response) => {
  const user = req.user as IReqUser;
  const result = await DashboardService.sendMessageSupport(user, req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Successful',
    data: result,
  });
});

const getAllMessagesSupport = catchAsync(async (req: Request, res: Response) => {
  const user = req.user as IReqUser;
  const query = req.query;
  const result = await DashboardService.getAllMessagesSupport(query);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Successful',
    data: result,
  });
});

const toggleFavorite = catchAsync(async (req: Request, res: Response) => {
  const { authId } = req.user as IReqUser;
  const recipeId = req.params.recipeId;
  const result = await DashboardService.addRemoveFavorites(authId as any, recipeId as any);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: result.message,
    data: result,
  });
});

const getUserFavorites = catchAsync(async (req: Request, res: Response) => {
  const user = req.user as IReqUser;
  const result = await DashboardService.getUserFavorites(user);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Successful',
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
  addFaq,
  addTermsConditions,
  getTermsConditions,
  addPrivacyPolicy,
  getPrivacyPolicy,
  sendMessageSupport,
  getAllMessagesSupport,
  totalCount,
  getMonthlySubscriptionGrowth,
  getMonthlyUserGrowth,
  toggleFavorite,
  getUserFavorites

};
