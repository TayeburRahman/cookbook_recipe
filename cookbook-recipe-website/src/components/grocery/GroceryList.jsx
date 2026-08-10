
const GroceryList = ({ groceryData }) => {
    if (!groceryData || !groceryData.data || groceryData.data.length === 0) {
        return <div>No grocery list available for this plan.</div>;
    }

    return (
        <div className="space-y-8">
            {groceryData.data.map((dayData) => (
                <div key={dayData._id} className="p-4 border rounded-lg">
                    <h2 className="text-xl font-semibold mb-4">{dayData.day}</h2>
                    {dayData.recipes.map((recipeItem) => (
                        <div key={recipeItem._id} className="mb-4">
                            <h3 className="text-lg font-medium">{recipeItem.recipe.name}</h3>
                            <ul className="list-disc list-inside pl-4 mt-2">
                                {recipeItem.ingredients.map((ingredient) => (
                                    <li key={ingredient._id}>{ingredient.ingredient}</li>
                                ))}
                            </ul>
                        </div>
                    ))}
                </div>
            ))}
        </div>
    );
};

export default GroceryList;
