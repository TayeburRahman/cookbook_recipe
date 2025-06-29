import ApiError from "../../../errors/ApiError";
import { IReqUser } from "../auth/auth.interface";
import { Recipe } from "../dashboard/dashboard.model";
import { MealPlanWeek } from "./mealplan.model";
import { NotificationService } from "./notification.service";

const getWeekDates = (currentDate: Date) => {
    const currentDayOfWeek = currentDate.getDay();
    const sundayDate = new Date(currentDate);
    sundayDate.setDate(currentDate.getDate() - currentDayOfWeek); // Go back to the previous Sunday

    // Start and end of this week (Sunday to Saturday)
    const startDateThisWeek = new Date(sundayDate);
    const endDateThisWeek = new Date(sundayDate);
    endDateThisWeek.setDate(sundayDate.getDate() + 6); // Saturday of this week

    // Start and end of next week (Sunday to Saturday)
    const startDateNextWeek = new Date(endDateThisWeek);
    startDateNextWeek.setDate(endDateThisWeek.getDate() + 1); // Next Sunday
    const endDateNextWeek = new Date(startDateNextWeek);
    endDateNextWeek.setDate(startDateNextWeek.getDate() + 6); // Saturday of next week

    return { startDateThisWeek, endDateThisWeek, startDateNextWeek, endDateNextWeek };
};

const createUpcomingWeekPlan = async (authId: any) => {
    const { startDateNextWeek, endDateNextWeek } = getWeekDates(new Date());

    const daysData = [
        { day: "Day-1", recipes: [] },
        { day: "Day-2", recipes: [] },
        { day: "Day-3", recipes: [] },
        { day: "Day-4", recipes: [] },
        { day: "Day-5", recipes: [] },
        { day: "Day-6", recipes: [] },
        { day: "Day-7", recipes: [] },
    ];

    const newPlan = {
        types: 'week',
        user: authId,
        startDate: startDateNextWeek,
        endDate: endDateNextWeek,
        data: daysData,
    };

    await MealPlanWeek.create(newPlan);

    await NotificationService.sendNotification({
        title: "Your Upcoming Meal Plan is Ready!",
        message: "We've created your meal plan for the upcoming week. You can view and customize it anytime.",
        user: authId
    });

};

const activateAccountCreateDefaultPlane = async (authId: any) => {
    try {
        if (!authId) {
            console.error('Auth id is required.');
            return { status: false };
        }

        const daysData = [
            { day: "Day-1", recipes: [] },
            { day: "Day-2", recipes: [] },
            { day: "Day-3", recipes: [] },
            { day: "Day-4", recipes: [] },
            { day: "Day-5", recipes: [] },
            { day: "Day-6", recipes: [] },
            { day: "Day-7", recipes: [] },
        ];

        const currentDate = new Date();
        const { startDateThisWeek, endDateThisWeek, startDateNextWeek, endDateNextWeek } = getWeekDates(currentDate);

        const mealPlans = [
            {
                name: 'simple_starter_plan',
                types: 'featured',
                user: authId,
                data: daysData,
            },
            {
                name: 'plant_based_on_a_budget_3_a_meal',
                types: 'featured',
                user: authId,
                data: daysData,
            },
            {
                name: 'plant_based_on_a_budget_3_a_meal_weekend_only',
                types: 'featured',
                user: authId,
                data: daysData,
            },
            {
                types: 'week',
                user: authId,
                startDate: startDateThisWeek,
                endDate: endDateThisWeek,
                data: daysData,
            },
            {
                types: 'week',
                user: authId,
                startDate: startDateNextWeek,
                endDate: endDateNextWeek,
                data: daysData,
            },
        ];

        const resultFeatured = await MealPlanWeek.insertMany(mealPlans);
        if (!resultFeatured) {
            return { status: false };
        }


        return { status: true };
    } catch (error) {
        console.error('Error creating meal plans for weeks:', error);
        return { status: false };
    }
};

const createCustomPlane = async (user: IReqUser, payload: { name: string }) => {
    try {
        const { authId, userId } = user;

        if (!authId) {
            throw new ApiError(400, 'Your not authorize!');
        }

        if (!payload?.name) {
            throw new ApiError(400, 'Name is required!');
        }

        const daysData = [
            { day: "Day-1", recipes: [] },
            { day: "Day-2", recipes: [] },
            { day: "Day-3", recipes: [] },
            { day: "Day-4", recipes: [] },
            { day: "Day-5", recipes: [] },
            { day: "Day-6", recipes: [] },
            { day: "Day-7", recipes: [] },
        ];

        const mealPlans = {
            name: payload.name,
            types: 'custom',
            user: authId,
            data: daysData,
        }

        const resultFeatured = await MealPlanWeek.create(mealPlans);

        return resultFeatured;
    } catch (error) {
        console.error('Error creating meal plans for weeks:', error);
        throw new ApiError(400, 'Error creating meal plans for weeks');
    }
};

