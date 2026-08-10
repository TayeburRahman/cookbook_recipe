
import { getImageUrl } from "@/lib/utils";
import { Checkbox } from "../ui/checkbox";
import { Label } from "../ui/label";
import { useToggleIngredientMutation } from "@/redux/feature/grocery/groceryApi";
import { useState } from "react";

const GroceryRecipeCard = ({ image, title, subtitle, ingredients }) => {
    const [toggleIngredient] = useToggleIngredientMutation();
    const [animatingId, setAnimatingId] = useState(null);

    const handleToggle = (ingredientId) => {
        setAnimatingId(ingredientId);
        setTimeout(() => {
            toggleIngredient(ingredientId);
        }, 500); // Animation duration
    };

    return (
        <div className="flex flex-col md:flex-row items-start gap-4 mb-8">
            <div className="flex-shrink-0">
                <img
                    src={getImageUrl(image)}
                    alt={title}
                    className="w-full md:w-40 h-40 object-cover rounded-r-4xl border"
                    onError={(e) => (e.target.src = `https://placehold.co/400?text=${title}&font=roboto`)}
                />
                <h3 className="font-semibold mt-2 text-foreground">{title}</h3>
                <p className="text-sm text-muted-foreground">{subtitle}</p>
            </div>
            <div className="flex-grow md:flex-grow-0">
                <div className="space-y-2">
                    {ingredients.map((ingredient) => (
                        <div
                            key={ingredient._id}
                            className={`flex items-center gap-3 rounded-lg transition-all duration-500 ${animatingId === ingredient._id ? 'animate-ingredient-exit' : ''
                                }`}>
                            <Checkbox
                                id={ingredient._id}
                                className="size-6 rounded-full"
                                checked={ingredient.buy}
                                onCheckedChange={() => handleToggle(ingredient._id)}
                            />
                            <Label htmlFor={ingredient._id} className="text-foreground cursor-pointer">{ingredient.ingredient}</Label>
                        </div>
                    ))}
                </div>
            </div>
        </div>
    );
};

export default GroceryRecipeCard;