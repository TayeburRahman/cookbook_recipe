import React from 'react';
import PageLayout from '@/tools/PageLayout';
import Title from '../ui/Title';
import { Link } from 'react-router-dom';
import { Slice, UtensilsCrossed, Cake } from 'lucide-react';

const diatGoals = [
    {
        name: 'Weight & Muscle',
        category: "weight_and_muscle",
        icon: <Slice className="w-12 h-12" />
    },
    {
        name: 'Weight Loss',
        category: "weight_loss",
        icon: <UtensilsCrossed className="w-12 h-12" />
    },
    {
        name: 'Muscle Gain',
        category: "muscle_gain",
        icon: <Cake className="w-12 h-12" />
    }
];

const DietGoals = () => {
    return (
        <PageLayout>
            <div className="text-center mb-12">
                <Title title="Diet Goals" />
            </div>

            <div className="grid grid-cols-2 md:grid-cols-3 gap-8">
                {diatGoals.map((goal, i) => (
                    <Link
                        to={`/diet-goals/${goal.category.toLowerCase()}`}
                        className="group"
                        key={i}
                    >
                        <div className="bg-secondary rounded-2xl p-6 flex flex-col items-center justify-center shadow-sm aspect-video">
                            <div className="group-hover:scale-95 transition-all duration-300 bg-card p-6 rounded-lg flex-grow flex items-center justify-center w-full">
                                {goal.icon}
                            </div>
                            <p className="mt-4 text-lg font-semibold text-primary dark:text-foreground">{goal.name}</p>
                        </div>
                    </Link>
                ))}
            </div>
        </PageLayout>
    );
};

export default DietGoals;
