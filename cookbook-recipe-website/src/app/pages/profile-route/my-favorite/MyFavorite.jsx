import Error from "@/components/common/error/Error";
import NoData from "@/components/common/no-data/NoData";
import RecipeCard from "@/components/Recipes/recipe-card/RecipeCard";
import RecipeCardSkeleton from "@/components/skeleton/recipe/RecipeCardSkeleton";
import { Pagination } from "@/components/ui/pagination";
import useSmartFetchHook from "@/hooks/useSmartFetchHook";
import { useGetUserFavoriteRecipesQuery } from "@/redux/feature/profile/profileApi";


const MyFavorite = () => {

    const {
        currentPage,
        setCurrentPage,
        totalPages,
        items: recipes,
        isLoading,
        isError,
    } = useSmartFetchHook(useGetUserFavoriteRecipesQuery, { resultsKey: "recipes", limit: 1 });

    return (
        <div>
            <div className="grid gap-6 grid-cols-1">
                {isLoading ? (
                    <RecipeCardSkeleton count={3} />
                ) : isError ? (
                    <Error msg="Something went wrong" />
                ) : recipes.length === 0 ? (
                    <NoData msg="No recipes found" />
                ) : (
                    recipes?.map((recipe) => (
                        <RecipeCard
                            key={recipe._id}
                            recipe={recipe}
                            from="My Favorite"
                            fromPath="/profile/my-favourite"
                            showCartButton={true}
                        />
                    ))
                )}
            </div>
            <div className="flex justify-center">
                {totalPages > 1 && (
                    <Pagination
                        page={currentPage}
                        totalPages={totalPages}
                        onPageChange={setCurrentPage}
                    />
                )}
            </div>
        </div>
    );
};

export default MyFavorite;