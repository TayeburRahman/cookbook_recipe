import { Types } from 'mongoose';
import QueryBuilder from '../../../builder/QueryBuilder';
import ApiError from '../../../errors/ApiError';
import * as XLSX from 'xlsx';
import { IReqUser } from '../auth/auth.interface';
import User from '../user/user.model';
import path from 'path';
import {
  Adds,
  ContactSupport,
  Faq,
  PrivacyPolicy,
  Recipe,
  Review,
  Subscription,
  TermsConditions,
} from './dashboard.model';
import {
  IAdds,
  IContactSupport,
  IRecipe,
  IReview,
  ISubscriptions,
} from './dsashbaord.interface';
import { IUser } from '../user/user.interface';
import { logger } from '../../../shared/logger';
import { Transaction } from '../payment/payment.model';
import uploadToCloudinary from '../../../utils/uploadToCloudinary';
import isNotObjectId from '../../../utils/isNotObjectId';
import CategoryModel from '../category/Category.model';

// ===========================================
const getYearRange = (year: any) => {
  const startDate = new Date(`${year}-01-01`);
  const endDate = new Date(`${year}-12-31`);
  return { startDate, endDate };
};

const totalCount = async () => {
  const totalIncome = await Transaction.aggregate([
    {
      $group: {
        _id: null,
        total: { $sum: '$amount' },
      },
    },
  ]);

  const totalUsers = await User.countDocuments();
  const totalRecipe = await Recipe.countDocuments();

  return {
    totalIncome: totalIncome.length > 0 ? totalIncome[0].total : 0,
    totalUsers,
    totalRecipe,
  };
};

const getMonthlySubscriptionGrowth = async (year?: number) => {
  try {
    const currentYear = new Date().getFullYear();
    const selectedYear = year || currentYear;

    const { startDate, endDate } = getYearRange(selectedYear);

    const monthlySubscriptionGrowth = await Subscription.aggregate([
      {
        $match: {
          createdAt: {
            $gte: startDate,
            $lt: endDate,
          },
        },
      },
      {
        $group: {
          _id: {
            month: { $month: '$createdAt' },
            year: { $year: '$createdAt' },
          },
          count: { $sum: 1 },
        },
      },
      {
        $project: {
          _id: 0,
          month: '$_id.month',
          year: '$_id.year',
          count: 1,
        },
      },
      {
        $sort: { month: 1 },
      },
    ]);

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    const result = Array.from({ length: 12 }, (_, i) => {
      const monthData = monthlySubscriptionGrowth.find(
        data => data.month === i + 1,
      ) || { month: i + 1, count: 0, year: selectedYear };
      return {
        ...monthData,
        month: months[i],
      };
    });

    return {
      year: selectedYear,
      data: result,
    };
  } catch (error) {
    throw error;
  }
};

const getMonthlyUserGrowth = async (year?: number) => {
  try {
    const currentYear = new Date().getFullYear();
    const selectedYear = year || currentYear;

    const { startDate, endDate } = getYearRange(selectedYear);

    const monthlyUserGrowth = await User.aggregate([
      {
        $match: {
          createdAt: {
            $gte: startDate,
            $lt: endDate,
          },
        },
      },
      {
        $group: {
          _id: {
            month: { $month: '$createdAt' },
            year: { $year: '$createdAt' },
          },
          count: { $sum: 1 },
        },
      },
      {
        $project: {
          _id: 0,
          month: '$_id.month',
          year: '$_id.year',
          count: 1,
        },
      },
      {
        $sort: { month: 1 },
      },
    ]);

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    const result = [];
    for (let i = 1; i <= 12; i++) {
      const monthData = monthlyUserGrowth.find(data => data.month === i) || {
        month: i,
        count: 0,
        year: selectedYear,
      };
      result.push({
        ...monthData,
        month: months[i - 1],
      });
    }

    return {
      year: selectedYear,
      data: result,
    };
  } catch (error) {
    logger.error('Error in getMonthlyUserGrowth function: ', error);
    throw error;
  }
};

