import { ErrorToast, SuccessToast } from "@/lib/utils";
import { SetAccessToken } from "../auth/authSlice";
import { baseApi } from "../baseApi";
import { jwtDecode } from "jwt-decode";

const authApi = baseApi.injectEndpoints({
    endpoints: (builder) => ({
        
        // Login Endpoint (Mutation) 
        login: builder.mutation({
            query: (credentials) => ({
                url: "/auth/login",
                method: "POST",
                body: credentials,
            }),
            async onQueryStarted(arg, { dispatch, queryFulfilled }) {
                try {
                    const { data } = await queryFulfilled;
                    const accessToken = data?.data?.accessToken;
                    const user = data?.data?.user;

                    if (!accessToken || !user) {
                        ErrorToast("Invalid login response.");
                        return;
                    }

                    const decoded = jwtDecode(accessToken);
                    if (decoded?.role !== "USER") {
                        ErrorToast("You are not authorized to login.");
                        return;
                    }

                    // Set access token first
                    dispatch(SetAccessToken(accessToken));

                    // Check for incomplete profile
                    const relevantDielaryMissing = !user.relevant_dielary || user.relevant_dielary.length === 0;
                    const mailTypesMissing = !user.mail_types || user.mail_types.length === 0 || (user.mail_types.length === 1 && user.mail_types[0] === 'none');

                    if (relevantDielaryMissing || mailTypesMissing) {
                        window.location.href = "/profile";
                        sessionStorage.setItem("showWarningModal", "true");
                    } else {
                        SuccessToast("Login successful!");
                        window.location.href = "/";
                    }
                } catch (error) {
                    ErrorToast(error?.error?.data?.message || "Login failed.");
                }
            },
        }),

        // Register Endpoint (Mutation)
        register: builder.mutation({
            query: (credentials) => ({
                url: "/auth/register",
                method: "POST",
                body: credentials,
            }),
            async onQueryStarted({ email }, { queryFulfilled }) {
                try {
                    await queryFulfilled;
                    window.location.href = `/auth/verify-otp?type=signup&email=${encodeURIComponent(email)}`;
                    SuccessToast("Registration successful! Please check your email for OTP verification.");
                } catch (error) {
                    ErrorToast(error?.error?.data?.message || "Registration failed.");
                }
            },
        }),

        // FORGET PASSWORD
        forgetPassword: builder.mutation({
            query: (email) => {
                return {
                    url: '/auth/forgot-password',
                    method: 'POST',
                    body: email
                }
            },
            async onQueryStarted({ email }, { queryFulfilled }) {
                try {
                    await queryFulfilled;
                    SuccessToast("OTP sent successfully!");
                    window.location.href = `/auth/verify-otp?type=forget-password&email=${encodeURIComponent(email)}`;
                } catch (error) {
                    ErrorToast(error?.error?.data?.message || "Failed to send new OTP.");
                }
            }
        }),

        // OTP VERIFY FOR SIGNUP
        verifyOTPForSignup: builder.mutation({
            query: (data) => ({
                url: '/auth/activate-user',
                method: 'POST',
                body: data
            }),
            async onQueryStarted(arg, { queryFulfilled }) {
                try {
                    const { data } = await queryFulfilled;
                    SuccessToast(data?.message);
                } catch (error) {
                    ErrorToast(error?.error?.data?.message || "OTP verification failed.");
                }
            },
        }),

        // OTP VERIFY FOR RESET PASSWORD
        verifyOTPForResetPassword: builder.mutation({
            query: (data) => ({
                url: '/auth/verify-otp',
                method: 'POST',
                body: data
            }),
            async onQueryStarted(arg, { queryFulfilled }) {
                try {
                    const { data } = await queryFulfilled;
                    SuccessToast(data?.message);
                } catch (error) {
                    ErrorToast(error?.error?.data?.message || "OTP verification failed.");
                }
            },
        }),

        // RESEND SIGNUP OTP
        resendSignupOTP: builder.mutation({
            query: (email) => ({
                url: '/auth/active-resend',
                method: 'POST',
                body: email
            }),
            async onQueryStarted(arg, { queryFulfilled }) {
                try {
                    const { data } = await queryFulfilled;
                    SuccessToast(data?.message);
                } catch (error) {
                    ErrorToast(error?.error?.data?.message || "Failed to send new OTP.");
                }
            },
        }),

        // RESEND RESET OTP
        resendResetOTP: builder.mutation({
            query: (email) => ({
                url: '/auth/forgot-resend',
                method: 'POST',
                body: email
            }),
            async onQueryStarted(arg, { queryFulfilled }) {
                try {
                    const { data } = await queryFulfilled;
                    SuccessToast(data?.message);
                } catch (error) {
                    ErrorToast(error?.error?.data?.message || "Failed to send new OTP.");
                }
            },
        }),

        // RESET PASSWORD
        resetPassword: builder.mutation({
            query: ({ email, ...data }) => {
                return {
                    url: `/auth/reset-password?email=${email}`,
                    method: 'POST',
                    body: data,
                }
            },
            async onQueryStarted(arg, { queryFulfilled }) {
                try {
                    const { data } = await queryFulfilled;
                    SuccessToast(data?.message);
                    localStorage.removeItem("FPE");
                    window.location.href = "/auth/login";
                } catch (error) {
                    ErrorToast(error?.error?.data?.message || "Failed to reset password.");
                }
            }
        }),

        // CHANGE PASSWORD
        changePassword: builder.mutation({
            query: (data) => {
                return {
                    url: "/auth/change-password",
                    method: 'PATCH',
                    body: data
                }
            },
            async onQueryStarted(arg, { queryFulfilled }) {
                try {
                    const { data } = await queryFulfilled;
                    SuccessToast(data?.message);
                } catch (error) {
                    ErrorToast(error?.error?.data?.message || "Failed to change password.");
                }
            },
        }),

    })
})

export const {
    useRegisterMutation,
    useLoginMutation,
    useForgetPasswordMutation,
    useVerifyOTPForSignupMutation,
    useVerifyOTPForResetPasswordMutation,
    useResendResetOTPMutation,
    useResendSignupOTPMutation,
    useResetPasswordMutation,
    useChangePasswordMutation
} = authApi;