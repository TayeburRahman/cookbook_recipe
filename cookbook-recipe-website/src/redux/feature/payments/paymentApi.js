import { baseApi } from "../baseApi";

const paymentApi = baseApi.injectEndpoints({
    endpoints: (builder) => ({
        
        // GET SUBSCRIPTION PLANS
        getSubscriptionPlans: builder.query({
            query: () => ({
                url: "/dashboard/get_all_subscriptions",
                method: "GET",
            }),
            providesTags: ["SUBSCRIPTION"],
        }),

        // CREATE CHECKOUT SESSION
        createCheckoutSession: builder.mutation({
            query: (data) => ({
                url: "/payment/create_checkout_session",
                method: "POST",
                body: data
            }),
            invalidatesTags: ["SUBSCRIPTION"],
        }),
    })
})

export const { useGetSubscriptionPlansQuery, useCreateCheckoutSessionMutation } = paymentApi