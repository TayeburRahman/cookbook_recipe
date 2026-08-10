import PageLayout from "@/tools/PageLayout";
import { Skeleton } from "@/components/ui/skeleton";

const LegalSkeleton = () => {
    return (
        <>
            {/* PageHeader Skeleton - with dark background to match screenshot */}
            < div className="bg-secondary flex flex-col justify-center items-center h-42" >
                {/* Title Skeleton */}
                < Skeleton className="h-8 w-1/7 mb-4" />
                {/* Breadcrumbs Skeleton */}
                <div className="flex items-center space-x-2" >
                    <Skeleton className="h-4 w-16" />
                    <Skeleton className="h-4 w-4" />
                    <Skeleton className="h-4 w-24" />
                </div>
            </div >

            <PageLayout paddingSize="none">
                <div className="space-y-6 mt-8">
                    <Skeleton className="h-8 w-1/2" />
                    <div className="space-y-2">
                        <Skeleton className="h-4 w-full" />
                        <Skeleton className="h-4 w-full" />
                        <Skeleton className="h-4 w-3/4" />
                    </div>
                    <div className="space-y-2">
                        <Skeleton className="h-4 w-full" />
                        <Skeleton className="h-4 w-5/6" />
                    </div>
                    <div className="space-y-2">
                        <Skeleton className="h-4 w-full" />
                        <Skeleton className="h-4 w-full" />
                        <Skeleton className="h-4 w-full" />
                        <Skeleton className="h-4 w-1/2" />
                    </div>
                </div>
            </PageLayout>
        </>
    );
};

export default LegalSkeleton;