import { Types } from "mongoose";
import QueryBuilder from "../../../builder/QueryBuilder";
import ApiError from "../../../errors/ApiError";
import { IReqUser } from "../auth/auth.interface";
import User from "../user/user.model";
import { Recipe, Subscription } from "./dashboard.model";
import { IRecipe, ISubscriptions } from "./dsashbaord.interface";
import { IUser } from "../user/user.interface";

const getAllUser = async (query: any) => {
    const { page, limit, searchTerm } = query;

    if (query?.searchTerm) {
        delete query.page;
    }
    const userQuery = new QueryBuilder(User.find()
        , query)
        .search(["name", "email"])
        .filter()
        .sort()
        .paginate()
        .fields()

    const result = await userQuery.modelQuery;
    const meta = await userQuery.countTotal();

    console.log(result)

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

const updateSubscription = async (id: string, payload: Partial<ISubscriptions>) => {
    try {
        const updatedSubscription = await Subscription.findByIdAndUpdate(id, payload, { new: true });
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
const getAllRecipes = async (query: any, payload: any) => {
    const { page, limit, searchTerm } = query;
    const { prep_time_start, prep_time_end, serving_size_start, serving_size_end } = payload;

    // console.log(prep_time_start, prep_time_end, serving_size_start, serving_size_end)

    if (query?.searchTerm) {
        delete query.page;
    }

    let filterQuery: any = {};
    if (prep_time_start && prep_time_end) {
        filterQuery.prep_time = { $gte: Number(prep_time_start), $lte: Number(prep_time_end) };
    }

    if (serving_size_start && serving_size_end) {
        filterQuery.serving_size = { $gte: Number(serving_size_start), $lte: Number(serving_size_end) };
    }

    const userQuery = new QueryBuilder(Recipe.find(filterQuery)
        , query)
        .search(["name", "category"])
        .filter()
        .sort()
        .paginate()
        .fields()

    const result = await userQuery.modelQuery;
    const meta = await userQuery.countTotal();

    console.log(result)

    return { result, meta };

};

const createRecipes = async (payload: IRecipe, user: IReqUser) => {
    try {
        const authId = user.authId as any;
        if (!authId) {
            throw new ApiError(404, 'User login unauthorized!');
        }
        payload.creator = authId;
        const recipe = new Recipe(payload);
        await recipe.save();
        return recipe;
    } catch (error: any) {
        throw new ApiError(400, `Error creating subscription: ${error.message}`);
    }
};

const updateRecipes = async (id: string, payload: Partial<ISubscriptions>) => {
    try {
        const updatedRecipe = await Recipe.findByIdAndUpdate(id, payload, { new: true });
        if (!updatedRecipe) {
            throw new ApiError(404, 'Subscription not found');
        }
        return updatedRecipe
    } catch (error: any) {
        throw new ApiError(400, `Error updating subscription: ${error.message}`);
    }
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
    const result = await Recipe.find({ creator: authId });
    return result;
};

const getRecipeDetails = async (id: Types.ObjectId) => {
    const result = await Recipe.findById(id);
    if (!result) {
        throw new ApiError(404, "Not find recipe!")
    }
    return result;
};


export const DashbaordService = {
    getAllUser,
    createSubscriptions,
    updateSubscription,
    deleteSubscription,
    getAllRecipes,
    createRecipes,
    updateRecipes,
    deleteRecipe,
    getMyRecipes,
    getRecipeDetails
};