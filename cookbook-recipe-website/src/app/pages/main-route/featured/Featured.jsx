import PageLayout from '@/tools/PageLayout';
import FeatureSection from '@/components/featured/feature-section/FeatureSection';
import { Check } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Link } from 'react-router-dom';
// import GetApp from '@/components/home/GetApp';
import { featureData } from '@/lib/mockData';

const Featured = () => {
    return (
        <>
            <section className="w-full bg-gradient-to-b from-secondary/5 via-secondary/50 to-secondary relative overflow-hidden">
                <PageLayout paddingSize='none'>
                    <div className="grid md:grid-cols-2 gap-12 items-center">
                        <div>
                            <h1 className="text-4xl md:text-5xl font-bold tracking-tight mb-6 leading-tight">
                                Transform Your Health with the <span className="text-green-600">Koumanis Diet</span> Meal Planner
                            </h1>
                            
                            <p className="text-lg text-muted-foreground mb-8">
                                Join thousands who have achieved their health goals with our science-backed meal plans and fitness guidance.
                            </p>

                            <div className="space-y-4 mb-8">
                                {[
                                    "No more guesswork with your nutrition",
                                    "No more boring 'diet food' - enjoy delicious, satisfying meals",
                                    "No more skipped meals or grocery store confusion",
                                    "Just smart, flavorful, goal-aligned eating made simple"
                                ].map((item, i) => (
                                    <div key={i} className="flex items-start gap-3">
                                        <Check className="h-5 w-5 text-green-500 shrink-0 mt-1" />
                                        <span className="text-foreground">{item}</span>
                                    </div>
                                ))}
                            </div>

                            <div className="flex flex-col sm:flex-row gap-4">
                                <Link to="/auth/register" className="w-full sm:w-auto">
                                    <Button 
                                        size="lg" 
                                        className="w-full px-8 py-6 text-base font-medium"
                                    >
                                        Get Started Today
                                    </Button>
                                </Link>
                                <Link to="#app-store" className="w-full sm:w-auto">
                                    <Button 
                                        size="lg" 
                                        variant="outline" 
                                        className="w-full px-8 py-6 text-base font-medium"
                                    >
                                        Get App
                                    </Button>
                                </Link>
                            </div>
                        </div>
                        
                        <div className="relative">
                            <div className="relative z-10 rounded-2xl overflow-hidden border border-border/50 shadow-2xl">
                                <img 
                                    src="/images/diet-app-preview.svg" 
                                    alt="Koumanis Diet App Preview" 
                                    className="w-full h-auto max-w-[280px] mx-auto"
                                    loading="lazy"
                                />
                            </div>
                            <div className="absolute -bottom-4 -right-4 w-24 h-24 bg-primary/10 rounded-full mix-blend-multiply filter blur-xl"></div>
                        </div>
                    </div>
                </PageLayout>
            </section>
            
            <PageLayout>
                <div>
                    {featureData.map(feature => (
                        <FeatureSection key={feature.id} {...feature} />
                    ))}
                </div>
            </PageLayout>
            {/* <GetApp /> */}
        </>
    );
};

export default Featured;
