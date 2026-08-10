import { createSlice } from "@reduxjs/toolkit";

const initialState = {
    accessToken: typeof window !== "undefined" ? localStorage.getItem("accessToken") : null,
    warningModal: typeof window !== "undefined" ? sessionStorage.getItem("showWarningModal") === "true" : false
};

const authSlice = createSlice({
    name: "auth",
    initialState,
    reducers: {
        SetAccessToken: (state, action) => {
            state.accessToken = action.payload;
            if (action.payload) {
                localStorage.setItem("accessToken", action.payload);
            } else {
                localStorage.removeItem("accessToken");
            }
        },
        Logout: (state) => {
            state.accessToken = null;
            localStorage.removeItem("accessToken");
        },
        SetWarningModal: (state, action) => {
            state.warningModal = action.payload;
        },
    },
});

export const { SetAccessToken, Logout, SetWarningModal } = authSlice.actions;
export const authSliceReducer = authSlice.reducer;
