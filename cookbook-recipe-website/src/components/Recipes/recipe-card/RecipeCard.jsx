import { Card } from "@/components/ui/card";
import { Button } from '@/components/ui/button';
import { Heart, Clock, Star, ShoppingCart, ChefHat, Trash2, SquarePen } from 'lucide-react';
import { Link } from 'react-router-dom';
import { ErrorToast, getImageUrl, SuccessToast } from '@/lib/utils';
import useFavorite from '@/hooks/useFavorite';
import { useDispatch, useSelector } from "react-redux";
import { SetCardModalOpen, SetMealPlannerModalOpen, SetMealPlannerSwapModalOpen, SetRecipeId, SetSelectedDay } from "@/redux/feature/meal-plan/addMealPlanSlice";
import { useAddMealPlanRecipesMutation, useSwapRecipeMutation } from "@/redux/feature/meal-plan/mealPlanApi";
import { Badge } from "@/components/ui/badge";

const RecipeCard = (
    {
        recipe,
        from = 'Recipes',
        fromPath = '/recipes',
        showCartButton = false,
        isMyRecipe = false,
        showChooseButton = false,
        showSwapButton = false,
        favorite = true,
        onDelete,
        onEdit
    }) => {
    const dispatch = useDispatch();
    const [addMealPlanRecipes, { isLoading }] = useAddMealPlanRecipesMutation();
    const [swapRecipe, { isLoading: swapLoading }] = useSwapRecipeMutation();
    const { isFavorite, onFavoriteToggle } = useFavorite(recipe.favorite);
    const { planId, selectedDay, recipeId } = useSelector((state) => state.addMealPlan);

    const handleChooseClick = async (recipeId) => {
        dispatch(SetRecipeId(recipeId));
        try {
            const result = await addMealPlanRecipes({ planId, day: selectedDay, recipeId }).unwrap();
            SuccessToast("Recipe added to meal plan successfully");
            // Reset states after successful addition
            dispatch(SetRecipeId(null));
            dispatch(SetSelectedDay(null));
            return result;
        } catch (error) {
            console.error('Error adding recipe to meal plan:', error);
            ErrorToast(error.data?.message || "Failed to add recipe to meal plan");
            throw error;
        } finally {
            dispatch(SetMealPlannerModalOpen(false));
        }
    };

    const handleSwapClick = async (newId) => {
        try {
            await swapRecipe({ planId, day: selectedDay, removeId: recipeId, newId });
            SuccessToast("Recipe swapped successfully");

            dispatch(SetRecipeId(null));
            dispatch(SetSelectedDay(null));
        } catch (error) {
            console.error('Swap error:', error);
            ErrorToast(error.data?.message || "Failed to swap recipe");
        } finally {
            dispatch(SetMealPlannerSwapModalOpen(false));
        }
    };

    const handleAddToPlanClick = (recipeId) => {
        dispatch(SetRecipeId(recipeId));
        dispatch(SetCardModalOpen(true));
    };

    return (
        <Link
            to={`/recipes/recipe-details/${recipe._id}`}
            state={{ from, fromPath }}
            className="h-full group transition-all duration-300 hover:-translate-y-1 block"
        >
            <Card className="h-full flex flex-col md:flex-row overflow-hidden border-0 shadow-sm transition-all duration-300 bg-secondary hover:shadow-md">
                {/* Image with Overlay - Left Side */}
                <div className="w-full md:w-40 h-40 relative flex-shrink-0 overflow-hidden group">
                    <img
                        src={getImageUrl(recipe.image)}
                        alt={recipe.title}
                        className="w-full h-full object-cover transition-transform duration-500"
                        onError={(e) => e.target.src = `https://placehold.co/400?text=${recipe.name}&font=roboto`}
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-primary to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-end p-4">
                        <div className="flex items-center gap-2 text-white text-sm">
                            <ChefHat className="w-4 h-4" />
                            <span>{recipe.author || 'Chef Special'}</span>
                        </div>
                    </div>
                </div>

                {/* Content - Right Side */}
                <div className="p-5 flex-grow flex flex-col md:w-2/3">
                    <div className="flex justify-between items-start mb-3">
                        <Badge className="capitalize rounded-full bg-black/40">
                            {recipe.category}
                        </Badge>

                        {/* Favorite Button */}
                        {favorite && (
                            <Button
                                variant="ghost"
                                size="icon"
                                className="rounded-full bg-primary/20"
                                onClick={(e) => {
                                    e.preventDefault();
                                    e.stopPropagation();
                                    onFavoriteToggle(recipe._id)
                                }}
                            >
                                <Heart
                                    className={`${isFavorite ? 'fill-red-500 text-red-500' : 'text-white'}`}
                                />
                            </Button>
                        )}

                        {/* Edit and Delete Buttons */}
                        {isMyRecipe && (
                            <div className='grid grid-cols-2 gap-2'>
                                <Button
                                    onClick={(e) => {
                                        e.preventDefault();
                                        e.stopPropagation();
                                        onEdit(recipe)
                                    }}
                                    variant="outline">
                                    <SquarePen />
                                </Button>
                                <Button
                                    onClick={(e) => {
                                        e.preventDefault();
                                        e.stopPropagation();
                                        onDelete(recipe._id)
                                    }}
                                    variant="outline">
                                    <Trash2 />
                                </Button>
                            </div>
                        )}
                    </div>

                    <h3 className="font-semibold  dark:text-white mb-2 line-clamp-2">
                        {recipe.name}
                    </h3>

                    <div className="flex items-center justify-between mt-auto pt-3 border-t ">
                        <div className="flex items-center gap-3 text-sm text-muted-foreground dark:text-gray-300">
                            <div className="flex items-center gap-1">
                                <Clock className="w-4 h-4" />
                                <span>{recipe.prep_time}</span>
                            </div>
                            <div className="flex items-center gap-1">
                                <Star className="w-4 h-4 text-yellow-400 fill-yellow-400" />
                                <span className="font-medium">{recipe.ratting.toFixed(1)}</span>
                            </div>
                        </div>

                        {/* Add to Plan Button */}
                        {showCartButton && <Button
                            className="bg-gradient-to-r from-primary to-primary/80 hover:from-primary/90 hover:to-primary/70 text-white px-4 py-2 rounded-full text-sm font-medium flex items-center gap-2 transition-all duration-200 shadow-md hover:shadow-lg"
                            size="sm"
                            onClick={(e) => {
                                e.preventDefault();
                                e.stopPropagation();
                                handleAddToPlanClick(recipe._id);
                            }}
                        >
                            <ShoppingCart />
                            Add to Plan
                        </Button>}
                        {/* Choose Button */}
                        {showChooseButton && <Button
                            loading={isLoading}
                            className="bg-gradient-to-r from-primary to-primary/80 hover:from-primary/90 hover:to-primary/70 text-white px-4 py-2 rounded-full text-sm font-medium flex items-center gap-2 transition-all duration-200 shadow-md hover:shadow-lg"
                            size="sm"
                            onClick={(e) => {
                                e.preventDefault();
                                e.stopPropagation();
                                handleChooseClick(recipe._id);
                            }}
                        >
                            Choose
                        </Button>}
                        {/* Swap Button */}
                        {showSwapButton && <Button
                            loading={swapLoading}
                            className="bg-gradient-to-r from-primary to-primary/80 hover:from-primary/90 hover:to-primary/70 text-white px-4 py-2 rounded-full text-sm font-medium flex items-center gap-2 transition-all duration-200 shadow-md hover:shadow-lg"
                            size="sm"
                            onClick={(e) => {
                                e.preventDefault();
                                e.stopPropagation();
                                handleSwapClick(recipe._id);
                            }}
                        >
                            Swap
                        </Button>}
                    </div>
                </div>
            </Card>
        </Link>
    );
};

export default RecipeCard;