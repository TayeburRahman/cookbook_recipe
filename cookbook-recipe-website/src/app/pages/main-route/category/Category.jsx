import PageLayout from '@/tools/PageLayout';
import PageHeader from '@/components/common/page-header/PageHeader';
import { useParams } from 'react-router-dom';
import RecipeCard from '@/components/Recipes/recipe-card/RecipeCard';
import useSmartFetchHook from '@/hooks/useSmartFetchHook';
import { useGetRecipeByCategoryQuery } from '@/redux/feature/home/homeApi';
import CustomPagination from '@/components/common/custom-pagination/CustomPagination';
import Error from '@/components/common/error/Error';
import NoData from '@/components/common/no-data/NoData';
import CategoryPageSkeleton from '@/components/skeleton/category/CategoryPageSkeleton';
import AddToPlanModal from '@/components/Recipes/add-plan-modal/AddToPlanModal';
import { useDispatch, useSelector } from 'react-redux';
import { SetCardModalClose, SetRecipeId } from '@/redux/feature/meal-plan/addMealPlanSlice';

const Category = () => {
    const dispatch = useDispatch();
    const { cardModalOpen } = useSelector((state) => state.addMealPlan);
    const { slug: category } = useParams();
    const formattedSlug = category
        .split('-')
        .map(word => word.charAt(0).toUpperCase() + word.slice(1))
        .join(' ');

    const {
        currentPage,
        setCurrentPage,
        totalPages,
        items: recipes,
        isLoading,
        isError,
    } = useSmartFetchHook(useGetRecipeByCategoryQuery, { resultsKey: "result" }, { category });

    const breadcrumbs = [
        { name: 'Home', href: '/' },
        { name: formattedSlug },
    ];

    if (isLoading) {
        return <CategoryPageSkeleton />;
    }

    return (
        <>
            <PageHeader
                breadcrumbs={breadcrumbs}
                title={formattedSlug}
            />
            <PageLayout
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
                paddingSize="compact">
                <div className="grid gap-6 grid-cols-1">
                    {isError ? (
                        <Error size="perfect" msg="Something went wrong" />
                    ) : (
                        recipes.length === 0 ? (
                            <NoData size="perfect" msg="No recipes found" />
                        ) : (
                            recipes.map(recipe => (
                                <RecipeCard
                                    key={recipe._id}
                                    recipe={recipe}
                                    from={formattedSlug}
                                    fromPath={`/category/${category}`}
                                    showCartButton={true}
                                />
                            ))
                        )
                    )}
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

export default Category;