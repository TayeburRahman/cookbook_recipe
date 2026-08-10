import { CheckCircle2 } from 'lucide-react';
import React from 'react';

const FeatureSection = ({ icon, title, description, features, image, imagePosition = 'left', conclusion }) => {
  const imageOrderClass = imagePosition === 'left' ? 'md:order-1' : 'md:order-2';
  const textOrderClass = imagePosition === 'left' ? 'md:order-2' : 'md:order-1';

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-12 items-center py-6">
      {/* Image Section */}
      <div className={`order-1 ${imageOrderClass}`}>
        <img src={image} alt={title} className="rounded-2xl aspect-video h-auto object-cover" />
      </div>

      {/* Text Section */}
      <div className={`order-2 ${textOrderClass}`}>
        <div className="flex items-center gap-3 mb-4">
          {icon && React.cloneElement(icon, { className: 'w-7 h-7 text-primary' })}
          <h2 className="text-3xl font-bold ">{title}</h2>
        </div>
        <p className="text-muted-foreground mb-6 text-lg">{description}</p>
        <ul className="space-y-3 ml-3">
          {features.map((feature, index) => (
            <li key={index} className="flex items-start text-muted-foreground">
              <CheckCircle2 className="w-5 h-5 text-primary mt-1 mr-3 flex-shrink-0" />
              <span>{feature}</span>
            </li>
          ))}
        </ul>
        <p className="text-muted-foreground mt-6 text-lg">{conclusion}</p>
      </div>
    </div>
  );
};

export default FeatureSection;
