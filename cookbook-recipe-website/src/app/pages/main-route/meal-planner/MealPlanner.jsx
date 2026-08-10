import PageLayout from "@/tools/PageLayout";
import PageHeader from "@/components/common/page-header/PageHeader";
import WeeklyMealPlan from "@/components/meal-planner/WeeklyMealPlan";
import PlanTypeFilter from "@/components/meal-planner/PlanTypeFilter";
import { useEffect, useState } from "react";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
    useDeleteCustomMealPlanMutation,
    useGetCustomMealPlanQuery,
    useGetFeaturedMealPlanQuery,
    useGetMealPlanDetailsQuery,
    useGetWeeklyMealPlanQuery,
    // useRemoveRecipeMutation
} from "@/redux/feature/meal-plan/mealPlanApi";
import CreatePlanModal from "@/components/meal-planner/CreatePlanModal";
import { Button } from "@/components/ui/button";
import { Trash2 } from "lucide-react";
import ConfirmationModal from "@/components/common/modal/ConfirmationModal";
import { useDispatch, useSelector } from "react-redux";
import { SetMealPlannerModalOpen, SetMealPlannerSwapModalOpen, SetPlanId, SetRecipeId, SetSelectedDay } from "@/redux/feature/meal-plan/addMealPlanSlice";
import AddRecipePlanModal from "@/components/meal-planner/AddRecipePlanModal";
import SwapRecipePlanModal from "@/components/meal-planner/SwapRecipePlanModal";
import Preparation from "@/components/meal-planner/Preparation";

