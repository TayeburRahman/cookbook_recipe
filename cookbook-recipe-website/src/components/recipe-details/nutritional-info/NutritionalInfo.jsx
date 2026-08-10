import React from 'react';
import { Separator } from '@/components/ui/separator';

const NutritionalInfo = ({
  calories,
  protein,
  carbs,
  fat,
  fiber
}) => {
  const nutritionalData = [
    { label: 'Calories', value: `${calories} kcal` },
    { label: 'Protein', value: `${protein}g` },
    { label: 'Carbs', value: `${carbs}g` },
    { label: 'Fat', value: `${fat}g` },
    { label: 'Fiber', value: `${fiber}g` },
  ];

  return (
    <div className="border rounded-lg p-6">
      <h3 className="text-xl font-bold mb-4">Nutritional Information</h3>
      <div className="space-y-3">
        {nutritionalData.map((item, index) => (
          <React.Fragment key={item.label}>
            <div className="flex justify-between items-center">
              <span className="text-muted-foreground">{item.label}</span>
              <span className="font-medium">{item.value}</span>
            </div>
            {index < nutritionalData.length - 1 && <Separator />}
          </React.Fragment>
        ))}
      </div>
    </div>
  );
};

export default NutritionalInfo;