import RecipeCard from "@/components/Recipes/recipe-card/RecipeCard";
import { useDeleteRecipeMutation, useGetMyRecipesQuery } from "@/redux/feature/recipe/recipeApi";
// import CustomPagination from "@/components/common/custom-pagination/CustomPagination";
// import useSmartFetchHook from "@/hooks/useSmartFetchHook";
import NoData from "@/components/common/no-data/NoData";
import Error from "@/components/common/error/Error";
import RecipeCardSkeleton from "@/components/skeleton/recipe/RecipeCardSkeleton";
import { ErrorToast, SuccessToast } from "@/lib/utils";
import ConfirmationModal from "@/components/common/modal/ConfirmationModal";
import { useState } from "react";
import { Button } from "@/components/ui/button";
import { useNavigate } from "react-router-dom";
import { Plus } from "lucide-react";


const MyRecipe = () => {
    const navigate = useNavigate();
    const [confirmModal, setConfirmModal] = useState(false);
    const [recipeId, setRecipeId] = useState(null);
    // const {
    //     // searchTerm,
    //     // setSearchTerm,
    //     currentPage,
    //     setCurrentPage,
    //     totalPages,
    //     // items: myRecipes,
    //     isLoading,
    //     isError,
    // } = useSmartFetchHook(useGetMyRecipesQuery, { resultsKey: "result" });

    // console.log(myRecipes);

    const { data, isLoading, isError } = useGetMyRecipesQuery();
    // console.log(data);

    const [deleteRecipe, { isLoading: deleteLoading }] = useDeleteRecipeMutation();

    const handleDelete = async () => {
        try {
            await deleteRecipe(recipeId).unwrap();
            SuccessToast("Recipe deleted successfully");
            setConfirmModal(false);
        } catch (error) {
            ErrorToast(error.data?.message || "Failed to delete recipe");
        }
    };

    const handleEdit = (recipe) => {
        navigate(`/profile/edit-recipe/${recipe._id}`, {
            state: { recipe }  // Pass the recipe data in route state
        });
    };



    return (
        <>
            <div className="grid gap-6 grid-cols-1">
                {isLoading ? (
                    <RecipeCardSkeleton count={3} />
                ) : isError ? (
                    <Error msg="Something went wrong" />
                ) : data?.data?.length === 0 ? (
                    <>
                        <NoData
                            msg="No recipes found"
                        >
                            <Button
                                onClick={() => navigate("/profile/add-recipe")}
                                className="mt-6"
                            >
                                <Plus /> Add Recipe
                            </Button>
                        </NoData>
                    </>
                ) : (
                    data?.data?.map((recipe) => (
                        <RecipeCard
                            key={recipe._id}
                            recipe={recipe}
                            from="My Recipe"
                            fromPath="/profile/my-recipes"
                            isMyRecipe={true}
                            favorite={false}
                            onEdit={() => handleEdit(recipe)}
                            onDelete={() => { setConfirmModal(true), setRecipeId(recipe._id) }}
                        />
                    )))}
            </div>

            {/* <CustomPagination
                currentPage={currentPage}
                setCurrentPage={setCurrentPage}
                totalPages={totalPages}
            /> */}

            <ConfirmationModal
                isOpen={confirmModal}
                onOpenChange={() => setConfirmModal(false)}
                title="Delete Recipe"
                description="Are you sure you want to delete this recipe?"
                onConfirm={handleDelete}
                confirmText="Delete"
                loading={deleteLoading}
            />
        </>
    );
};

export default MyRecipe;