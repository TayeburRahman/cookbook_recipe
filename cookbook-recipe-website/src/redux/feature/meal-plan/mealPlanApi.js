import { baseApi } from "../baseApi"
import { SetCustomDropDown, SetFeaturedDropDown, SetWeeklyDropDown } from "./mealPlanSlice"

const mealPlanApi = baseApi.injectEndpoints({
    endpoints: (builder) => ({

        // GET WEEKLY MEAL PLAN
        getWeeklyMealPlan: builder.query({
            query: (args) => {
                const params = new URLSearchParams();
                if (args) {
                    Object.entries(args).forEach(([key, value]) => {
                        if (value) {
                            params.append(key, value);
                        }
                    });
                }
                return {
                    url: "/meal_plan/get_weekly_plane",
                    method: "GET",
                    params,
                }
            },
            onQueryStarted: async (args, { dispatch, queryFulfilled }) => {
                try {
                    const { data } = await queryFulfilled;
                    dispatch(SetWeeklyDropDown(
                        data?.data?.plans?.map((plan) => ({
                            _id: plan._id,
                            value: plan.types,
                            label: plan.week_name,
                        }))
                    ));
                } catch (error) {
                    console.log(error);
                }
            },
            providesTags: ["MEAL_PLAN", "GROCERY"],
        }),

        // GET FEATURED MEAL PLAN
        getFeaturedMealPlan: builder.query({
            query: (args) => {
                const params = new URLSearchParams();
                if (args) {
                    Object.entries(args).forEach(([key, value]) => {
                        if (value) {
                            params.append(key, value);
                        }
                    });
                }
                return {
                    url: "/meal_plan/get_featured_plane",
                    method: "GET",
                    params,
                }
            },
            onQueryStarted: async (args, { dispatch, queryFulfilled }) => {
                try {
                    const { data } = await queryFulfilled;
                    dispatch(SetFeaturedDropDown(
                        data?.data?.map((plan) => ({
                            _id: plan._id,
                            value: plan.types,
                            label: plan.name,
                        }))
                    ));
                } catch (error) {
                    console.log(error);
                }
            },
            providesTags: ["MEAL_PLAN", "GROCERY"],
        }),

        // GET CUSTOM MEAL PLAN
        getCustomMealPlan: builder.query({
            query: (args) => {
                const params = new URLSearchParams();
                if (args) {
                    Object.entries(args).forEach(([key, value]) => {
                        if (value) {
                            params.append(key, value);
                        }
                    });
                }
                return {
                    url: "/meal_plan/get_custom_plane",
                    method: "GET",
                    params,
                }
            },
            onQueryStarted: async (args, { dispatch, queryFulfilled }) => {
                try {
                    const { data } = await queryFulfilled;
                    dispatch(SetCustomDropDown(
                        data?.data?.map((plan) => ({
                            _id: plan._id,
                            value: plan.types,
                            label: plan.name,
                        }))
                    ));
                } catch (error) {
                    console.log(error);
                }
            },
            providesTags: ["MEAL_PLAN", "GROCERY"],
        }),

        // GET MEAL PLAN DETAILS
        getMealPlanDetails: builder.query({
            query: (id) => ({
                url: `/meal_plan/get_mealPlan_details/${id}`,
                method: "GET",
            }),
            providesTags: ["MEAL_PLAN", "GROCERY"],
        }),

        //===========================END GET QUERY============================================

        //===========================START MUTATION============================================

        // ADD MEAL PLAN RECIPES
        addMealPlanRecipes: builder.mutation({
            query: (args) => {
                const params = new URLSearchParams();
                if (args) {
                    Object.entries(args).forEach(([key, value]) => {
                        if (value) {
                            params.append(key, value);
                        }
                    });
                }
                return {
                    url: "/meal_plan/add_recipes",
                    method: "POST",
                    params,
                }
            },
            invalidatesTags: ["MEAL_PLAN", "GROCERY"],
        }),

        // SWAP MEAL PLAN RECIPES
        swapRecipe: builder.mutation({
            query: (args) => {
                const params = new URLSearchParams();
                if (args) {
                    Object.entries(args).forEach(([key, value]) => {
                        if (value) {
                            params.append(key, value);
                        }
                    });
                }
                return {
                    url: "/meal_plan/swap_plane_recipe",
                    method: "PATCH",
                    params,
                }
            },
            invalidatesTags: ["MEAL_PLAN", "GROCERY"],
        }),

        // REMOVE MEAL PLAN RECIPES
        removeRecipe: builder.mutation({
            query: (args) => {
                const params = new URLSearchParams();
                if (args) {
                    Object.entries(args).forEach(([key, value]) => {
                        if (value) {
                            params.append(key, value);
                        }
                    });
                }
                return {
                    url: "/meal_plan/remove_plan_recipes",
                    method: "DELETE",
                    params,
                }
            },
            invalidatesTags: ["MEAL_PLAN", "GROCERY"],
        }),

        // CREATE CUSTOM MEAL PLAN
        createCustomMealPlan: builder.mutation({
            query: (data) => ({
                url: "/meal_plan/create_custom_plane",
                method: "POST",
                body: data
            }),
            invalidatesTags: ["MEAL_PLAN", "GROCERY"],
        }),

        // DELETE CUSTOM MEAL PLAN
        deleteCustomMealPlan: builder.mutation({
            query: (id) => ({
                url: `/meal_plan/delete_custom_plane/${id}`,
                method: "DELETE",
            }),
            invalidatesTags: ["MEAL_PLAN", "GROCERY"],
        }),

    })
})

export const {
    useGetWeeklyMealPlanQuery,
    useGetFeaturedMealPlanQuery,
    useGetCustomMealPlanQuery,
    useGetMealPlanDetailsQuery,
    useAddMealPlanRecipesMutation,
    useCreateCustomMealPlanMutation,
    useSwapRecipeMutation,
    useRemoveRecipeMutation,
    useDeleteCustomMealPlanMutation
} = mealPlanApi