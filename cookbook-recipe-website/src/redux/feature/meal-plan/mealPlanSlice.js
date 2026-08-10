import { createSlice } from "@reduxjs/toolkit";

const initialState = {
    weeklyDropDown : [],
    featuredDropDown : [],
    customDropDown : [],
};

const mealPlanSlice = createSlice({
    name: "mealPlan",
    initialState,
    reducers: {
        SetWeeklyDropDown: (state, action) => {
            state.weeklyDropDown = action.payload;
        },
        SetFeaturedDropDown: (state, action) => {
            state.featuredDropDown = action.payload;
        },
        SetCustomDropDown: (state, action) => {
            state.customDropDown = action.payload;
        },
    },
});

export const { SetWeeklyDropDown, SetFeaturedDropDown, SetCustomDropDown } = mealPlanSlice.actions;
export const mealPlanSliceReducer = mealPlanSlice.reducer;