import { Skeleton } from "@/components/ui/skeleton";
import PageLayout from "@/tools/PageLayout";
import { Separator } from "@/components/ui/separator";

const RecipeDetailsSkeleton = () => {
    return (
        <PageLayout paddingSize="compact">
            {/* Breadcrumb Skeleton */}
            <div className="flex items-center space-x-2 mb-4">
                <Skeleton className="h-4 w-16" />
                <Skeleton className="h-4 w-4" />
                <Skeleton className="h-4 w-24" />
                <Skeleton className="h-4 w-4" />
                <Skeleton className="h-4 w-32" />
            </div>

            {/* Top Image Skeleton */}
            <Skeleton className="w-full h-64 md:h-[500px] rounded-lg" />

            {/* Main Content Grid */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mt-6">
                {/* Left Column */}
                <div className="md:col-span-2">
                    {/* Recipe Header Skeleton */}
                    <div className="flex flex-col md:flex-row justify-between md:items-start mb-6">
                        <div className="mb-4 md:mb-0 space-y-3 w-full">
                            <Skeleton className="h-8 w-3/4" />
                            <Skeleton className="h-4 w-full" />
                            <div className="flex items-center gap-4">
                                <Skeleton className="h-6 w-20" />
                                <Skeleton className="h-6 w-20" />
                                <Skeleton className="h-6 w-20" />
                            </div>
                            <div className="flex flex-wrap items-center gap-2 mt-4">
                                <Skeleton className="h-6 w-16" />
                                <Skeleton className="h-6 w-20" />
                                <Skeleton className="h-6 w-24" />
                            </div>
                        </div>
                        <div className="flex items-center gap-2">
                            <Skeleton className="h-10 w-10 rounded-md" />
                            <Skeleton className="h-10 w-36 rounded-md" />
                        </div>
                    </div>
                    <Separator className="my-4"/>

                    {/* Tabs Skeleton */}
                    <div className="space-y-6">
                        <div className="flex items-center gap-4">
                            <Skeleton className="h-10 w-24" />
                            <Skeleton className="h-10 w-24" />
                            <Skeleton className="h-10 w-24" />
                        </div>
                        <div className="space-y-4 mt-6">
                            <div className="border rounded-lg p-6 space-y-4">
                                <Skeleton className="h-6 w-1/4 mb-4" />
                                <Skeleton className="h-4 w-full" />
                                <Skeleton className="h-4 w-5/6" />
                                <Skeleton className="h-4 w-full" />
                            </div>
                        </div>
                    </div>
                </div>

                {/* Right Column Skeleton */}
                <div className="space-y-6">
                    <div className="border rounded-lg p-6 space-y-4">
                        <Skeleton className="h-6 w-1/2 mb-4" />
                        <div className="flex justify-between">
                            <Skeleton className="h-4 w-1/4" />
                            <Skeleton className="h-4 w-1/4" />
                        </div>
                        <div className="flex justify-between">
                            <Skeleton className="h-4 w-1/4" />
                            <Skeleton className="h-4 w-1/4" />
                        </div>
                        <div className="flex justify-between">
                            <Skeleton className="h-4 w-1/4" />
                            <Skeleton className="h-4 w-1/4" />
                        </div>
                        <div className="flex justify-between">
                            <Skeleton className="h-4 w-1/4" />
                            <Skeleton className="h-4 w-1/4" />
                        </div>
                    </div>
                </div>
            </div>
        </PageLayout>
    );
};

export default RecipeDetailsSkeleton;