// ===========================================
const getAllUser = async (query: any) => {
  const { page, limit, searchTerm } = query;

  if (query?.searchTerm) {
    delete query.page;
  }
  const userQuery = new QueryBuilder(
    User.find().populate({
      path: 'authId',
      select: 'is_block isActive role',
    }),
    query,
  )
    .search(['name', 'email'])
    .filter()
    .sort()
    .paginate()
    .fields();

  const result = await userQuery.modelQuery;
  const meta = await userQuery.countTotal();

  return { result, meta };
};

// =Subscriptions =================================
const createSubscriptions = async (payload: ISubscriptions) => {
  try {
    const subscription = new Subscription(payload);
    await subscription.save();
    return subscription;
  } catch (error: any) {
    throw new ApiError(400, `Error creating subscription: ${error.message}`);
  }
};

const updateSubscription = async (
  id: string,
  payload: Partial<ISubscriptions>,
) => {
  try {
    const updatedSubscription = await Subscription.findByIdAndUpdate(
      id,
      payload,
      { new: true },
    );
    if (!updatedSubscription) {
      throw new ApiError(404, 'Subscription not found');
    }
    return updatedSubscription;
  } catch (error: any) {
    throw new ApiError(400, `Error updating subscription: ${error.message}`);
  }
};

const deleteSubscription = async (id: string) => {
  try {
    const deletedSubscription = await Subscription.findByIdAndDelete(id);
    if (!deletedSubscription) {
      throw new ApiError(404, 'Subscription not found');
    }
    return deletedSubscription;
  } catch (error: any) {
    throw new ApiError(400, `Error deleting subscription: ${error.message}`);
  }
};

// ====================================
const getAllRecipes = async (user: IReqUser, query: any, payload: any) => {
  const { authId } = user;

  let filterQuery: any = {};

  // Range filters
  if (query?.prep_time_start && query?.prep_time_end) {
    const start = Number(query.prep_time_start);
    const end = Number(query.prep_time_end);
    if (!isNaN(start) && !isNaN(end)) {
      filterQuery.prep_time = { $gte: start, $lte: end };
    }
  }

  if (query?.serving_size_start && query?.serving_size_end) {
    const start = Number(query.serving_size_start);
    const end = Number(query.serving_size_end);
    if (!isNaN(start) && !isNaN(end)) {
      filterQuery.serving_size = { $gte: start, $lte: end };
    }
  }

  // Dynamic filters (like category, weight_and_muscle etc.)
  const allowedFilters = ['weight_and_muscle', 'oils'];
  allowedFilters.forEach(key => {
    if (query[key]) {
      filterQuery[key] = query[key];
    }
  });

  if (query.category) {
    filterQuery = {
      ...filterQuery,
      category: new Types.ObjectId(query.category),
    };
  }

  const userQuery = new QueryBuilder(
    Recipe.find(filterQuery)
      .select(
        '_id name category image prep_time serving_size oils ratting favorites weight_and_muscle',
      )
      .populate({
        path: 'category',
        select: 'name _id',
      }),
    query,
  )
    .search(['name'])
    .sort()
    .paginate()
    .fields();

  let result = await userQuery.modelQuery.lean();

  result = result.map(recipe => {
    // @ts-ignore
    const isFavorited = recipe?.favorites?.some(
      (id: any) => id.toString() === authId.toString(),
    );
    return {
      ...recipe,
      favorite: isFavorited,
    };
  });

  const meta = await userQuery.countTotal();

  return { meta, result };
};

const createRecipes = async (req: any, payload: IRecipe, user: IReqUser) => {
  const authId = user.authId as any;
  if (!req.file) {
    throw new ApiError(404, 'Please upload image');
  }

  //check categoryId
  if (!payload.category) {
    throw new ApiError(400, 'category is required');
  }
  if (isNotObjectId(payload?.category.toString())) {
    throw new ApiError(400, 'category must be a valid ObjectId');
  }

  const existingCategory = await CategoryModel.findById(
    payload?.category.toString(),
  );
  if (!existingCategory) {
    throw new ApiError(404, 'Category not found');
  }
  if (existingCategory.status === 'hidden') {
    throw new ApiError(404, 'Category is hidden');
  }
  /* --- check category ended */

  if (req.file) {
    payload.image = await uploadToCloudinary(
      req?.file?.path as string,
      'recipe',
    );
  }

  if (!authId) {
    throw new ApiError(404, 'User login unauthorized!');
  }

  payload.creator = authId;

  if (payload?.ingredients) {
    // @ts-ignore
    payload.ingredients = JSON.parse(payload?.ingredients);
  }
  if (payload?.nutritional) {
    // @ts-ignore
    payload.nutritional = JSON.parse(payload?.nutritional);
  }

  const recipe = new Recipe(payload);

  await recipe.save();

  return recipe;
};

