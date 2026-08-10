import { useToggleFavoriteRecipeMutation } from "@/redux/feature/recipe/recipeApi";
import { useEffect, useState } from "react";

const useFavorite = (initialState) => {
    const [isFavorite, setIsFavorite] = useState(initialState);
    const [toggleFavoriteRecipe] = useToggleFavoriteRecipeMutation(isFavorite);

    useEffect(() => {
        setIsFavorite(initialState || false);
    }, [initialState]);

    const onFavoriteToggle = async (id) => {
        setIsFavorite(!isFavorite)
        try {
            await toggleFavoriteRecipe(id)
        } catch (error) {
            console.log(error)
        }
    }

    return { isFavorite, onFavoriteToggle }
}

export default useFavorite;