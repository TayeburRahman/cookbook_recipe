import React from 'react';
import PageLayout from '@/tools/PageLayout';
import { Card } from "@/components/ui/card";
import { Carousel, CarouselContent, CarouselItem } from "@/components/ui/carousel";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Star } from 'lucide-react';
import Title from '../ui/Title';

const testimonials = [
    {
        id: 1,
        name: 'Daniel Martin',
        role: 'Food Enthusiast',
        avatar: 'https://avatar.iran.liara.run/public/boy',
        rating: 4,
        text: 'As a busy mom of two, I love how I can plan meals ahead of time and avoid last-minute stress. Plus, my kids are actually excited about dinner now!',
    },
    {
        id: 2,
        name: 'Eleanor Pena',
        role: 'Marathon Runner',
        avatar: 'https://avatar.iran.liara.run/public/girl',
        rating: 5,
        text: 'The nutrition tracker is a game-changer. I can finally see if I\'m hitting my protein and calorie goals without using 3 different apps.',
    },
    {
        id: 3,
        name: 'Ronald Richards',
        role: 'Fitness Coach',
        avatar: 'https://avatar.iran.liara.run/public/boy',
        rating: 5,
        text: 'I\'ve tried many recipe websites, but this one truly feels like having a personal kitchen assistant. The premium recipes are worth every penny.',
    },
    {
        id: 4,
        name: 'Jenny Wilson',
        role: 'Home Cook',
        avatar: 'https://avatar.iran.liara.run/public/girl',
        rating: 5,
        text: 'The variety of recipes is incredible. I never get bored and my family loves trying new things. The shopping list feature is a lifesaver!',
    }
];

// Helper to render stars
const renderStars = (rating) => {
    const stars = [];
    for (let i = 1; i <= 5; i++) {
        stars.push(
            <Star
                key={i}
                className={`w-5 h-5 ${i <= rating ? 'text-yellow-400 fill-yellow-400' : 'text-gray-300'}`}
            />
        );
    }
    return <div className="flex gap-1">{stars}</div>;
};


const ClientSays = () => {
    const [api, setApi] = React.useState(null);
    const [current, setCurrent] = React.useState(0);

    React.useEffect(() => {
        if (!api) return;
        setCurrent(api.selectedScrollSnap());
        const onSelect = () => {
            setCurrent(api.selectedScrollSnap());
        };
        api.on("select", onSelect);
        return () => api.off("select", onSelect);
    }, [api]);

    return (
        <PageLayout>
                {/* Title Section */}
                <div className="text-center mb-12">
                    <Title title="What Our Customer Say" />
                    <p className="mt-4 text-lg text-muted-foreground max-w-2xl mx-auto">
                        Our recipe planner is helping families, fitness coaches, and foodies eat better.
                    </p>
                </div>

                {/* Carousel */}
                <Carousel setApi={setApi} opts={{ align: "start", loop: true }} className="w-full">
                    <CarouselContent>
                        {testimonials.map((testimonial) => (
                            <CarouselItem key={testimonial.id} className="md:basis-1/2 lg:basis-1/3">
                                <div className="p-4 h-full">
                                    <Card className="h-full flex flex-col justify-between p-8 rounded-2xl shadow-sm">
                                        <div>
                                            {renderStars(testimonial.rating)}
                                            <p className="mt-5 text-muted-foreground text-sm">{testimonial.text}</p>
                                        </div>
                                        <div className="flex items-center gap-4 mt-6">
                                            <Avatar className='w-14 h-14'>
                                                <AvatarImage src={testimonial.avatar} alt={testimonial.name} />
                                                <AvatarFallback>{testimonial.name.charAt(0)}</AvatarFallback>
                                            </Avatar>
                                            <div>
                                                <p className="font-medium  text-lg">{testimonial.name}</p>
                                                <p className="text-xs text-muted-foreground font-medium">{testimonial.role}</p>
                                            </div>
                                        </div>
                                    </Card>
                                </div>
                            </CarouselItem>
                        ))}
                    </CarouselContent>
                </Carousel>

                {/* Dots Navigation */}
                <div className="flex justify-center gap-2 mt-8">
                    {testimonials.map((_, i) => (
                        <button
                            key={i}
                            onClick={() => api?.scrollTo(i)}
                            className={`h-2 rounded-full transition-all duration-300 ${current === i ? 'w-6 bg-primary' : 'w-2 bg-gray-300'}`}
                            aria-label={`Go to slide ${i + 1}`}
                        />
                    ))}
                </div>
        </PageLayout>
    );
};

export default ClientSays;