const updateRecipes = async (
  id: string,
  req: any,
  user: any,
  payload: IRecipe,
) => {

  if (payload?.ingredients) {
    // @ts-ignore
    payload.ingredients = JSON.parse(payload?.ingredients);
  }
  if (payload?.nutritional) {
    // @ts-ignore
    payload.nutritional = JSON.parse(payload?.nutritional);
  }


  /*check category*/
  if (payload.category) {
    if (isNotObjectId(payload?.category.toString())) {
      throw new ApiError(400, 'category must be a valid ObjectId');
    }

    const existingCategory = await CategoryModel.findById(
      payload?.category.toString(),
    );
    if (!existingCategory) {
      throw new ApiError(404, 'Category not found');
    }
    if (existingCategory.status === 'hidden') {
      throw new ApiError(404, 'Category is hidden');
    }
  }
  /* --- check category ended */

  //if image is available
  if (req.file) {
    payload.image = await uploadToCloudinary(
      req?.file?.path as string,
      'recipe',
    );
  }

  const updatedRecipe = await Recipe.findByIdAndUpdate(id, payload, {
    new: true,
  });
  if (!updatedRecipe) {
    throw new ApiError(404, 'Recipe not found');
  }
  return updatedRecipe;
};

const deleteRecipe = async (id: string) => {
  try {
    const deletedSubscription = await Recipe.findByIdAndDelete(id);
    if (!deletedSubscription) {
      throw new ApiError(404, 'Subscription not found');
    }
    return deletedSubscription;
  } catch (error: any) {
    throw new ApiError(400, `Error deleting subscription: ${error.message}`);
  }
};

const getMyRecipes = async (user: IReqUser) => {
  const { authId } = user;
  const result = await Recipe.find({ creator: authId })
    .populate({
      path: 'category',
      select: 'name _id',
    })
    .sort({ createdAt: -1 });
  return result;
};

const getRecipeDetails = async (id: Types.ObjectId) => {
  const result = await Recipe.findById(id)
    .populate({
      path: 'scoreReview.userId',
      select: 'name email profile_image',
    })
    .populate({
      path: 'category',
      select: 'name _id',
    });

  if (!result) {
    throw new ApiError(404, 'Not find recipe!');
  }
  return result;
};

const getRecipesForYou = async (user: IReqUser) => {
  const { userId } = user;

  const userDb = (await User.findById(userId).select('helgth_goal')) as IUser;
  if (!userDb) return [];

  const recipes = await Recipe.find({
    weight_and_muscle: { $in: userDb.helgth_goal },
  }).select(
    '_id name category image prep_time serving_size oils ratting favorites',
  );

  return recipes;
};

// ===================================
const addsInsertIntoDB = async (req: any, payload: IAdds) => {
  if (!req.file) {
    throw new ApiError(400, 'Please upload an image');
  }

  if (req.file) {
    payload.image = await uploadToCloudinary(req?.file?.path as string, 'adds');
  }

  return await Adds.create(payload);
};

const allAdds = async (query: Record<string, unknown>) => {
  const addsQuery = new QueryBuilder(Adds.find(), query)
    .search([])
    .filter()
    .sort()
    .paginate()
    .fields();

  const result = await addsQuery.modelQuery;
  const meta = await addsQuery.countTotal();

  return {
    meta,
    data: result,
  };
};

const updateAdds = async (req: any) => {
  const id = req.params.id;
  const { ...AddsData } = req.body;

  if (req.file) {
    AddsData.image = await uploadToCloudinary(
      req?.file?.path as string,
      'adds',
    );
  }

  const isExist = await Adds.findOne({ _id: id });

  if (!isExist) {
    throw new ApiError(404, 'Adds not found !');
  }

  const result = await Adds.findOneAndUpdate(
    { _id: id },
    { ...AddsData },
    {
      new: true,
    },
  );
  return result;
};

