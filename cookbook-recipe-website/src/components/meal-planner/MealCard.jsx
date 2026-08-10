import { ErrorToast, getImageUrl, SuccessToast } from "@/lib/utils";
import { Badge } from "../ui/badge";
import { Button } from "../ui/button";
import { ArrowLeftRight, Trash2 } from "lucide-react";
import { Tooltip, TooltipContent, TooltipTrigger } from "../ui/tooltip";
import { SetSelectedDay, SetRecipeId, SetMealPlannerSwapModalOpen } from "@/redux/feature/meal-plan/addMealPlanSlice";
import { useDispatch, useSelector } from "react-redux";
import { useState } from "react";
import ConfirmationModal from "../common/modal/ConfirmationModal";
import { useRemoveRecipeMutation } from "@/redux/feature/meal-plan/mealPlanApi";

const MealCard = ({ meal, day }) => {
    const dispatch = useDispatch();
    const [confirmationModalOpen, setConfirmationModalOpen] = useState(false);
    const { planId, recipeId, selectedDay } = useSelector((state) => state.addMealPlan);

    const [removeRecipe, { isLoading }] = useRemoveRecipeMutation();

    const onRemoveClick = (id, day) => {
        dispatch(SetRecipeId(id));
        dispatch(SetSelectedDay(day));
        setConfirmationModalOpen(true);
    }
    const handleRemoveConfirm = async () => {
        try {
            const { data } = await removeRecipe({
                removeId: recipeId,
                day: selectedDay,
                planId: planId
            }).unwrap();

            if (data) {
                SuccessToast("Recipe removed successfully");
                setConfirmationModalOpen(false);
                dispatch(SetRecipeId(null));
                dispatch(SetSelectedDay(null));
            }
        } catch (error) {
            console.error("Failed to remove recipe:", error);
            ErrorToast(error.data?.message || "Failed to remove recipe");
        }
    };

    const onSwapClick = (removeId, day) => {
        dispatch(SetRecipeId(removeId));
        dispatch(SetSelectedDay(day));
        dispatch(SetMealPlannerSwapModalOpen(true));
    }




    if (!meal) return null;
    return (
        <>
            <div className="border rounded-lg p-4 relative group">
                {/* Image Block */}
                <div className="relative mb-4">
                    <img
                        src={getImageUrl(meal.image)}
                        alt={meal.name}
                        className="w-full h-32 object-cover rounded-md"
                        onError={(e) =>
                            (e.target.src = `https://placehold.co/400?text=${meal.name}&font=roboto`)
                        }
                    />

                    {/* Overlay */}
                    <div className="absolute inset-0 bg-black/70 rounded-md opacity-0 group-hover:opacity-100 transition-opacity duration-300 z-0" />

                    {/* Hover Actions */}
                    <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 hidden group-hover:flex items-center gap-2 p-2 z-10">
                        <Tooltip>
                            <TooltipTrigger asChild>
                                <Button onClick={() => onSwapClick(meal._id, day)} size="icon" className="h-8 w-8 bg-primary">
                                    <ArrowLeftRight className="h-4 w-4 text-white" />
                                </Button>
                            </TooltipTrigger>
                            <TooltipContent>
                                Swap Recipe
                            </TooltipContent>
                        </Tooltip>
                        <Tooltip>
                            <TooltipTrigger asChild>
                                <Button onClick={() => onRemoveClick(meal._id, day)} size="icon" className="h-8 w-8 bg-red-500 hover:bg-red-600">
                                    <Trash2 className="h-4 w-4 text-white" />
                                </Button>
                            </TooltipTrigger>
                            <TooltipContent>
                                Remove Recipe
                            </TooltipContent>
                        </Tooltip>
                    </div>
                </div>

                {/* Title + Category */}
                <div className="flex justify-between items-center gap-2">
                    <h3 className="font-semibold">{meal.name}</h3>
                    <Badge variant="outline">{meal.category}</Badge>
                </div>
            </div>

            {/* Confirmation Modal */}
            <ConfirmationModal
                isOpen={confirmationModalOpen}
                onOpenChange={() =>{
                    setConfirmationModalOpen(false);
                    dispatch(SetRecipeId(null));
                    dispatch(SetSelectedDay(null));
                }}
                title="Remove Recipe"
                description={`Are you sure you want to remove this recipe from your meal plan?`}
                onConfirm={handleRemoveConfirm}
                confirmText="Remove"
                loading={isLoading}
            />

        </>
    );
};

export default MealCard;