// import { useEffect, useState } from "react";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import PageLayout from "@/tools/PageLayout";
import PageHeader from "@/components/common/page-header/PageHeader";
// import PlanTypeFilter from "@/components/meal-planner/PlanTypeFilter";
import { useSelector } from "react-redux";
import {
    useGetCustomMealPlanQuery,
    useGetFeaturedMealPlanQuery,
    useGetWeeklyMealPlanQuery
} from "@/redux/feature/meal-plan/mealPlanApi";
import { useGetGroceryListQuery } from "@/redux/feature/grocery/groceryApi";
import { Button } from "@/components/ui/button";
import GroceryRecipeCard from "@/components/grocery/GroceryRecipeCard";
import { useEffect, useRef } from "react";
import { InfoToast } from "@/lib/utils";
// import { SetPlanId } from "@/redux/feature/meal-plan/addMealPlanSlice";
// import { useDispatch } from "react-redux";
// import { useEffect, useState } from "react";
// import { SetPlanId } from "@/redux/feature/meal-plan/addMealPlanSlice";

const Grocery = () => {
    // const dispatch = useDispatch();
    useGetWeeklyMealPlanQuery()
    useGetFeaturedMealPlanQuery()
    useGetCustomMealPlanQuery()
    // const weekDropDown = useSelector((state) => state.mealPlan.weeklyDropDown);
    // const featuredDropDown = useSelector((state) => state.mealPlan.featuredDropDown);
    // const customDropDown = useSelector((state) => state.mealPlan.customDropDown);
    const { planId } = useSelector((state) => state.addMealPlan);

    // const [activeTab, setActiveTab] = useState("my-weeks");
    // const [selectedWeek, setSelectedWeek] = useState();
    // const [selectedPlan, setSelectedPlan] = useState();
    // const [selectedCustomPlan, setSelectedCustomPlan] = useState();

    const { data: groceryData, isLoading: isGroceryLoading } = useGetGroceryListQuery(planId, { skip: !planId });

    // useEffect(() => {
    //     if (activeTab === 'my-weeks') {
    //         dispatch(SetPlanId(selectedWeek?._id));
    //     } else if (activeTab === 'featured-plans') {
    //         dispatch(SetPlanId(selectedPlan?._id));
    //     } else if (activeTab === 'custom-plans') {
    //         dispatch(SetPlanId(selectedCustomPlan?._id));
    //     }
    // }, [activeTab, selectedWeek, selectedPlan, selectedCustomPlan, dispatch]);

    // useEffect(() => {
    //     if (weekDropDown && weekDropDown.length > 0 && !selectedWeek) {
    //         setSelectedWeek(weekDropDown[0]);
    //     }
    // }, [weekDropDown, selectedWeek]);

    // useEffect(() => {
    //     if (featuredDropDown && featuredDropDown.length > 0 && !selectedPlan) {
    //         setSelectedPlan(featuredDropDown[0]);
    //     }
    // }, [featuredDropDown, selectedPlan]);

    // useEffect(() => {
    //     if (customDropDown && customDropDown.length > 0 && !selectedCustomPlan) {
    //         setSelectedCustomPlan(customDropDown[0]);
    //     }
    // }, [customDropDown, selectedCustomPlan]);

    const recipesWithAllIngredients = groceryData?.data?.data.flatMap(day =>
        day.recipes
            .filter(r => r.ingredients && r.ingredients.length > 0)
            .map(r => ({
                id: r.recipe._id,
                image: r.recipe.image,
                title: r.recipe.name,
                subtitle: r.recipe.category,
                ingredients: r.ingredients
            }))
    );

    const aisleRecipes = recipesWithAllIngredients?.map(recipe => ({
        ...recipe,
        ingredients: recipe.ingredients.filter(i => !i.buy)
    })).filter(recipe => recipe.ingredients.length > 0);

    const recipeTabRecipes = recipesWithAllIngredients?.map(recipe => ({
        ...recipe,
        ingredients: recipe.ingredients.filter(i => i.buy)
    })).filter(recipe => recipe.ingredients.length > 0);


    const hasShownToast = useRef(false);
    useEffect(() => {
        if (!planId && !hasShownToast.current) {
            hasShownToast.current = true;
            InfoToast("Please select a plan from Meal Planner");
        }
    }, [planId]);

    const breadcrumbs = [
        { name: "Home", href: "/" },
        { name: "Grocery" },
    ];

    return (
        <>
            <PageHeader breadcrumbs={breadcrumbs} title="Grocery" />
            <PageLayout paddingSize="none">
                {/* <Tabs value={activeTab} onValueChange={setActiveTab}>
                    <div className="flex flex-col md:flex-row items-center justify-between gap-4">
                        <TabsList className="grid grid-cols-3">
                            <TabsTrigger value="my-weeks">My Weeks</TabsTrigger>
                            <TabsTrigger value="featured-plans">Featured Plans</TabsTrigger>
                            <TabsTrigger value="custom-plans">Custom Plans</TabsTrigger>
                        </TabsList>
                    </div>

                    <TabsContent value="my-weeks">
                        <div className="mt-4">
                            <PlanTypeFilter
                                title="Select Week"
                                items={weekDropDown || []}
                                value={selectedWeek}
                                onValueChange={setSelectedWeek}
                            />
                        </div>
                    </TabsContent>
                    <TabsContent value="featured-plans">
                        <div className="mt-4">
                            <PlanTypeFilter
                                title="Select Featured Plan"
                                items={featuredDropDown || []}
                                value={selectedPlan}
                                onValueChange={setSelectedPlan}
                            />
                        </div>
                    </TabsContent>
                    <TabsContent value="custom-plans">
                        <div className="flex items-center gap-4 mt-4">
                            <PlanTypeFilter
                                title="Select Custom Plan"
                                items={customDropDown || []}
                                value={selectedCustomPlan}
                                onValueChange={setSelectedCustomPlan}
                            />
                        </div>
                    </TabsContent>
                </Tabs> */}

                <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    {/* Left Section */}
                    <div className="md:col-span-2">
                        <Tabs defaultValue="aisle" className="w-full">
                            <TabsList className="mb-6 w-full">
                                <TabsTrigger
                                    value="aisle"
                                    className="w-full px-4 py-2 text-sm rounded-md data-[state=active]:bg-primary data-[state=active]:text-primary-foreground"
                                >
                                    By AISLE
                                </TabsTrigger>
                                <TabsTrigger
                                    value="recipe"
                                    className="w-full px-4 py-2 text-sm rounded-md data-[state=active]:bg-primary data-[state=active]:text-primary-foreground"
                                >
                                    By RECIPE
                                </TabsTrigger>
                            </TabsList>

                            <TabsContent value="aisle" className="space-y-8">
                                {isGroceryLoading ? <div>Loading...</div> : aisleRecipes?.length > 0 ? aisleRecipes.map((recipe) => (
                                    <GroceryRecipeCard
                                        key={`aisle-${recipe.id}`}
                                        image={recipe.image}
                                        title={recipe.title}
                                        subtitle={recipe.subtitle}
                                        ingredients={recipe.ingredients}
                                    />
                                )) : <div>No recipes found for this plan.</div>}
                            </TabsContent>

                            <TabsContent value="recipe" className="space-y-8">
                                {isGroceryLoading ? <div>Loading...</div> : recipeTabRecipes?.length > 0 ? recipeTabRecipes.map((recipe) => (
                                    <GroceryRecipeCard
                                        key={`recipe-${recipe.id}`}
                                        image={recipe.image}
                                        title={recipe.title}
                                        subtitle={recipe.subtitle}
                                        ingredients={recipe.ingredients}
                                    />
                                )) : <div>No recipes found for this plan.</div>}
                            </TabsContent>
                        </Tabs>
                    </div>
                    {/* Right Section */}
                    <div className="md:col-span-1 flex justify-center items-start border-l px-6">
                        <Button className="w-full bg-green-600 hover:bg-green-700 text-white">
                            BUY ON AMAZON FRESH
                        </Button>
                    </div>
                </div>
            </PageLayout>
        </>
    );
};

export default Grocery;