
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import Reviews from "../reviews/Reviews";
import Score from "../satiety-score/Score";

const DetailsTabs = ({ recipe }) => {
    const {
        ingredients = [],
        instructions = '',
        recipe_tips = '',
    } = recipe || {};

    // Instructions might be a single string. Let's try to split it into steps.
    const instructionSteps = instructions.split('.').filter(s => s.trim() !== '');

    return (
        <>
            <Tabs defaultValue="description" className="w-full mt-8">
                <TabsList className="justify-start gap-4 bg-transparent">
                    <TabsTrigger value="description" className="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground">Description</TabsTrigger>
                    <TabsTrigger value="reviews" className="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground">Reviews</TabsTrigger>
                    <TabsTrigger value="satiety-score" className="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground">Satiety Score</TabsTrigger>
                </TabsList>
                <TabsContent value="description" className="mt-6">
                    {/* Ingredients */}
                    <div className="mb-8">
                        <h3 className="text-xl font-semibold mb-4">Ingredients</h3>
                        <ul className="space-y-3 ml-2 list-disc list-inside">
                            {ingredients.map((ingredient, index) => (
                                <li key={index}>{ingredient}</li>
                            ))}
                        </ul>
                    </div>

                    {/* Instructions */}
                    <div className="mb-8">
                        <h3 className="text-xl font-semibold  mb-4">Instructions</h3>
                        <ol className="space-y-4 ">
                            {
                                instructionSteps.map((step, index) => (
                                    <li key={index} className="flex items-start gap-3">
                                        <div className="flex-shrink-0 w-8 h-8 rounded-full bg-primary/10 text-primary flex items-center justify-center font-bold">
                                            {index + 1}
                                        </div>
                                        <p className="pt-1">{step.trim()}</p>
                                    </li>
                                ))
                            }
                        </ol>
                    </div>

                    {/* Recipe Tips */}
                    {recipe_tips && (
                        <div>
                            <h3 className="text-xl font-semibold  mb-4">Recipe Tips</h3>
                            <p>{recipe_tips}</p>
                        </div>
                    )}
                </TabsContent>
                <TabsContent value="reviews" className="mt-6">
                    <Reviews recipe={recipe} />
                </TabsContent>
                <TabsContent value="satiety-score" className="mt-6">
                    <Score recipe={recipe} />
                </TabsContent>
            </Tabs>
        </>
    );
};

export default DetailsTabs;