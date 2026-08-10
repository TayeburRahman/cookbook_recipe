import { Skeleton } from "@/components/ui/skeleton"

export default function RecipeCardSkeleton({ count = 3 }) {
    return (
        <>
            {[...Array(count)].map((_, i) => (
                <div
                    key={i}
                    className="h-full group block"
                >
                    <div className="h-full flex flex-col md:flex-row overflow-hidden border-0 shadow-sm bg-secondary rounded-xl">

                        {/* Image skeleton */}
                        <div className="w-full md:w-40 h-auto relative flex-shrink-0 overflow-hidden">
                            <Skeleton className="absolute inset-0 rounded-none" />
                        </div>

                        {/* Content skeleton */}
                        <div className="p-2 flex-grow flex flex-col md:w-2/3">
                            <div className="flex justify-between items-start mb-3">
                                <Skeleton className="h-6 w-20 rounded-full" />
                                <Skeleton className="h-8 w-8 rounded-full" />
                            </div>

                            <div className="mb-2">
                                <Skeleton className="h-5 w-3/4" />
                                <Skeleton className="h-5 w-1/2 mt-2" />
                            </div>

                            <div className="flex items-center justify-between mt-auto pt-3 border-t">
                                <div className="flex items-center gap-3">
                                    <Skeleton className="h-4 w-16" />
                                    <Skeleton className="h-4 w-12" />
                                </div>
                                <Skeleton className="h-7 w-28 rounded-full" />
                            </div>
                        </div>
                    </div>
                </div>
            ))}
        </>
    )
}