const deleteAdds = async (id: string) => {
  const isExist = await Adds.findOne({ _id: id });
  if (!isExist) {
    throw new ApiError(404, 'Adds not found !');
  }
  return await Adds.findByIdAndDelete(id);
};

//! Faqs
const addFaq = async (payload: any) => {
  if (!payload?.questions || !payload?.answer) {
    throw new Error('Question and answer are required');
  }

  return await Faq.create(payload);
};

const updateFaq = async (req: any) => {
  const id = req.params.id;

  const payload = req.body;
  if (!payload?.questions || !payload?.answer) {
    throw new Error('Question and answer are required');
  }

  const result = await Faq.findByIdAndUpdate(id, payload, { new: true });

  return result;
};

const deleteFaq = async (req: any) => {
  const id = req.params.id;
  return await Faq.findByIdAndDelete(id);
};

const getFaq = async () => {
  return await Faq.find();
};

// ==============
const addTermsConditions = async (payload: any) => {
  const checkIsExist = await TermsConditions.findOne();
  if (checkIsExist) {
    return await TermsConditions.findOneAndUpdate({}, payload, {
      new: true,

      runValidators: true,
    });
  } else {
    return await TermsConditions.create(payload);
  }
};

const getTermsConditions = async () => {
  return await TermsConditions.findOne();
};

const addPrivacyPolicy = async (payload: any) => {
  const checkIsExist = await PrivacyPolicy.findOne();
  if (checkIsExist) {
    return await PrivacyPolicy.findOneAndUpdate({}, payload, {
      new: true,

      runValidators: true,
    });
  } else {
    return await PrivacyPolicy.create(payload);
  }
};

const getPrivacyPolicy = async () => {
  return await PrivacyPolicy.findOne();
};

// =================
const sendMessageSupport = async (user: IReqUser, payload: IContactSupport) => {
  return await ContactSupport.create({ ...payload, user: user?.userId });
};

const getAllMessagesSupport = async (query: any) => {
  const contactSupportQuery = new QueryBuilder(
    ContactSupport.find()
      .populate('user', 'name email')
      .sort({ createdAt: -1 }),
    query,
  )
    .search(['name', 'email', 'user.name', 'user.email'])
    .filter()
    .sort()
    .paginate()
    .fields();

  const result = await contactSupportQuery.modelQuery;
  const meta = await contactSupportQuery.countTotal();

  return {
    meta,
    data: result,
  };
};

// ========================
const addRemoveFavorites = async (
  authId: Types.ObjectId,
  recipeId: Types.ObjectId,
) => {
  const recipe = await Recipe.findById(recipeId);
  if (!recipe) {
    throw new ApiError(404, 'Recipe not found');
  }

  const isFavorited = recipe.favorites.includes(authId);

  if (isFavorited) {
    recipe.favorites = recipe.favorites.filter(
      id => id.toString() !== authId.toString(),
    );
  } else {
    recipe.favorites.push(authId);
  }

  await recipe.save();
  return {
    message: isFavorited ? 'Removed from favorites' : 'Added to favorites',
  };
};

const getUserFavorites = async (user: IReqUser) => {
  const authId = user.authId;

  const recipes = await Recipe.find({ favorites: authId })
    .select(
      '_id name category image prep_time serving_size oils ratting favorites',
    )
    .populate({
      path: 'category',
      select: 'name _id',
    })
    .lean();

  const updatedRecipes = recipes.map(recipe => ({
    ...recipe,
    favorite: true,
  }));

  return { recipes: updatedRecipes };
};

// Reviews======================================
const createReviews = async (user: IReqUser, payload: IReview) => {
  try {
    const { userId } = user;
    const { recipeId, ratting, feedback } = payload;
    const recipe = await Recipe.findById(recipeId);
    if (!recipe) {
      throw new ApiError(404, 'Recipe not found!');
    }
    const review = await Review.create({ ratting, feedback, recipeId, userId });
    if (!review) {
      throw new ApiError(404, 'Review not create!');
    }
    const allReviews = await Review.find({ recipeId });
    const totalRating = allReviews.reduce((acc, curr) => acc + curr.ratting, 0);
    const avgRating = totalRating / allReviews.length;

    recipe.ratting = avgRating;
    await recipe.save();
    return review;
  } catch (error: any) {
    throw new ApiError(400, `Error creating subscription: ${error.message}`);
  }
};

