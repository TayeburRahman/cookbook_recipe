import { Document, Schema, Types } from "mongoose";

interface IDay {
    day: string;
    recipes: Types.ObjectId[];
}


export interface ISpeedPrep {
    ingredient: string; 
    steps: {
        _id: string; 
        text: string;
        isDone: boolean;
    }[];   

}

export interface IPrepItem {
    name: string;
    amount: string;
    instruction: string;
    storage: string;
    usedIn: string; 
}
export interface IGroceryItem {
    name: string;
    amount: string;
}

export interface IGroceryCategory {
    department: string;
    items: IGroceryItem[];
}

export interface IPrepSection {
    title: string; 
    items: IPrepItem[];
}
export interface IWeekendPrep {
    sections: IPrepSection[]; // dynamic for  (Bake, Steam, Blend etc)
    speed_prep:ISpeedPrep[]; // for quick chopping or assembly tasks
    prep_notes: string[];
}



//new interface for AI response
export interface IFullMealPlanAIResponse {
    plan_title: string;
    duration: string;
    days: {
        day_number: number;
        meals: {
            type: string; // Breakfast, Lunch, Dinner
            recipe_name: string;
            ingredients: string[];
            instructions: string[];
        }[];
    }[];
    complete_grocery_list: {
        department: string;
        items: {
            ingredient: string;
            amount_to_purchase: string;
        }[];
    }[];
}




interface IMealPlanWeek extends Document {
    user: Schema.Types.ObjectId;
    name: string;
    startDate: Date;
    endDate: Date;
    data: IDay[];
    weekendPrepAdvice?:IWeekendPrep;
    createdAt: Date;
    types: string;
    //new added for grocery list advice
    groceryListAdvice?: IGroceryCategory[]; 
       fullAiPlanData?: IFullMealPlanAIResponse;
}
interface IMealPlanCustom extends Document {
    user: Schema.Types.ObjectId;
    name: string;
    data: IDay[];
    createdAt: Date;
    types: string;
}
interface INotification extends Document {
    user: Schema.Types.ObjectId;
    title: string;
    message: string;
    seen: boolean;
    createdAt: Date;
    renderId: Schema.Types.ObjectId;
}


export { IDay, IMealPlanWeek, IMealPlanCustom, INotification };
