import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Textarea } from '@/components/ui/textarea';
import { StarRating } from '@/tools/StarRating';
import { useSendReviewMutation } from '@/redux/feature/recipe/recipeApi';
import { useParams } from 'react-router-dom';


const ReviewModal = ({ isOpen, onClose }) => {
    const { id } = useParams();
    const [rating, setRating] = useState(0);
    const [comment, setComment] = useState('');

    const [sendReview, { isLoading }] = useSendReviewMutation();

    const handleSubmit = (e) => {
        e.preventDefault();
        try {
            sendReview({
                recipeId: id,
                ratting: rating,
                feedback: comment,
            });
            onClose(false);
        } catch (error) {
            console.log(error);
        }
    };

    return (
        <Dialog open={isOpen} onOpenChange={onClose}>
            <DialogContent className="sm:max-w-[425px]">
                <DialogHeader>
                    <DialogTitle className="text-xl text-center">Review</DialogTitle>
                    <DialogDescription className="sr-only">
                        Share your experience with this recipe.
                    </DialogDescription>
                </DialogHeader>
                <form onSubmit={handleSubmit} className="space-y-6">
                    <div className="grid gap-2">
                        <label className="text-sm font-medium">Rating</label>
                        <StarRating rating={rating} onRate={setRating} />
                    </div>
                    <div className="grid gap-2">
                        <label htmlFor="comment" className="text-sm font-medium">Comments</label>
                        <Textarea
                            id="comment"
                            value={comment}
                            onChange={(e) => setComment(e.target.value)}
                            placeholder="Tell us what you think..."
                            rows={4}
                        />
                    </div>
                    <Button loading={isLoading} type="submit" className="w-full">Submit</Button>
                </form>
            </DialogContent>
        </Dialog>
    );
};

export default ReviewModal;
