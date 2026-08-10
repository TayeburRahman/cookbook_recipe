import { Badge } from "../ui/badge";
import MealCard from "./MealCard";
import { Plus } from "lucide-react";

const DayCard = ({ day, meals, nutritionalTotals, onAddRecipeClick}) => {

    return (
        <div className="border p-4 rounded-lg">
            <div className="flex flex-col gap-2 sm:flex-row items-center justify-between mb-4">
                <Badge>
                    {day}
                </Badge>
                <div className="flex flex-wrap items-center gap-2 sm:gap-4 text-sm">
                    <Badge className="bg-orange-200/40 dark:bg-orange-800/20 text-black dark:text-white flex items-center gap-1">
                        🍛 Calories: {nutritionalTotals?.calories || 0}kcal
                    </Badge>
                    <Badge className="bg-blue-200/40 dark:bg-blue-800/20 text-black dark:text-white flex items-center gap-1">
                        🥩 Protein: {nutritionalTotals?.protein || 0}g
                    </Badge>
                    <Badge className="bg-yellow-200/40 dark:bg-yellow-800/20 text-black dark:text-white flex items-center gap-1">
                        🍞 Carbs: {nutritionalTotals?.carbs || 0}g
                    </Badge>
                    <Badge className="bg-pink-200/40 dark:bg-pink-800/20 text-black dark:text-white flex items-center gap-1">
                        🧈 Fat: {nutritionalTotals?.fat || 0}g
                    </Badge>
                </div>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {meals.map((meal, index) => (
                    <div key={index}>
                        <MealCard meal={meal.recipe} day={day}/>
                    </div>
                ))}
                <div 
                    onClick={onAddRecipeClick}
                    className="flex flex-col gap-2 items-center justify-center border-2 border-dashed rounded-lg min-h-[200px] cursor-pointer">
                    <button className="border-2 border-dashed rounded-md p-4 cursor-pointer">
                        <Plus />
                    </button>
                    <p className="text-muted-foreground text-center">
                        Click to add a recipe to this day.
                    </p>
                </div>
            </div>
        </div>
    );
};

export default DayCard;