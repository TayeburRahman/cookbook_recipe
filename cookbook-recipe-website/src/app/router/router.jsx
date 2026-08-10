import { lazy } from "react";
import { createBrowserRouter } from "react-router-dom";
import MainLayout from "../layout/MainLayout";
import AuthLayout from "../layout/AuthLayout";
import Profilelayout from "../layout/Profilelayout";
import RecipeDetailsSkeleton from "@/components/skeleton/recipe-details/RecipeDetailsSkeleton";
import CategoryPageSkeleton from "@/components/skeleton/category/CategoryPageSkeleton";
import LegalSkeleton from "@/components/skeleton/legal/LegalSkeleton";
import ContactPageSkeleton from "@/components/skeleton/legal/ContactPageSkeleton";
import RecipeCardSkeleton from "@/components/skeleton/recipe/RecipeCardSkeleton";
import { ErrorAndSuspense } from "@/tools/ErrorAndSuspense";
import ProfileSkeleton from "@/components/skeleton/profile/ProfileSkeleton";

const AddRecipe = lazy(() => import("../pages/profile-route/add-recipe/AddRecipe"));
const EditRecipe = lazy(() => import("../pages/profile-route/my-recipe/edit-recipe/EditRecipe"));
const Faq = lazy(() => import("../pages/main-route/legal-pages/faq/Faq"));
const Help = lazy(() => import("../pages/main-route/legal-pages/help/Help"));
const Privacy = lazy(() => import("../pages/main-route/legal-pages/privacy/Privacy"));
const Terms = lazy(() => import("../pages/main-route/legal-pages/terms/Terms"));
const Favorite = lazy(() => import("../pages/profile-route/my-favorite/MyFavorite"));
const MyRecipe = lazy(() => import("../pages/profile-route/my-recipe/MyRecipe"));
const MyAccount = lazy(() => import("../pages/profile-route/my-account/MyAccount"));
const Home = lazy(() => import("../pages/main-route/home/Home"));
const Recipes = lazy(() => import("../pages/main-route/recipes/Recipes"));
const RecipeDetails = lazy(() => import("../pages/main-route/recipes/recipe-details/RecipeDetails"));
const MealPlanner = lazy(() => import("../pages/main-route/meal-planner/MealPlanner"));
const Grocery = lazy(() => import("../pages/main-route/grocery/Grocery"));
const Featured = lazy(() => import("../pages/main-route/featured/Featured"));
const About = lazy(() => import("../pages/main-route/about/About"));
const Contact = lazy(() => import("../pages/main-route/contact/Contact"));
const Login = lazy(() => import("../pages/auth-route/login/Login"));
const Register = lazy(() => import("../pages/auth-route/register/Register"));
const ForgetPassword = lazy(() => import("../pages/auth-route/forgot-password/ForgetPassword"));
const VerifyOtp = lazy(() => import("../pages/auth-route/verify-otp/VerifyOtp"));
const ResetPassword = lazy(() => import("../pages/auth-route/reset-password/ResetPassword"));
const Category = lazy(() => import("../pages/main-route/category/Category"));
const DiatGoals = lazy(() => import("../pages/main-route/diat-gols/DiatGoals"));
const router = createBrowserRouter([
    {
        path: "/",
        element: <MainLayout />,
        children: [
            {
                index: true,
                element: <Home />,
            },
            {
                path: "recipes",
                element: ErrorAndSuspense(Recipes, <CategoryPageSkeleton />),
            },
            {
                path: "category/:slug",
                element: ErrorAndSuspense(Category, <CategoryPageSkeleton />),
            },
            {
                path: "diet-goals/:slug",
                element: ErrorAndSuspense(DiatGoals, <CategoryPageSkeleton />),
            },
            {
                path: "recipes/recipe-details/:id",
                element: ErrorAndSuspense(RecipeDetails, <RecipeDetailsSkeleton />),
            },
            {
                path: "meal-planner",
                element: ErrorAndSuspense(MealPlanner, <div>Loading...</div>),
            },
            {
                path: "grocery",
                element: ErrorAndSuspense(Grocery, <div>Loading...</div>),
            },
            {
                path: "featured",
                element: ErrorAndSuspense(Featured, <Featured />),
            },
            {
                path: "about",
                element: ErrorAndSuspense(About, <LegalSkeleton />),
            },
            {
                path: "contact",
                element: ErrorAndSuspense(Contact, <ContactPageSkeleton />),
            },
            {
                path: "legal/help",
                element: ErrorAndSuspense(Help, <LegalSkeleton />),
            },
            {
                path: "legal/faq",
                element: ErrorAndSuspense(Faq, <LegalSkeleton />),
            },
            {
                path: "legal/privacy",
                element: ErrorAndSuspense(Privacy, <LegalSkeleton />),
            },
            {
                path: "legal/terms",
                element: ErrorAndSuspense(Terms, <LegalSkeleton />),
            },
            {
                path: "profile",
                element: ErrorAndSuspense(Profilelayout, <div>Loading...</div>),
                children: [
                    {
                        index: true,
                        element: ErrorAndSuspense(MyAccount, <ProfileSkeleton />),
                    },
                    {
                        path: "my-favourite",
                        element: ErrorAndSuspense(Favorite, <div className="grid gap-6 grid-cols-1"><RecipeCardSkeleton count={3} /></div>),
                    },
                    {
                        path: "my-recipes",
                        element: ErrorAndSuspense(MyRecipe, <div className="grid gap-6 grid-cols-1"><RecipeCardSkeleton count={3} /></div>),
                    },
                    {
                        path: "add-recipe",
                        element: ErrorAndSuspense(AddRecipe, <AddRecipe/>),
                    },
                    {
                        path: "edit-recipe/:id",
                        element: ErrorAndSuspense(EditRecipe, <EditRecipe />),
                    },
                ]
            },
        ]
    },
    {
        path: "/auth",
        element: <AuthLayout />,
        children: [
            {
                path: "login",
                element: <Login />,
            },
            {
                path: "register",
                element: <Register />,
            },
            {
                path: "forgot-password",
                element: <ForgetPassword />,
            },
            {
                path: "verify-otp",
                element: <VerifyOtp />,
            },
            {
                path: "reset-password",
                element: <ResetPassword />,
            },
        ]
    }
])

export default router;