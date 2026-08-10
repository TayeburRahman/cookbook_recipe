import { createSlice } from "@reduxjs/toolkit";

const initialState = {
    userProfile: null,
    favoriteRecipes: null,
}

const profileSlice = createSlice({
    name: "profile",
    initialState,
    reducers: {
        SetUserProfile: (state, action) => {
            state.userProfile = action.payload;
        },

        SetFavoriteRecipes: (state, action) => {
            state.favoriteRecipes = action.payload;
        },
    },
})

export const { SetUserProfile, SetFavoriteRecipes } = profileSlice.actions;
export const profileSliceReducer = profileSlice.reducer;
