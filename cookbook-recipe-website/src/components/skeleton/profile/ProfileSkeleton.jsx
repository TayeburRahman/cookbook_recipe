import { Card, CardContent, CardHeader } from '@/components/ui/card';
import { Skeleton } from '@/components/ui/skeleton';

const ProfileSkeleton = () => {
    return (
        <div className='flex flex-col lg:flex-row gap-8'>
            {/* Left Sidebar Skeleton */}
            <div className="w-full lg:w-64 space-y-4">
                <Card className="shadow-none bg-transparent border">
                    <CardContent className="p-6">
                        <div className="flex flex-col justify-center items-center space-y-4">
                            <Skeleton className="h-24 w-24 rounded-full" />
                            <div className="flex flex-col items-center justify-center space-y-2">
                                <Skeleton className="h-6 w-32" />
                                <Skeleton className="h-4 w-40" />
                            </div>
                            <Skeleton className="h-9 w-full" />
                        </div>
                    </CardContent>
                </Card>
                <Skeleton className="h-10 w-full" />
            </div>

            {/* Right Content Skeleton */}
            <div className="flex-1">
                 <Card className="py-6 bg-transparent border">
                    <CardHeader>
                        <Skeleton className="h-8 w-48" />
                        <Skeleton className="h-4 w-full max-w-sm" />
                    </CardHeader>
                    <CardContent className="space-y-6">
                        {/* Inputs Grid */}
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div className="space-y-2"><Skeleton className="h-4 w-16" /><Skeleton className="h-10 w-full" /></div>
                            <div className="space-y-2"><Skeleton className="h-4 w-16" /><Skeleton className="h-10 w-full" /></div>
                            <div className="space-y-2"><Skeleton className="h-4 w-16" /><Skeleton className="h-10 w-full" /></div>
                            <div className="space-y-2"><Skeleton className="h-4 w-16" /><Skeleton className="h-10 w-full" /></div>
                        </div>
                        
                        {/* Checkbox Section 1 Skeleton */}
                        <div className="space-y-2">
                            <Skeleton className="h-4 w-16" />
                            <Skeleton className="h-18 w-full" />
                        </div>

                        {/* Checkbox Section 2 Skeleton */}
                        <div className="space-y-2">
                            <Skeleton className="h-4 w-16" />
                            <Skeleton className="h-24 w-full" />
                        </div>

                        {/* Checkbox Section 3 Skeleton */}
                        <div className="space-y-2">
                            <Skeleton className="h-4 w-16" />
                            <Skeleton className="h-24 w-full" />
                        </div>

                        {/* Button Skeleton */}
                        <div className="flex justify-end">
                            <Skeleton className="h-9 w-32" />
                        </div>
                    </CardContent>
                </Card>
            </div>
        </div>
    );
};

export default ProfileSkeleton;