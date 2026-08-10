
import { baseApi } from "../baseApi";

const legalApi = baseApi.injectEndpoints({
    endpoints: (builder) => ({

        // GET ABOUT
        getAbout: builder.query({
            query: () => ({
                url: "/dashboard/get-about",
                method: "GET",
            }),
            providesTags: ["LEGAL"],
        }),

        // GET TERMS
        getTerms: builder.query({
            query: () => ({
                url: "/dashboard/get-rules",
                method: "GET",
            }),
            providesTags: ["LEGAL"],
        }),

        // GET PRIVACY POLICY
        getPrivacyPolicy: builder.query({
            query: () => ({
                url: "/dashboard/get-privacy-policy",
                method: "GET",
            }),
            providesTags: ["LEGAL"],
        }),

        // GET CONTACT
        // getContact: builder.query({
        //     query: () => ({
        //         url: "/dashboard/get-contact",
        //         method: "GET",
        //     }),
        //     providesTags: ["LEGAL"],
        // }),

        // GET FAQ
        getFaq: builder.query({
            query: () => ({
                url: "/dashboard/get-faqs",
                method: "GET",
            }),
            providesTags: ["LEGAL"],
        }),

        // GET HELP
        getHelp: builder.query({
            query: () => ({
                url: "/dashboard/get-help",
                method: "GET",
            }),
            providesTags: ["LEGAL"],
        }),

        //======================================================================================================
        //====================================    MUTATION    ====================================================
        //======================================================================================================

        // SEND CONTACT
        sendMessage: builder.mutation({
            query: (data) => ({
                url: "/dashboard/send-message-support",
                method: "POST",
                body: data,
            }),
            invalidatesTags: ["LEGAL"],
        }),

        // SEND SUBSCRIBE
        sendSubscribe: builder.mutation({
            query: (data) => ({
                url: "/dashboard/send-subscribe-mail",
                method: "POST",
                body: data,
            }),
            invalidatesTags: ["LEGAL"],
        }),



        // // ADD ABOUT
        // addAbout: builder.mutation({
        //     query: (data) => ({
        //         url: "/manage/add-about-us",
        //         method: "POST",
        //         body: data,
        //     }),
        //     invalidatesTags: ["LEGAL"],
        // }),

        // // ADD TERMS
        // addTerms: builder.mutation({
        //     query: (data) => ({
        //         url: "/manage/add-terms-conditions",
        //         method: "POST",
        //         body: data,
        //     }),
        //     invalidatesTags: ["LEGAL"],
        // }),

        // // ADD PRIVACY POLICY
        // addPrivacyPolicy: builder.mutation({
        //     query: (data) => ({
        //         url: "/manage/add-privacy-policy",
        //         method: "POST",
        //         body: data,
        //     }),
        //     invalidatesTags: ["LEGAL"],
        // }),

        // // ADD CONTACT
        // addContact: builder.mutation({
        //     query: (data) => ({
        //         url: "/manage/add-contact",
        //         method: "POST",
        //         body: data,
        //     }),
        //     invalidatesTags: ["LEGAL"],
        // }),
    })
})

export const {
    useGetTermsQuery,
    useGetPrivacyPolicyQuery,
    useGetFaqQuery,
    useSendMessageMutation,
    useGetHelpQuery,
    useGetAboutQuery,
    useSendSubscribeMutation,
} = legalApi