const MealPlanner = () => {
    const dispatch = useDispatch();
    useGetWeeklyMealPlanQuery()
    useGetFeaturedMealPlanQuery()
    useGetCustomMealPlanQuery()
    const weekDropDown = useSelector((state) => state.mealPlan.weeklyDropDown);
    const featuredDropDown = useSelector((state) => state.mealPlan.featuredDropDown);
    const customDropDown = useSelector((state) => state.mealPlan.customDropDown);
    const { mealPlannerModalOpen, mealPlannerSwapModalOpen } = useSelector((state) => state.addMealPlan);

    const [activeTab, setActiveTab] = useState("my-weeks");
    const [selectedWeek, setSelectedWeek] = useState();
    const [selectedPlan, setSelectedPlan] = useState();
    const [selectedCustomPlan, setSelectedCustomPlan] = useState();
    const [activeMealPlanId, setActiveMealPlanId] = useState();
    const [isCreateModalOpen, setIsCreateModalOpen] = useState(false);
    const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
    // const [confirmationModalOpen, setConfirmationModalOpen] = useState(false);

    const { data: mealPlanDetailsResponse } = useGetMealPlanDetailsQuery(activeMealPlanId, { skip: !activeMealPlanId });
    const mealPlanDetails = mealPlanDetailsResponse?.data;
    const [deleteCustomMealPlan, { isLoading: isDeleting }] = useDeleteCustomMealPlanMutation();
    // const [removeRecipe, { isLoading }] = useRemoveRecipeMutation();

    const customDropDownWithOptions = [
        ...(customDropDown || []),
        { _id: 'add_new', label: '+ Add New Plan', value: 'add_new' }
    ];

    const handleAddRecipeClick = (day) => {
        dispatch(SetSelectedDay(day));
        dispatch(SetMealPlannerModalOpen(true));
    };
    const handlePlanDelete = async () => {
        if (!selectedCustomPlan) return;
        try {
            await deleteCustomMealPlan(selectedCustomPlan._id).unwrap();
            setSelectedCustomPlan(undefined); // Reset selection
            setIsDeleteModalOpen(false);
        } catch (error) {
            console.error("Failed to delete custom meal plan", error);
        }
    };

    useEffect(() => {
        if (activeTab === 'my-weeks') {
            setActiveMealPlanId(selectedWeek?._id);
            dispatch(SetPlanId(selectedWeek?._id));
        } else if (activeTab === 'featured-plans') {
            setActiveMealPlanId(selectedPlan?._id);
            dispatch(SetPlanId(selectedPlan?._id));
        } else if (activeTab === 'custom-plans') {
            setActiveMealPlanId(selectedCustomPlan?._id);
            dispatch(SetPlanId(selectedCustomPlan?._id));
        }
    }, [activeTab, selectedWeek, selectedPlan, selectedCustomPlan, dispatch]);


    useEffect(() => {
        if (weekDropDown && weekDropDown.length > 0 && !selectedWeek) {
            setSelectedWeek(weekDropDown[0]);
        }
    }, [weekDropDown, selectedWeek]);

    useEffect(() => {
        if (featuredDropDown && featuredDropDown.length > 0 && !selectedPlan) {
            setSelectedPlan(featuredDropDown[0]);
        }
    }, [featuredDropDown, selectedPlan]);

    useEffect(() => {
        if (customDropDown && customDropDown.length > 0 && !selectedCustomPlan) {
            setSelectedCustomPlan(customDropDown[0]);
        }
    }, [customDropDown, selectedCustomPlan]);

    const breadcrumbs = [
        { name: "Home", href: "/" },
        { name: "Meal Planner" },
    ];
    return (
        <>
            <PageHeader breadcrumbs={breadcrumbs} title="Meal Planner" />
            <PageLayout paddingSize="compact">
                <div className="space-y-8">
                    <Tabs value={activeTab} onValueChange={setActiveTab}>
                        <div className="flex flex-col md:flex-row items-center justify-between gap-4">
                            <TabsList className="flex gap-3">
                                <TabsTrigger value="my-weeks" className="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground">My Weeks</TabsTrigger>
                                <TabsTrigger value="featured-plans" className="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground">Featured Plans</TabsTrigger>
                                <TabsTrigger value="custom-plans" className="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground">Custom Plans</TabsTrigger>
                            </TabsList>

                            <TabsList>
                                <TabsTrigger value="preparation">Preparation</TabsTrigger>
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
                            <div className="mt-8">
                                <WeeklyMealPlan
                                    mealPlan={mealPlanDetails || {}}
                                    onAddRecipeClick={handleAddRecipeClick}
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
                            <div className="mt-8">
                                <WeeklyMealPlan
                                    mealPlan={mealPlanDetails || {}}
                                    onAddRecipeClick={handleAddRecipeClick}
                                />
                            </div>
                        </TabsContent>
                        <TabsContent value="custom-plans">
                            <div className="flex items-center gap-4 mt-4">
                                <PlanTypeFilter
                                    title="Select Custom Plan"
                                    items={customDropDownWithOptions}
                                    value={selectedCustomPlan}
                                    onValueChange={(plan) => {
                                        if (plan?._id === 'add_new') {
                                            setIsCreateModalOpen(true);
                                        } else {
                                            setSelectedCustomPlan(plan);
                                        }
                                    }}
                                />
                                <Button
                                    variant="outline"
                                    size="icon"
                                    onClick={() => setIsDeleteModalOpen(true)}
                                    disabled={!selectedCustomPlan || selectedCustomPlan?._id === 'add_new'}
                                >
                                    <Trash2 />
                                </Button>
                            </div>
                            <div className="mt-8">
                                <WeeklyMealPlan
                                    mealPlan={mealPlanDetails || {}}
                                    onAddRecipeClick={handleAddRecipeClick}
                                />
                            </div>
                        </TabsContent>
                        <TabsContent value="preparation">
                            {/* <Preparation /> */}
                            <div className="mt-8">
                                <Preparation mealPlan={mealPlanDetails || {}} />
                            </div>
                        </TabsContent>
                    </Tabs>
                </div>
            </PageLayout>


            {/* Modal */}
            <CreatePlanModal
                isOpen={isCreateModalOpen}
                setIsOpen={setIsCreateModalOpen}
            />
            <ConfirmationModal
                isOpen={isDeleteModalOpen}
                onOpenChange={setIsDeleteModalOpen}
                title="Are you sure?"
                description={`This will permanently delete the "${selectedCustomPlan?.label}" meal plan.`}
                onConfirm={handlePlanDelete}
                loading={isDeleting}
                confirmText="Delete"
            />
            <AddRecipePlanModal
                isOpen={mealPlannerModalOpen}
                onOpenChange={(isOpen) => {
                    dispatch(SetMealPlannerModalOpen(isOpen));
                    dispatch(SetSelectedDay(null));
                }}
            />

            <SwapRecipePlanModal
                isOpen={mealPlannerSwapModalOpen}
                onOpenChange={(isOpen) => {
                    dispatch(SetMealPlannerSwapModalOpen(isOpen));
                    dispatch(SetSelectedDay(null));
                    dispatch(SetRecipeId(null));
                }}
            />
        </>
    );
};

export default MealPlanner;