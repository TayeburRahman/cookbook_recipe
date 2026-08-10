import { Smartphone } from 'lucide-react';
import apple from '../../assets/apple.png'
import google from '../../assets/google.png'

const GetApp = () => {
    return (
            <div className="bg-card py-5 bg-gradient-to-b from-secondary to-secondary/50">
                <div className="container mx-auto flex flex-col items-center text-center px-4">
                    {/* Title */}
                    <div className="flex items-center gap-3">
                        <Smartphone className="w-8 h-8 text-primary" />
                        <h2 className="text-2xl font-medium ">Get Started Today</h2>
                    </div>

                    {/* Subtitle */}
                    <p className="mt-6 text-lg text-muted-foreground max-w-7xl">
                        Download the Koumanis Diet Meal Planner from the App Store or Google Play to enjoy goal-oriented meals without the guesswork. Say goodbye to skipped meals and grocery store confusion, and embrace simple, smart, and delicious eating.
                    </p>

                    {/* App Store Buttons */}
                    <div className="flex flex-col sm:flex-row items-center gap-6 mt-6">
                        <a href="#" aria-label="Download on the App Store" className="transform hover:scale-105 transition-transform duration-300">
                            <img src={apple} alt="Download on the App Store" className="h-14 w-auto" />
                        </a>
                        <a href="#" aria-label="Get it on Google Play" className="transform hover:scale-105 transition-transform duration-300">
                            <img src={google} alt="Get it on Google Play" className="h-14 w-auto" />
                        </a>
                    </div>
                </div>
            </div>
    );
};

export default GetApp;