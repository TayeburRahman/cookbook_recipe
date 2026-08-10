import React, { useState } from "react";
import PageLayout from "@/tools/PageLayout";
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
import {
    Dialog,
    DialogContent,
    DialogHeader,
    DialogTitle,
    DialogDescription,
} from "@/components/ui/dialog";

const AddRecipePlanModal = ({ isOpen, onOpenChange }) => {
    const [isFilterModalOpen, setIsFilterModalOpen] = useState(false);
    const [appliedFilters, setAppliedFilters] = useState({});

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
    } = useSmartFetchHook(useGetRecipesQuery, { resultsKey: "result" }, appliedFilters);


    const handleApplyFilters = (filters) => {
        setAppliedFilters(filters);
        setFilterParams(filters);
    };

    const handleClearFilters = () => {
        setAppliedFilters({});
        setFilterParams({});
    };

    return (
        <Dialog open={isOpen} onOpenChange={onOpenChange}>
            <DialogContent className="max-w-5xl h-[90vh] flex flex-col p-0">
                <DialogHeader className="px-6 pt-6 pb-0">
                    <DialogTitle>Select a Recipe to Add</DialogTitle>
                    <DialogDescription>Choose a recipe to add to your meal plan.</DialogDescription>
                </DialogHeader>
                <div className="flex-grow overflow-y-auto px-6">
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
                        <div className="flex flex-col md:flex-row justify-end items-start md:items-center gap-4 mb-8">
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
                        <div className="grid gap-6 grid-cols-1 md:grid-cols-2">
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
                                        showChooseButton={true}
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
                </div>
            </DialogContent>
        </Dialog>
    );
};

export default AddRecipePlanModal;