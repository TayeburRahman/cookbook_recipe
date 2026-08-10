import { baseApi } from "../baseApi";

const groceryApi = baseApi.injectEndpoints({
    endpoints: (builder) => ({

        // GET GROCERY LIST
        getGroceryList: builder.query({
            query: (id) => ({
                url: `/meal_plan/get_grocery_list/${id}`,
                method: "GET",
            }),
            providesTags: ["GROCERY"],
        }),

        // TOGGLE INGREDIENT BY STATUS
        toggleIngredient: builder.mutation({
            query: (id) => ({
                url: `/meal_plan/toggle_ingredient_buy_status/${id}`,
                method: "PATCH",
            }),
            invalidatesTags: ["GROCERY"],
        }),
    })
})

export const { useGetGroceryListQuery, useToggleIngredientMutation } = groceryApi