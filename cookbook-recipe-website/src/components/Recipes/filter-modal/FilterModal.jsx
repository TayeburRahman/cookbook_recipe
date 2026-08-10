import React, { useState } from 'react';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Button } from '@/components/ui/button';
import { Slider } from '@/components/ui/slider';
import FilterDropdown from '../filter-dropdown/FilterDropdown';
import { StarRating } from '@/tools/StarRating';
import { ScrollArea } from '@/components/ui/scroll-area';

const FilterModal = ({ isOpen, onClose, onApplyFilters, onClearFilters }) => {
  // State for filters
  const [category, setCategory] = useState('');
  const [intermittentFasting, setIntermittentFasting] = useState('');
  const [oils, setOils] = useState('');
  const [weightLossMuscleGain, setWeightLossMuscleGain] = useState('');
  const [wholeFoodType, setWholeFoodType] = useState('');
  const [flavorType, setFlavorType] = useState('');
  const [cuisineProfiles, setCuisineProfiles] = useState('');

  // Default ranges
  const [serving, setServing] = useState([3, 6]);
  const [preparationTime, setPreparationTime] = useState([10, 30]);
  const [rating, setRating] = useState(0);
  
  // Track if filters have been modified by user
  const [filtersModified, setFiltersModified] = useState({
    serving: false,
    preparationTime: false,
    rating: false
  });
  
  // Handle serving change
  const handleServingChange = (newValue) => {
    setServing(newValue);
    setFiltersModified(prev => ({ ...prev, serving: true }));
  };
  
  // Handle preparation time change
  const handlePreparationTimeChange = (newValue) => {
    setPreparationTime(newValue);
    setFiltersModified(prev => ({ ...prev, preparationTime: true }));
  };
  
  // Handle rating change
  const handleRatingChange = (newValue) => {
    setRating(newValue);
    setFiltersModified(prev => ({ ...prev, rating: newValue > 0 }));
  };

  const categoryOptions = [
    { value: 'breakfast', label: 'Breakfast' },
    { value: 'lunches-and-dinners', label: 'Lunches & Dinners' },
    { value: 'appetizers', label: 'Appetizers' },
    { value: 'salads', label: 'Salads' },
    { value: 'soups', label: 'Soups' },
    { value: 'desserts', label: 'Desserts' },
    { value: 'smoothies/shakes', label: 'Smoothies/Shakes' },
    { value: 'salad-dressings', label: 'Salad Dressings' },
    { value: 'jams/marmalades', label: 'Jams/Marmalades' },
    { value: 'sides', label: 'Sides' }
  ];

  const intermittentFastingOptions = [
    { value: 'cold', label: 'Cold' },
    { value: 'hot', label: 'Hot' }
  ];

  const oilsOptions = [
    { value: 'oil_free', label: 'Oil Free' },
    { value: 'with_oil', label: 'With Oil' }
  ];

  const weightLossMuscleGainOptions = [
    { value: 'weight_loss', label: 'Weight Loss' },
    { value: 'muscle_gain', label: 'Muscle Gain' },
    { value: 'maintain_weight', label: 'Maintain Weight' }
  ];

  const wholeFoodTypeOptions = [
    { value: 'plant_based', label: 'Plant Based' },
    { value: 'whole_food', label: 'Whole Food' },
    { value: 'paleo', label: 'Paleo' }
  ];

  const flavorTypeOptions = [
    { value: 'sweet', label: 'Sweet' },
    { value: 'savory', label: 'Savory' }
  ];

  const cuisineProfilesOptions = [
    { value: 'african', label: 'African' },
    { value: 'american', label: 'American' },
    { value: 'asian', label: 'Asian' },
    { value: 'chinese', label: 'Chinese' },
    { value: 'cuban', label: 'Cuban' },
    { value: 'east_african', label: 'East African' }
  ];


  const handleApply = () => {
    const filters = {
      category: category || undefined,
      intermittent_fasting: intermittentFasting || undefined,
      oils: oils || undefined,
      weight_loss_muscle_gain: weightLossMuscleGain || undefined,
      whole_food_type: wholeFoodType || undefined,
      flavor_type: flavorType || undefined,
      cuisine_profiles: cuisineProfiles || undefined,
      ...(filtersModified.serving && {
        serving_min: serving[0] || undefined,
        serving_max: serving[1] || undefined
      }),
      ...(filtersModified.preparationTime && {
        prep_time_min: preparationTime[0] || undefined,
        prep_time_max: preparationTime[1] || undefined
      }),
      ...(filtersModified.rating && {
        ratting: rating || undefined
      })
    };

    // Remove undefined values
    const cleanedFilters = Object.fromEntries(
      Object.entries(filters).filter(([, value]) => value !== undefined)
    );

    onApplyFilters(cleanedFilters);
    onClose();
  };

  const handleClear = () => {
    setCategory('');
    setIntermittentFasting('');
    setOils('');
    setWeightLossMuscleGain('');
    setWholeFoodType('');
    setFlavorType('');
    setCuisineProfiles('');
    setServing([2, 4]);
    setPreparationTime([5, 20]);
    setRating(0);
    onClearFilters();
    onClose();
  };

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="sm:max-w-[425px] lg:max-w-[600px] bg-secondary p-6 rounded-lg shadow-lg">
        <DialogHeader className="relative">
          <DialogTitle className="text-2xl font-bold text-center">Filter By Ingredients & More</DialogTitle>
          <DialogDescription className="sr-only">
            Select your preferred filters to narrow down your search.
          </DialogDescription>
        </DialogHeader>

        <ScrollArea className='h-96 md:h-full'>
          <div className="grid gap-4 py-4 mr-4 md:mr-0">
            {/* Filter Categories */}
            <div className="space-y-3">
              <FilterDropdown 
                label="Category" 
                options={categoryOptions} 
                selected={category} 
                onSelect={setCategory} 
              />
              <FilterDropdown 
                label="Hot or Cold" 
                options={intermittentFastingOptions} 
                selected={intermittentFasting} 
                onSelect={setIntermittentFasting} 
              />
              <FilterDropdown 
                label="Oils" 
                options={oilsOptions} 
                selected={oils} 
                onSelect={setOils} 
              />
              <FilterDropdown 
                label="Weight Loss vs. Muscle Gain" 
                options={weightLossMuscleGainOptions} 
                selected={weightLossMuscleGain} 
                onSelect={setWeightLossMuscleGain} 
              />
              <FilterDropdown 
                label="Whole Food Type" 
                options={wholeFoodTypeOptions} 
                selected={wholeFoodType} 
                onSelect={setWholeFoodType} 
              />
              <FilterDropdown 
                label="Flavor Type" 
                options={flavorTypeOptions} 
                selected={flavorType} 
                onSelect={setFlavorType} 
              />
              <FilterDropdown 
                label="Cuisine Profiles" 
                options={cuisineProfilesOptions} 
                selected={cuisineProfiles} 
                onSelect={setCuisineProfiles} 
              />
            </div>
            {/* Serving Slider */}
            <div className="mt-4">
              <div className="flex justify-between items-center mb-2">
                <label className="font-medium">Serving</label>
                <span className="text-sm">Set Manually</span>
              </div>
              <Slider
                min={1}
                max={10}
                step={1}
                value={serving}
                onValueChange={handleServingChange}
                className="w-full [&>span:first-child]:bg-white [&>span:first-child]:text-primary"
              />
              <div className="flex justify-between text-sm mt-1">
                <span>{serving[0]}</span>
                <span>{serving[1]}</span>
              </div>
            </div>

            {/* Preparation Time Slider */}
            <div className="mt-4">
              <div className="flex justify-between items-center mb-2">
                <label className="font-medium">Preparation Time</label>
                <span className="text-sm">Set Manually</span>
              </div>
              <Slider
                min={5}
                max={120}
                step={5}
                value={preparationTime}
                onValueChange={handlePreparationTimeChange}
                className="w-full [&>span:first-child]:bg-white [&>span:first-child]:text-primary"
              />
              <div className="flex justify-between text-sm mt-1">
                <span>{preparationTime[0]} mins</span>
                <span>{preparationTime[1]} mins</span>
              </div>
            </div>

            {/* Rating Filter */}
            <div className="mt-4">
              <div className="flex justify-between items-center mb-2">
                <label className="font-medium">Rating</label>
                <span className="text-sm">All</span>
              </div>
              <StarRating
                rating={rating}
                onRate={handleRatingChange}
                className="w-full"
              />
            </div>
          </div>
        </ScrollArea>

        {/* Action Buttons */}
        <div className="flex flex-col gap-3 mt-6">
          <Button onClick={handleApply} className="w-full bg-primary">
            SHOW RECIPES
          </Button>
          <Button onClick={handleClear} variant="outline" className="w-full hover:bg-primary/10">
            Clear All Filters
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
};

export default FilterModal;
