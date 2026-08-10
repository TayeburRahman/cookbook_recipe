import DayCard from "./DayCard";

const WeeklyMealPlan = ({ mealPlan, onAddRecipeClick }) => {
    return (
        <div className="space-y-8">
            {mealPlan?.data?.map((dayData) => (
                <DayCard
                    key={dayData._id}
                    day={dayData.day}
                    meals={dayData.recipes}
                    nutritionalTotals={dayData.nutritionalTotals}
                    onAddRecipeClick={() => onAddRecipeClick(dayData.day)}
                />
            ))}
        </div>
    );
};

export default WeeklyMealPlan;