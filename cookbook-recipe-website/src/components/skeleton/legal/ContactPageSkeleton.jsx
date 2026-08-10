import PageLayout from "@/tools/PageLayout";
import { Skeleton } from "@/components/ui/skeleton";

const ContactPageSkeleton = () => {
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
                <div className="space-y-12">

                    {/* Contact Info Skeleton */}
                    <div>
                        <Skeleton className="h-8 w-1/4 mb-4" />
                        <Skeleton className="h-5 w-2/3 mb-8" />
                        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                            {[...Array(3)].map((_, i) => (
                                <div key={i} className="flex items-start p-4 rounded-lg shadow-sm border">
                                    <Skeleton className="w-8 h-8 mr-4 rounded-full" />
                                    <div className="w-full space-y-2">
                                        <Skeleton className="h-5 w-1/4" />
                                        <Skeleton className="h-5 w-3/4" />
                                    </div>
                                </div>
                            ))}
                        </div>
                    </div>

                    {/* Form and Image Skeleton */}
                    <div className="grid grid-cols-1 md:grid-cols-2 md:gap-20 gap-12 items-start">
                        {/* Form Skeleton */}
                        <div className="h-full border p-6 rounded-lg space-y-6">
                            <Skeleton className="h-8 w-1/3" />
                            <div className="space-y-4">
                                <div>
                                    <Skeleton className="h-5 w-1/4 mb-2" />
                                    <Skeleton className="h-8 w-full" />
                                </div>
                                <div>
                                    <Skeleton className="h-5 w-1/4 mb-2" />
                                    <Skeleton className="h-8 w-full" />
                                </div>
                                <div>
                                    <Skeleton className="h-5 w-1/4 mb-2" />
                                    <Skeleton className="h-20 w-full" />
                                </div>
                                <Skeleton className="h-10 w-1/3" />
                            </div>
                        </div>
                        {/* Image Skeleton */}
                        <div className="mt-8 md:mt-0 min-h-full">
                            <Skeleton className="rounded-lg w-full h-[400px]" />
                        </div>
                    </div>
                </div>
            </PageLayout>
        </>
    );
};

export default ContactPageSkeleton;