const getRecipesReview = async (recipeId: string) => {
  if (!recipeId) {
    throw new ApiError(400, `Recipe ID is missing.`);
  }
  const review = await Review.find({ recipeId }).populate({
    path: 'userId',
    select: 'name email profile_image',
  });
  return review;
};

const postScoreReview = async (
  user: IReqUser,
  recipeId: string,
  ratting: number,
): Promise<{ message: string; newAverage: number }> => {
  if (!recipeId || !ratting) {
    throw new ApiError(400, 'Recipe ID and rating are required.');
  }

  if (ratting < 1 || ratting > 5) {
    throw new ApiError(400, 'Rating must be between 1 and 5.');
  }

  const recipe = await Recipe.findById(recipeId);
  if (!recipe) {
    throw new ApiError(404, 'Recipe not found.');
  }

  const alreadyReviewed = recipe.scoreReview.find(
    (review: IReview) => review.userId.toString() === user.userId.toString(),
  );

  if (alreadyReviewed) {
    throw new ApiError(400, 'You have already rated this recipe.');
  }

  recipe.scoreReview.push({
    userId: new Types.ObjectId(user.userId),
    ratting,
  } as IReview);

  await recipe.save();

  return {
    message: 'Review submitted successfully.',
    newAverage: recipe.ratting,
  };
};

const updateAddRecipes = async () => {
  try {
    const filePath = path.resolve(__dirname, 'recipes.xlsx');
    const workbook = XLSX.readFile(filePath);
    const sheetName = workbook.SheetNames[0];
    const sheet = workbook.Sheets[sheetName];
    const rawData: any[] = XLSX.utils.sheet_to_json(sheet);

    const data = rawData.map(item => ({
      creator: item?.creator || null,
      image: item?.image,
      name: item?.name,
      ingredients: item?.ingredients
        ? JSON.parse(item.ingredients.replace(/'/g, '"'))
        : [],
      instructions: item?.instructions,
      nutritional: item?.nutritional ? JSON.parse(item?.nutritional) : {},
      category: item?.category,
      holiday_recipes: item?.holiday_recipes || null,
      oils: item?.oils,
      serving_temperature: item?.serving_temperature,
      flavor: item?.flavor,
      weight_and_muscle: item?.weight_and_muscle,
      whole_food_type: item?.whole_food_type,
      serving_size: item?.serving_size ? Number(item?.serving_size) : null,
      prep_time: item?.prep_time ? Number(item?.prep_time) : null,
      kid_approved:
        item?.kid_approved === 'true' || item?.kid_approved === true,
      no_weekend_prep:
        item?.no_weekend_prep === 'true' || item?.no_weekend_prep === true,
      recipe_tips: item?.recipe_tips,
      prep: item?.prep,
    }));

    const result = await Recipe.insertMany(data);
    return result;
  } catch (error: any) {
    throw new ApiError(400, `Error Creating Recipes: ${error.message}`);
  }
};

export const DashboardService = {
  totalCount,
  getAllUser,
  createSubscriptions,
  updateSubscription,
  deleteSubscription,
  getAllRecipes,
  createRecipes,
  updateRecipes,
  deleteRecipe,
  getMyRecipes,
  getRecipeDetails,
  getRecipesForYou,
  addsInsertIntoDB,
  allAdds,
  updateAdds,
  deleteAdds,
  addFaq,
  updateFaq,
  deleteFaq,
  getFaq,
  addTermsConditions,
  getTermsConditions,
  addPrivacyPolicy,
  getPrivacyPolicy,
  sendMessageSupport,
  getAllMessagesSupport,
  getMonthlySubscriptionGrowth,
  getMonthlyUserGrowth,
  addRemoveFavorites,
  getUserFavorites,
  createReviews,
  getRecipesReview,
  postScoreReview,
  updateAddRecipes,
};
