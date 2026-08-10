"use client";

import React, { useEffect, useState } from "react";
import Autoplay from "embla-carousel-autoplay";
import {
  Carousel,
  CarouselContent,
  CarouselItem,
} from "@/components/ui/carousel";
import { Button } from "@/components/ui/button";
import frame from "../../../assets/slider/frame.png";

import image1 from "../../../assets/slider/image1.png";
import image2 from "../../../assets/slider/image2.png";
import image3 from "../../../assets/slider/image3.png";
import image4 from "../../../assets/slider/image4.png";
import image5 from "../../../assets/slider/image5.png";
import { Link } from "react-router-dom";


const slides = [
  {
    id: 1,
    image: image2,
  },
  {
    id: 2,
    image: image1,
  },
  {
    id: 3,
    image: image3,
  },
  {
    id: 4,
    image: image4,
  },
  {
    id: 5,
    image: image5,
  },
];

const HeroCarousel = () => {
  const [api, setApi] = useState(null);
  const [current, setCurrent] = useState(0);
  const autoplayPlugin = React.useRef(Autoplay({ delay: 5000, stopOnInteraction: false })).current;

  useEffect(() => {
    if (!api) return;

    setCurrent(api.selectedScrollSnap());
    const onSelect = () => {
      setCurrent(api.selectedScrollSnap());
    };

    api.on("select", onSelect);

    return () => {
      api.off("select", onSelect);
    };
  }, [api]);

  const staticContent = slides[0];

  return (
    <section className="overflow-hidden bg-gradient-to-t from-[#E5FFE4] to-[#0A3507] md:h-[calc(100vh-5rem)]">
      <div className="container mx-auto w-full h-full max-w-7xl flex flex-col-reverse gap-12 md:flex-row items-center justify-between px-4 xl:px-0 py-12 lg:py-16">
        {/* LEFT */}
        <div className="w-full md:w-1/2 text-white">
          <div className="hidden xl:block">
            <img src={frame} className="w-50 h-50" alt={staticContent.title} />
          </div>
          <h1 className="text-center md:text-start text-4xl md:text-5xl lg:text-6xl xl:text-8xl font-caladea font-extrabold">
            The Koumanis Diet Meal Planner
          </h1>
          <p className="mt-6 mx-auto md:mx-0 max-w-sm md:max-w-md text-center md:text-start text-sm md:text-lg text-white/90">Your Personalized Nutrition & Fitness Companion—Now on iPhone & Android</p>
          <div className="flex justify-center md:justify-start mt-8 w-full">
            <Link to="/featured">
              <Button className="md:py-6 md:px-8">Start Learning</Button>
            </Link>
          </div>
        </div>

        {/* RIGHT */}
        <div className="w-full md:w-10/24 flex justify-center relative">
          <Carousel
            setApi={setApi}
            className="w-full"
            opts={{ loop: true, align: "start" }}
            plugins={[autoplayPlugin]}
          >
            <CarouselContent>
              {slides.map((s) => (
                <CarouselItem key={s.id} className="min-w-full">
                  <img src={s.image} alt={s.title} className="w-full object-cover rounded-2xl" />
                </CarouselItem>
              ))}
            </CarouselContent>
          </Carousel>

          {/* Dots */}
          <div className="absolute -bottom-8 left-1/2 -translate-x-1/2 flex gap-3">
            {slides.map((_, i) => (
              <button
                key={i}
                onClick={() => api?.scrollTo(i)}
                className={`w-3 h-3 rounded-full ${current === i ? 'bg-white' : 'bg-white/40'}`}
                aria-label={`Go to slide ${i + 1}`}
              />
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

export default HeroCarousel;
