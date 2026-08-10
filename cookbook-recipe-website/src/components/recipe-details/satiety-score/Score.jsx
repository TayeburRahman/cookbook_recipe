import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { StarRating } from "@/tools/StarRating";
import { ArrowDown, Plus } from "lucide-react";
import ScoreModal from "../modal/ScoreModal";
import { useState } from "react";
import { getImageUrl, getInitials, timeAgo } from "@/lib/utils";
import NoData from "@/components/common/no-data/NoData";

const Score = ({ recipe }) => {

    const [isOpen, setIsOpen] = useState(false);
    const { scoreReview = [] } = recipe || {};
    const [showAll, setShowAll] = useState(false);

    return (
        <div className="space-y-8">
            {/* <div>
                <h3 className="text-lg font-medium mb-4">Overview</h3>
                <div className="border rounded-lg p-6 flex flex-col items-center gap-2">
                    <div className="text-5xl font-bold">{ratting?.toFixed(1)}</div>
                    <StarRating rating={ratting} />
                    <div className="text-muted-foreground">({scoreReview?.length} Overall Rating)</div>
                </div>
            </div> */}

            <div>
                <h3 className="text-lg font-medium mb-4">All Satiety Scores</h3>
                <div className="space-y-6">
                    { scoreReview?.length === 0 ? (
                        <NoData size="noHeight" msg="No scores found" />
                    ) : (
                        scoreReview?.slice(0, showAll ? scoreReview?.length : 5).map((review) => (
                        <div key={review?._id} className="border rounded-lg p-6">
                            <div className="flex items-center gap-4">
                                <Avatar className="h-10 w-10">
                                    <AvatarImage src={getImageUrl(review?.userId?.profile_image)} />
                                    <AvatarFallback>{getInitials(review?.userId?.name) || 'U'}</AvatarFallback>
                                </Avatar>
                                <div className="flex-1">
                                    <div className="flex justify-between items-center">
                                        <div>
                                            <div className="font-medium">{review?.userId?.name}</div>
                                            <div className="text-sm text-muted-foreground">{timeAgo(review?.createdAt)}</div>
                                        </div>
                                        <StarRating rating={review?.ratting} />
                                    </div>
                                </div>
                            </div>
                        </div>
                    )))}
                </div>
            </div>

            {scoreReview?.length > 5 && (
                <div className="text-center">
                    <Button
                        variant="outline"
                        onClick={() => setShowAll(!showAll)}>
                        <ArrowDown />
                        {showAll ? 'See Less' : 'See More'}
                    </Button>
                </div>)}

            <Button
                variant="outline"
                className="w-full py-6"
                onClick={() => setIsOpen(true)}
            >
                <Plus />
                Add Score
            </Button>
            <ScoreModal
                isOpen={isOpen}
                onClose={setIsOpen}
                recipe={recipe}
            />
        </div>
    );
};

export default Score;