import { useParams, useLocation } from 'react-router-dom';
import { Button } from '@/components/ui/button';
import { Clock, Star, ShoppingCart, Heart } from 'lucide-react';
import PageLayout from '@/tools/PageLayout';
import NutritionalInfo from '@/components/recipe-details/nutritional-info/NutritionalInfo';
import DetailsTabs from '@/components/recipe-details/details-tabs/DetailsTabs';
import { Separator } from '@/components/ui/separator';
import CustomBreadcrumb from '@/components/common/custom-breadcrumb/CustomBreadcrumb';
import { useGetRecipeByIdQuery } from '@/redux/feature/recipe/recipeApi';
import useFavorite from '@/hooks/useFavorite';
import { getImageUrl } from '@/lib/utils';
import { Badge } from '@/components/ui/badge';
import RecipeDetailsSkeleton from '@/components/skeleton/recipe-details/RecipeDetailsSkeleton';
import Error from '@/components/common/error/Error';
import { SetCardModalClose, SetCardModalOpen, SetRecipeId } from '@/redux/feature/meal-plan/addMealPlanSlice';
import { useDispatch, useSelector } from 'react-redux';
import AddToPlanModal from '@/components/Recipes/add-plan-modal/AddToPlanModal';

const RecipeDetails = () => {
    const { id } = useParams();
    const { cardModalOpen } = useSelector((state) => state.addMealPlan);
    const dispatch = useDispatch();
    const location = useLocation();
    const { from, fromPath } = location.state || { from: 'Recipes', fromPath: '/recipes' };

    const { data, isLoading, isError } = useGetRecipeByIdQuery(id);
    const recipe = data?.data || {};
    const { isFavorite, onFavoriteToggle } = useFavorite(recipe.favorite);

    const handleAddToPlan = () => {
        dispatch(SetRecipeId(recipe._id));
        dispatch(SetCardModalOpen(true));
    };

    const breadcrumbs = [
        { name: 'Home', href: '/' },
        { name: from, href: fromPath },
        { name: recipe.name },
    ];

    const renderBadges = () => {
        const badges = [];
        if (recipe.category) badges.push(<Badge key="category" variant="outline">{recipe.category}</Badge>);
        if (recipe.holiday_recipes) badges.push(<Badge key="holiday" variant="outline">{recipe.holiday_recipes}</Badge>);
        if (recipe.oils) badges.push(<Badge key="oils" variant="outline">{recipe.oils.replace(/_/g, ' ')}</Badge>);
        if (recipe.serving_temperature) badges.push(<Badge key="temp" variant="outline">{recipe.serving_temperature}</Badge>);
        if (recipe.flavor) badges.push(<Badge key="flavor" variant="outline">{recipe.flavor}</Badge>);
        if (recipe.weight_and_muscle) badges.push(<Badge key="weight" variant="outline">{recipe.weight_and_muscle.replace(/_/g, ' ')}</Badge>);
        if (recipe.whole_food_type) badges.push(<Badge key="food_type" variant="outline">{recipe.whole_food_type.replace(/_/g, ' ')}</Badge>);
        if (recipe.kid_approved) badges.push(<Badge key="kid" variant="outline">Kid Approved</Badge>);
        if (recipe.no_weekend_prep) badges.push(<Badge key="prep" variant="outline">No Weekend Prep</Badge>);

        if (badges.length === 0) return null;

        return (
            <div className="flex flex-wrap items-center gap-2 mt-4">
                {badges}
            </div>
        );
    };


    if (isLoading) {
        return <RecipeDetailsSkeleton />;
    }

    if (isError) {
        return <Error size="full" msg="Failed to load recipe details. Please try again later." />;
    }


    return (
        <>
            <PageLayout paddingSize="compact">
                <CustomBreadcrumb links={breadcrumbs} />

                {/* Top Image */}
                <div className="w-full h-64 md:h-[500px] bg-cover bg-center rounded-lg">
                    <img
                        src={getImageUrl(recipe?.image) || `https://placehold.co/600x400?text=${recipe?.name}&font=poppins`}
                        alt={recipe?.name}
                        className="w-full h-full object-cover rounded-lg"
                        onError={(e) => e.target.src = `https://placehold.co/600x400?text=${recipe?.name}&font=poppins`}
                    />
                </div>

                {/* Main Content Grid */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mt-6">
                    {/* Left Column */}
                    <div className="md:col-span-2">
                        {/* Recipe Header */}
                        <div className="flex flex-col md:flex-row justify-between md:items-start mb-6">
                            <div className="mb-4 md:mb-0 space-y-3">
                                <h1 className="text-2xl md:text-3xl font-bold">{recipe?.name}</h1>
                                {recipe?.prep && <p className="text-muted-foreground">{recipe.prep}</p>}
                                <div className="flex items-center gap-4 text-muted-foreground">
                                    <div className="flex items-center gap-1">
                                        <Star size={20} className="text-yellow-400 fill-yellow-400" />
                                        <span className="font-semibold">{Math.floor(recipe?.ratting) || 'N/A'}</span>
                                    </div>
                                    <div className="flex items-center gap-1 text-sm">
                                        <Clock size={16} />
                                        <span>{recipe?.prep_time} mins</span>
                                    </div>
                                    <div className="flex items-center gap-1 text-sm">
                                        <span>•</span>
                                        <span>{recipe?.serving_size} servings</span>
                                    </div>
                                </div>
                                {renderBadges()}
                            </div>
                            <div className="flex items-center gap-2">
                                <Button
                                    variant="outline"
                                    size="icon"
                                    onClick={() => onFavoriteToggle(recipe._id)}
                                >
                                    <Heart className={`w-5 h-5 ${isFavorite ? 'fill-red-500 text-red-500' : 'text-muted-foreground'}`} />
                                </Button>
                                <Button onClick={handleAddToPlan}>
                                    <ShoppingCart className="w-4 h-4 mr-2" />
                                    Add to Meal Plan
                                </Button>
                            </div>
                        </div>
                        <Separator className="my-4" />

                        {/* Recipe Content */}
                        <div className="space-y-6">
                            <DetailsTabs
                                recipe={recipe}
                            />
                        </div>
                    </div>

                    {/* Right Column */}
                    <div className="space-y-6">
                        <NutritionalInfo
                            calories={recipe?.nutritional?.calories}
                            protein={recipe?.nutritional?.protein}
                            carbs={recipe?.nutritional?.carbs}
                            fat={recipe?.nutritional?.fat}
                            fiber={recipe?.nutritional?.fiber}
                        />
                    </div>
                </div>
            </PageLayout>

            {/* Add to Plan Modal */}
            <AddToPlanModal
                isOpen={cardModalOpen}
                onClose={() => {
                    dispatch(SetCardModalClose());
                    dispatch(SetRecipeId(null));
                }}
            />
        </>
    );
};

export default RecipeDetails;