const addPlaneRecipes = async (query: {
    planId: string;
    day: string;
    recipeId: string;
}, user: IReqUser) => {
    const recipe = await Recipe.findById(query.recipeId);
    if (!recipe) {
        throw new ApiError(404, 'Recipe not found!');
    }

    const plan = await MealPlanWeek.findById(query.planId);
    if (!plan) {
        throw new ApiError(404, 'Meal Plan not found!');
    }

    const dayData = plan.data.find(d => d.day === query.day);
    if (!dayData) {
        throw new ApiError(404, 'Specified day not found in meal plan!');
    }

    const formattedIngredients = recipe?.ingredients?.map(ingredient => ({
        ingredient,
        buy: false,
    }));

    dayData.recipes.push({
        // @ts-ignore
        recipe: recipe._id,
        ingredients: formattedIngredients,
    });


    await plan.save();

    return { success: true, message: 'Recipe added successfully!' };
};

const getMealPlanById = async (id: string) => {
    if (!id) {
        throw new ApiError(400, 'Invalid Meal Plan ID');
    }

    const plan = await MealPlanWeek.findById(id)
        .populate({
            path: 'data.recipes.recipe',
            select: 'name duration nutritional category image meal_type temperature ratting time prep',
        })
        .lean();

    if (!plan) {
        throw new ApiError(404, 'Meal Plan not found!');
    }

    // @ts-ignore
    plan.data = plan.data.map(day => ({
        ...day,
        // @ts-ignore
        recipes: day.recipes.map(({ ingredients, ...rest }) => rest),
    }));

    return plan;
};

const getCustomMealPlan = async (user: IReqUser) => {
    const { authId, userId } = user;
    const plan = await MealPlanWeek.find({ user: authId, types: 'custom' })
        .select('-data')
    return plan;
};

const getFeaturedMealPlan = async (user: IReqUser) => {
    const { authId, userId } = user;
    const plan = await MealPlanWeek.find({ user: authId, types: 'featured' })
        .select('-data')
    return plan;
};

const getWeekStartDate = (date: Date) => {
    const day = date.getDay();
    const sunday = new Date(date);
    sunday.setHours(0, 0, 0, 0);
    sunday.setDate(date.getDate() - day);
    return sunday;
};

const normalizeDate = (date: Date) => {
    return new Date(date.getFullYear(), date.getMonth(), date.getDate());
};

const getWeeklyMealPlan = async (user: IReqUser) => {
    const { authId } = user;
    const currentDate = new Date();
    const { startDateNextWeek, startDateThisWeek } = getWeekDates(currentDate);
    const currentWeekStart = startDateThisWeek;

    const normalizedNextWeekStart = normalizeDate(startDateNextWeek);

    try {
        let plans = await MealPlanWeek.find({ user: authId, types: 'week' }).lean();

        const hasUpcomingWeek = plans.some(plan => {
            const planStartNormalized = normalizeDate(new Date(plan.startDate));
            return planStartNormalized.getTime() === normalizedNextWeekStart.getTime();
        });

        if (!hasUpcomingWeek) {
            await createUpcomingWeekPlan(authId);
            plans = await MealPlanWeek.find({ user: authId, types: 'week' }).lean();
        }

        const enrichedPlans = plans.map(plan => {
            const planStart = getWeekStartDate(new Date(plan.startDate));
            const diffInMs = currentWeekStart.getTime() - planStart.getTime();
            const diffInWeeks = Math.floor(diffInMs / (7 * 24 * 60 * 60 * 1000));

            let week_name = '';
            if (diffInWeeks === 0) {
                week_name = 'This week';
            } else if (diffInWeeks === -1) {
                week_name = 'Upcoming week';
            } else if (diffInWeeks > 0) {
                week_name = `${diffInWeeks + 1}th week`;
            } else {
                week_name = `Future week (${Math.abs(diffInWeeks) - 1} weeks ahead)`;
            }

            // @ts-ignore
            delete plan.data;

            return { ...plan, week_name };
        });

        return { status: true, plans: enrichedPlans.reverse() };
    } catch (error) {
        console.error('Error fetching or creating weekly meal plans:', error);
        return { status: false, message: 'Error fetching plans' };
    }
};

