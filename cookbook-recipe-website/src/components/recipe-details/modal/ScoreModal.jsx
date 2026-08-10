import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { StarRating } from '@/tools/StarRating';
import { useSendSatietyReviewMutation } from '@/redux/feature/recipe/recipeApi';


const ScoreModal = ({ isOpen, onClose, recipe }) => {
    const [rating, setRating] = useState(0);

    const [sendScore, { isLoading }] = useSendSatietyReviewMutation();

    const handleSubmit = (e) => {
        e.preventDefault();
        try {
            sendScore({ recipeId: recipe._id, ratting: rating });
            onClose(false);
        } catch (error) {
            console.log(error);
        }
    };

    return (
        <Dialog open={isOpen} onOpenChange={onClose}>
            <DialogContent className="sm:max-w-[425px]">
                <DialogHeader>
                    <DialogTitle className="text-xl text-center">Satiety Score</DialogTitle>
                    <DialogDescription className="sr-only">
                        Satiety Score
                    </DialogDescription>
                </DialogHeader>
                <form onSubmit={handleSubmit} className="space-y-6">
                    <div className="grid justify-items-center">
                        <StarRating
                            gap={4}
                            size={22}
                            rating={rating}
                            onRate={setRating} />
                    </div>
                    <Button loading={isLoading} type="submit" className="w-full">Submit</Button>
                </form>
            </DialogContent>
        </Dialog>
    );
};

export default ScoreModal;
