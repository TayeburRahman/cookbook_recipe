
import React, { useState, useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Button } from "@/components/ui/button";
import PlanTypeFilter from "../../meal-planner/PlanTypeFilter";
import { SetCardModalClose, SetPlanId, SetRecipeId, SetSelectedDay } from "@/redux/feature/meal-plan/addMealPlanSlice";
import { useAddMealPlanRecipesMutation, useGetCustomMealPlanQuery, useGetFeaturedMealPlanQuery, useGetWeeklyMealPlanQuery } from "@/redux/feature/meal-plan/mealPlanApi";
import { Dialog } from '@radix-ui/react-dialog';
import { DialogContent, DialogDescription, DialogTitle } from '@/components/ui/dialog';
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { ErrorToast, SuccessToast } from '@/lib/utils';

const formSchema = z.object({
    planId: z.string().min(1, { message: "Please select a plan." }),
    selectedDay: z.string().min(1, { message: "Please select a day." }),
});

const AddToPlanModal = ({ isOpen, onClose }) => {
    const dispatch = useDispatch();
    const { recipeId } = useSelector((state) => state.addMealPlan);

    // Fetch dropdown data
    useGetWeeklyMealPlanQuery();
    useGetFeaturedMealPlanQuery();
    useGetCustomMealPlanQuery();

    const weekDropDown = useSelector((state) => state.mealPlan.weeklyDropDown);
    const featuredDropDown = useSelector((state) => state.mealPlan.featuredDropDown);
    const customDropDown = useSelector((state) => state.mealPlan.customDropDown);

    const [activeTab, setActiveTab] = useState("my-weeks");
    const [selectedWeek, setSelectedWeek] = useState();
    const [selectedPlan, setSelectedPlan] = useState();
    const [selectedCustomPlan, setSelectedCustomPlan] = useState();

    const [addMealPlanRecipes, { isLoading }] = useAddMealPlanRecipesMutation();

    const form = useForm({
        resolver: zodResolver(formSchema),
        defaultValues: {
            planId: "",
            selectedDay: undefined,
        },
    });

    // Set initial selected values for dropdowns
    useEffect(() => {
        if (weekDropDown && weekDropDown.length > 0 && !selectedWeek) {
            setSelectedWeek(weekDropDown[0]);
            form.setValue("planId", weekDropDown[0]._id);
        }
    }, [weekDropDown, selectedWeek, form]);

    useEffect(() => {
        if (featuredDropDown && featuredDropDown.length > 0 && !selectedPlan) {
            setSelectedPlan(featuredDropDown[0]);
            form.setValue("planId", featuredDropDown[0]._id);
        }
    }, [featuredDropDown, selectedPlan, form]);

    useEffect(() => {
        if (customDropDown && customDropDown.length > 0 && !selectedCustomPlan) {
            setSelectedCustomPlan(customDropDown[0]);
            form.setValue("planId", customDropDown[0]._id);
        }
    }, [customDropDown, selectedCustomPlan, form]);

    // Update Redux planId based on active tab and selection
    useEffect(() => {
        let currentPlanId;
        if (activeTab === 'my-weeks') {
            currentPlanId = selectedWeek?._id;
        }
        else if (activeTab === 'featured-plans') {
            currentPlanId = selectedPlan?._id;
        }
        else if (activeTab === 'custom-plans') {
            currentPlanId = selectedCustomPlan?._id;
        }
        if (currentPlanId) {
            dispatch(SetPlanId(currentPlanId));
            form.setValue("planId", currentPlanId);
        }
    }, [activeTab, selectedWeek, selectedPlan, selectedCustomPlan, dispatch, form]);

    const onSubmit = async (values) => {
        if (!recipeId) {
            console.error("Missing recipeId");
            return;
        }

        try {
            await addMealPlanRecipes({ planId: values.planId, day: values.selectedDay, recipeId }).unwrap();
            SuccessToast("Recipe added to meal plan successfully");
        } catch (error) {
            console.error("Failed to add recipe to meal plan", error);
            ErrorToast("Failed to add recipe to meal plan");
        } finally {
            dispatch(SetCardModalClose());
            dispatch(SetRecipeId(null));
            dispatch(SetSelectedDay(null));
            onClose(); // Close the modal
            form.reset();
        }
    };

    const daysOfWeek = ["Day-1", "Day-2", "Day-3", "Day-4", "Day-5", "Day-6", "Day-7"];

    return (
        <Dialog open={isOpen} onOpenChange={onClose}>
            <DialogContent className="max-w-lg">
                <DialogTitle>Add to Plan</DialogTitle>
                <DialogDescription>
                    Select a plan and day to add the recipe to your meal plan.
                </DialogDescription>
                <Form {...form}>
                    <form onSubmit={form.handleSubmit(onSubmit)} className="grid gap-4 py-4">
                        <FormField
                            control={form.control}
                            name="planId"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Select Plan</FormLabel>
                                    <FormControl>
                                        <Tabs value={activeTab} onValueChange={setActiveTab} className="w-full">
                                            <TabsList className="grid w-full grid-cols-3">
                                                <TabsTrigger value="my-weeks">My Weeks</TabsTrigger>
                                                <TabsTrigger value="featured-plans">Featured Plans</TabsTrigger>
                                                <TabsTrigger value="custom-plans">Custom Plans</TabsTrigger>
                                            </TabsList>

                                            <TabsContent value="my-weeks" className="mt-4">
                                                <PlanTypeFilter
                                                    title="Select Week"
                                                    items={weekDropDown || []}
                                                    value={selectedWeek}
                                                    onValueChange={(val) => {
                                                        setSelectedWeek(val);
                                                        field.onChange(val?._id);
                                                    }}
                                                />
                                            </TabsContent>
                                            <TabsContent value="featured-plans" className="mt-4">
                                                <PlanTypeFilter
                                                    title="Select Featured Plan"
                                                    items={featuredDropDown || []}
                                                    value={selectedPlan}
                                                    onValueChange={(val) => {
                                                        setSelectedPlan(val);
                                                        field.onChange(val?._id);
                                                    }}
                                                />
                                            </TabsContent>
                                            <TabsContent value="custom-plans" className="mt-4">
                                                <PlanTypeFilter
                                                    title="Select Custom Plan"
                                                    items={customDropDown || []}
                                                    value={selectedCustomPlan}
                                                    onValueChange={(val) => {
                                                        setSelectedCustomPlan(val);
                                                        field.onChange(val?._id);
                                                    }}
                                                />
                                            </TabsContent>
                                        </Tabs>
                                    </FormControl>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />

                        <FormField
                            control={form.control}
                            name="selectedDay"
                            render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Select Day</FormLabel>
                                    <Select onValueChange={field.onChange} value={field.value}>
                                        <FormControl>
                                            <SelectTrigger className="w-[180px]">
                                                <SelectValue placeholder="Select Day" />
                                            </SelectTrigger>
                                        </FormControl>
                                        <SelectContent>
                                            {daysOfWeek.map((day) => (
                                                <SelectItem key={day} value={day}>
                                                    {day}
                                                </SelectItem>
                                            ))}
                                        </SelectContent>
                                    </Select>
                                    <FormMessage />
                                </FormItem>
                            )}
                        />

                        <Button loading={isLoading} type="submit">
                            Add to Plan
                        </Button>
                    </form>
                </Form>
            </DialogContent>
        </Dialog>
    );
};

export default AddToPlanModal;