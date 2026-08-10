import {
    Accordion,
    AccordionContent,
    AccordionItem,
    AccordionTrigger,
} from "@/components/ui/accordion";
import NoData from "@/components/common/no-data/NoData";
import { Separator } from "../ui/separator";

const Preparation = ({ mealPlan }) => {
    const daysWithRecipes = mealPlan?.data?.filter(day => day.recipes && day.recipes.length > 0) || [];

    if (daysWithRecipes.length === 0) {
        return <NoData message="No preparation steps available. Add some recipes to your plan first." />;
    }

    return (
        <div >
            <Accordion type="single" collapsible className="w-full space-y-4">
                {daysWithRecipes.map((day, index) => (
                    <AccordionItem value={`item-${index}`} key={day._id} className="border rounded-lg last:border-b has-focus-visible:ring-[3px]">
                        <AccordionTrigger className="px-4 text-lg font-semibold cursor-pointer hover:no-underline">
                            {day.day.toUpperCase()}
                        </AccordionTrigger>
                        <AccordionContent className="p-4">
                            {day.recipes.map((recipeItem) => (
                                <div key={recipeItem._id} className="last:border-b-0">
                                    <h4 className="text-xl font-bold text-primary mb-2">{recipeItem.recipe.name}</h4>
                                    
                                    {recipeItem.recipe.ingredients && recipeItem.recipe.ingredients.length > 0 && (
                                        <div className="mb-3">
                                            <h5 className="font-semibold text-sm mb-1">Ingredients:</h5>
                                            <ul className="list-disc list-inside pl-2 text-sm text-muted-foreground">
                                                {recipeItem.recipe.ingredients.map((ingredient, i) => (
                                                    <li key={i}>{ingredient}</li>
                                                ))}
                                            </ul>
                                        </div>
                                    )}

                                    <div>
                                        <h5 className="font-semibold text-sm mb-1">Preparation:</h5>
                                        <p className="text-sm text-muted-foreground">{recipeItem.recipe.prep}</p>
                                    </div>
                                    <Separator className="my-4" />
                                </div>
                            ))}
                        </AccordionContent>
                    </AccordionItem>
                ))}
            </Accordion>
        </div>
    );
};

export default Preparation;
