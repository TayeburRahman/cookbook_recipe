import React, { useState } from "react";
import PageLayout from "@/tools/PageLayout";
import PageHeader from "@/components/common/page-header/PageHeader";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Search, SlidersHorizontal } from "lucide-react";
import RecipeCard from "@/components/Recipes/recipe-card/RecipeCard";
import FilterModal from "@/components/Recipes/filter-modal/FilterModal";
import { useGetRecipesQuery } from "@/redux/feature/recipe/recipeApi";
import useSmartFetchHook from "@/hooks/useSmartFetchHook";
import RecipeCardSkeleton from "@/components/skeleton/recipe/RecipeCardSkeleton";
import Error from "@/components/common/error/Error";
import NoData from "@/components/common/no-data/NoData";
import CustomPagination from "@/components/common/custom-pagination/CustomPagination";
import { useDispatch, useSelector } from "react-redux";
import AddToPlanModal from "@/components/Recipes/add-plan-modal/AddToPlanModal";
import { SetCardModalClose, SetRecipeId } from "@/redux/feature/meal-plan/addMealPlanSlice";

const Recipes = () => { 
    const dispatch = useDispatch();
    const { cardModalOpen } = useSelector((state) => state.addMealPlan);
    const [isFilterModalOpen, setIsFilterModalOpen] = useState(false);

    const {
        searchTerm,
        setSearchTerm,
        currentPage,
        setCurrentPage,
        totalPages,
        items: recipes,
        isLoading,
        isError,
        setFilterParams,
    } = useSmartFetchHook(useGetRecipesQuery, { resultsKey: "result"});


    const handleApplyFilters = (filters) => {
        setFilterParams(filters);
    };

    const handleClearFilters = () => {
        setFilterParams({});
    };

    const breadcrumbs = [
        { name: 'Home', href: '/' },
        { name: 'Recipes' },
    ];
    return (
        <>
            <PageHeader
                title="Recipes"
                breadcrumbs={breadcrumbs}
            />
            <PageLayout
                paddingSize="compact"
                pagination={
                    totalPages > 1 && (
                        <div className="absolute bottom-4 left-0 right-0">
                            <CustomPagination
                                currentPage={currentPage}
                                totalPages={totalPages}
                                onPageChange={setCurrentPage}
                            />
                        </div>
                    )
                }

            >
                {/* Title and Search/Filter */}
                <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-8">
                    <div>
                        <h2 className="text-2xl font-bold ">All Recipes</h2>
                        <p className="text-muted-foreground">Discover and explore delicious recipes</p>
                    </div>
                    <div className="w-full md:w-auto flex items-center gap-3">
                        <div className="relative flex-grow md:flex-grow-0 md:w-64">
                            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                            <Input
                                type="text"
                                placeholder="Search recipes..."
                                className="w-full pl-9 pr-4 text-sm bg-background"
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                            />
                        </div>
                        <Button
                            variant="outline"
                            onClick={() => setIsFilterModalOpen(true)}
                        >
                            <SlidersHorizontal />
                            Filters
                        </Button>
                    </div>
                </div>

                {/* Recipe List */}
                <div className="grid gap-6 grid-cols-1">
                    {isLoading ? (
                        <RecipeCardSkeleton count={3} />
                    ) : isError ? (
                        <Error msg="Something went wrong" />
                    ) : recipes.length === 0 ? (
                        <NoData msg="No recipes found" />
                    ) : (
                        recipes.map((recipe) => (
                            <RecipeCard
                                key={recipe._id}
                                recipe={recipe}
                                from="Recipes"
                                fromPath="/recipes"
                                showCartButton={true}
                            />
                        ))
                    )}
                </div>
            </PageLayout>

            {/* Filter Modal */}
            <FilterModal
                isOpen={isFilterModalOpen}
                onClose={() => setIsFilterModalOpen(false)}
                onApplyFilters={handleApplyFilters}
                onClearFilters={handleClearFilters}
            />

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

export default Recipes;