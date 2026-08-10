import React from 'react';
import PageLayout from '@/tools/PageLayout';
import { Card, CardContent, CardFooter, CardHeader } from "@/components/ui/card";
import { Carousel, CarouselContent, CarouselItem } from "@/components/ui/carousel";
import { Button } from '@/components/ui/button';
import { Heart, Clock, Star, ChevronLeft, ChevronRight } from 'lucide-react';
import Title from '../ui/Title';
import { Link } from 'react-router-dom';
import { useGetFeaturedRecipesQuery } from '@/redux/feature/home/homeApi';
import { getImageUrl } from '@/lib/utils';
import useFavorite from '@/hooks/useFavorite';
import { Badge } from '../ui/badge';

const FeaturedRecipeCard = ({ recipe }) => {
    const { isFavorite, onFavoriteToggle } = useFavorite(recipe.favorite);

    return (
        <CarouselItem key={recipe._id} className="sm:basis-1/2 lg:basis-1/4">
            <Link
                to={`/recipes/recipe-details/${recipe._id}`}
                state={{ from: 'Featured', fromPath: '/#featured-recipes' }}
                className="h-full group transition-all duration-300 hover:-translate-y-1 block"
            >
                <Card className="overflow-hidden group rounded-2xl gap-2">
                    <CardHeader className="p-0 relative">
                        <img
                            src={getImageUrl(recipe.image)}
                            alt={recipe.name}
                            className="w-full h-56 object-cover group-hover:scale-105 transition-transform duration-300"
                            onError={(e) => {
                                e.target.src = `https://placehold.co/400?text=${recipe.name}&font=roboto`;
                            }}
                        />
                        <Button
                            onClick={(e) => {
                                e.preventDefault();
                                e.stopPropagation();
                                onFavoriteToggle(recipe._id);
                            }}
                            variant="ghost"
                            size="icon"
                            className="absolute top-3 right-3 bg-white/20 hover:bg-white/60 backdrop-blur-sm rounded-full h-9 w-9"
                        >
                            <Heart className={isFavorite ? 'fill-red-500 text-red-500' : 'text-white'} />
                        </Button>
                    </CardHeader>
                    <CardContent className="px-4">
                        <Badge variant="secondary" className="capitalize">{recipe.category}</Badge>
                        <h3
                            title={recipe.name}
                            className="text-lg font-medium mt-1 line-clamp-1"
                        >
                            {recipe.name}
                        </h3>
                    </CardContent>
                    <CardFooter className="p-4 pt-0 flex justify-between items-center text-muted-foreground">
                        <div className="flex items-center gap-2 text-sm">
                            <Clock className="w-4 h-4" />
                            <span>{recipe.prep_time}</span>
                        </div>
                        <div className="flex items-center gap-1 text-sm">
                            <Star className="w-4 h-4 text-yellow-400 fill-yellow-400" />
                            <span className="font-medium">{recipe.ratting}</span>
                        </div>
                    </CardFooter>
                </Card>
            </Link>
        </CarouselItem>
    );
}

const FeaturedRecipes = () => {

    const { data: recipes, isLoading, isError } = useGetFeaturedRecipesQuery();
    const [api, setApi] = React.useState(null);

    return (
        <section id='featured-recipes'>
            <PageLayout>
                <div className="flex flex-row justify-between items-center gap-2 mb-8">
                    <Title title="Featured Recipes" />
                    <div className="flex gap-2">
                        <Button variant="outline" size="icon" onClick={() => api?.scrollPrev()}>
                            <ChevronLeft className="h-4 w-4" />
                            <span className="sr-only">Previous slide</span>
                        </Button>
                        <Button variant="outline" size="icon" onClick={() => api?.scrollNext()}>
                            <ChevronRight className="h-4 w-4" />
                            <span className="sr-only">Next slide</span>
                        </Button>
                    </div>
                </div>

                <Carousel setApi={setApi} opts={{ align: "start", loop: true }} className="w-full">
                    <CarouselContent>
                        {isLoading ? (
                            <p>Loading...</p>
                        ) : isError ? (
                            <p>Error fetching recipes</p>
                        ) : recipes?.data?.length === 0 ? (
                            <p>No recipes found</p>
                        ) : (
                            recipes?.data?.result?.slice(0, 6).map((recipe) => (
                                <FeaturedRecipeCard key={recipe._id} recipe={recipe} />
                            ))
                        )}
                    </CarouselContent>
                </Carousel>
            </PageLayout>
        </section>
    );
};

export default FeaturedRecipes;
