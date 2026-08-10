import { baseApi } from "../baseApi"

const homeApi = baseApi.injectEndpoints({
    endpoints: (builder) => ({

        // GET FEATURED RECIPES
        getFeaturedRecipes: builder.query({
            query: () => ({
                url: "/dashboard/get_all_recipe",
                method: "GET",
            }),
            providesTags: ["FEATURED"],
        }),

        // GET RECIPE BY CATEGORY
        getRecipeByCategory: builder.query({
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
                    url: "/dashboard/get_all_recipe",
                    method: "GET",
                    params,
                }
            },
            providesTags: ["RECIPE"],
        }),

        // GET RECIPE BY FITNESS GOAL
        getRecipeByFitnessGoal: builder.query({
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
                    url: "/dashboard/get_all_recipe",
                    method: "GET",
                    params,
                }
            },
            providesTags: ["RECIPE"],
        }),
    })
})

export const { 
    useGetFeaturedRecipesQuery, 
    useGetRecipeByCategoryQuery, 
    useGetRecipeByFitnessGoalQuery 
} = homeApi