const deleteCustomMealPlan = async (id: string) => {

    if (!id) {
        throw new ApiError(404, "ID is undefined!")
    }

    const plan = await MealPlanWeek.findById(id)

    if (plan?.types !== "custom") {
        throw new ApiError(400, "The plane must should be 'custom'!")
    }

    const result = await MealPlanWeek.findByIdAndDelete(id)
    return result;
};

const swapPlanRecipes = async (query: {
    removeId: string;
    newId: string;
    day: string;
    planId: string;
}) => {
    const { removeId, newId, day, planId } = query;

    if (!removeId || !newId || !day || !planId) {
        throw new ApiError(400, "All query filed are required!")
    }

    try {
        const plan = await MealPlanWeek.findById(planId);

        if (!plan) {
            throw new ApiError(400, 'Meal plan not found');
        }

        const newRecipes = await Recipe.findById(newId);

        if (!newRecipes) {
            throw new ApiError(400, 'New recipe plan not found!');
        }

        const targetDay = plan.data.find(d => d.day === day);

        if (!targetDay) {
            throw new ApiError(400, `Day '${day}' not found in the plan`);
        }

        const recipeIndex = targetDay.recipes.findIndex(r =>
            //@ts-ignore
            r.recipe.toString() === removeId
        );

        if (recipeIndex === -1) {
            throw new Error('Recipe to remove not found');
        }

        //@ts-ignore
        targetDay?.recipes[recipeIndex].recipe = newId;

        //@ts-ignore
        targetDay.recipes[recipeIndex].ingredients = newRecipes?.ingredients?.map(ingredient => ({
            ingredient,
            buy: false
        }));

        await plan.save();

        return plan;

    } catch (error: any) {
        return {
            success: false,
            message: error.message || 'Something went wrong',
        };
    }
};

const removePlanRecipes = async (
    query: {
        removeId: string;
        day: string;
        planId: string;
    }
) => {
    const { removeId, day, planId } = query;
    if (!removeId || !day || !planId) {
        throw new ApiError(400, "All query fields are required!");
    }
    try {
        const plan = await MealPlanWeek.findById(planId);
        if (!plan) {
            throw new ApiError(404, "Meal plan not found");
        }

        const dayData = plan.data.find((d) => d.day === day);
        if (!dayData) {
            throw new ApiError(404, `Day "${day}" not found in the meal plan`);
        }
        const checkExist = dayData.recipes.filter(
            // @ts-ignore
            (recipe) => recipe.recipe?.toString() === removeId
        );
        console.log("========", checkExist)
        if (!checkExist.length) {
            throw new ApiError(404, "Already remove this recipe in this plan");
        }
        dayData.recipes = dayData.recipes.filter(
            // @ts-ignore
            (recipe) => recipe.recipe?.toString() !== removeId
        );

        await plan.save();
        return plan;
    } catch (error: any) {
        return {
            success: false,
            message: error.message || "Something went wrong",
        };
    }
};

const getGroceryList = async (id: string) => {
    if (!id) {
        throw new ApiError(400, 'Invalid Meal Plan ID');
    }

    const plan = await MealPlanWeek.findById(id)
        .populate({
            path: 'data.recipes.recipe',
            select: 'name image category',
        })
        .select("user data")
        .lean();

    if (!plan) {
        throw new ApiError(404, 'Meal Plan not found!');
    }

    return plan;
};

const toggleIngredientBuyStatus = async (ingredientId: string) => {
    if (!ingredientId) {
        throw new ApiError(400, 'Invalid Ingredient ID');
    }

    const plan = await MealPlanWeek.findOne({ 'data.recipes.ingredients._id': ingredientId });

    if (!plan) {
        throw new ApiError(404, 'Meal Plan containing this ingredient was not found');
    }

    let updated = false;

    for (const day of plan.data) {
        for (const recipe of day.recipes) {
            // @ts-ignore
            for (const ingredient of recipe.ingredients) {
                if (ingredient._id.toString() === ingredientId) {
                    ingredient.buy = !ingredient.buy;
                    updated = true;
                    break;
                }
            }
            if (updated) break;
        }
        if (updated) break;
    }

    if (updated) {
        await plan.save();
        return { message: 'Buy status update successfully' };
    } else {
        throw new ApiError(404, 'Ingredient not found in any recipe');
    }
};

export const MealService = {
    addPlaneRecipes,
    activateAccountCreateDefaultPlane,
    getMealPlanById,
    createCustomPlane,
    getCustomMealPlan,
    getFeaturedMealPlan,
    deleteCustomMealPlan,
    swapPlanRecipes,
    removePlanRecipes,
    getWeeklyMealPlan,
    getGroceryList,
    toggleIngredientBuyStatus
};
