import PageLayout from '@/tools/PageLayout';
import { Skeleton } from '@/components/ui/skeleton';
import RecipeCardSkeleton from '../recipe/RecipeCardSkeleton';

const CategoryPageSkeleton = () => {
    return (
        <>
            {/* PageHeader Skeleton - with dark background to match screenshot */}
            <div className="bg-secondary flex flex-col justify-center items-center h-42">
                {/* Title Skeleton */}
                <Skeleton className="h-8 w-1/7 mb-4" />
                {/* Breadcrumbs Skeleton */}
                <div className="flex items-center space-x-2">
                    <Skeleton className="h-4 w-16" />
                    <Skeleton className="h-4 w-4" />
                    <Skeleton className="h-4 w-24" />
                </div>
            </div>

            {/* Main Content Area - with very dark background */}
            <div className="bg-background ">
                <PageLayout paddingSize="compact">
                    <div className="grid gap-6 grid-cols-1">
                        <RecipeCardSkeleton count={4} />
                    </div>
                </PageLayout>
            </div>
        </>
    );
};

export default CategoryPageSkeleton;