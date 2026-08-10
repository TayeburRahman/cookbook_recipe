import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { Plus } from "lucide-react";
import ReviewModal from "../modal/ReviewModal";
import { StarRating } from "@/tools/StarRating";
import { useState } from "react";
import { useParams } from "react-router-dom";
import { useGetRecipeReviewsQuery } from "@/redux/feature/recipe/recipeApi";
import { getImageUrl, timeAgo } from "@/lib/utils";
import useSmartFetchHook from "@/hooks/useSmartFetchHook";
import CustomPagination from "@/components/common/custom-pagination/CustomPagination";
import { Skeleton } from "@/components/ui/skeleton";
import Error from "@/components/common/error/Error";
import NoData from "@/components/common/no-data/NoData";

const Reviews = ({ recipe }) => {
    const { id } = useParams();
    const [isOpen, setIsOpen] = useState(false);

    const {
        currentPage,
        setCurrentPage,
        totalPages,
        items: reviews,
        isLoading,
        isError
    } = useSmartFetchHook(useGetRecipeReviewsQuery, { limit: 5 }, { id });

    return (
        <div className="space-y-8">
            <div>
                <h3 className="text-lg font-medium mb-4">Review & Rating</h3>
                <div className="border rounded-lg p-6 flex flex-col items-center gap-2">
                    <div className="text-5xl font-bold">{Math.floor(recipe.ratting)}</div>
                    <StarRating rating={recipe.ratting} />
                    <div className="text-muted-foreground">({Math.floor(recipe.ratting)} Overall Rating)</div>
                </div>
            </div>

            <div>
                <div className="space-y-6">
                    {isLoading ? (
                        Array.from({ length: 3 }, (_, index) => (
                            <Skeleton key={index} className="w-full h-26" />
                        ))
                    ) : isError ? (
                        <Error msg="Something went wrong" />
                    ) : reviews?.length === 0 ? (
                        <NoData size="noHeight" msg="No reviews found" />
                    ) : reviews?.map((review) => (
                        <div key={review._id} className="border rounded-lg p-6">
                            <div className="flex items-start gap-4">
                                <Avatar className="w-10 h-10">
                                    <AvatarImage src={getImageUrl(review.userId?.profile_image)} />
                                    <AvatarFallback>{review.userId?.name?.charAt(0) || 'U'}</AvatarFallback>
                                </Avatar>
                                <div className="flex-1">
                                    <div className="flex justify-between items-center">
                                        <div>
                                            <div className="font-medium">{review.userId?.name}</div>
                                            {review.createdAt && <div className="text-sm text-muted-foreground">{timeAgo(review.createdAt)}</div>}
                                        </div>
                                        <StarRating rating={review.ratting} />
                                    </div>
                                    <p className="mt-4 text-muted-foreground">{review.feedback}</p>
                                </div>
                            </div>
                        </div>
                    ))}
                </div>
            </div>

            <div>
                {totalPages > 1 && (
                    <div className="absolute bottom-4 left-0 right-0">
                        <CustomPagination
                            currentPage={currentPage}
                            totalPages={totalPages}
                            onPageChange={setCurrentPage}
                        />
                    </div>
                )}
            </div>

            <Button
                onClick={() => setIsOpen(true)}
                variant="outline"
                className="w-full py-6"
            >
                <Plus />
                Add Review
            </Button>

            <ReviewModal
                isOpen={isOpen}
                onClose={setIsOpen}
            />
        </div>
    );
};

export default Reviews;