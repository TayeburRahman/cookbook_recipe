import { Document, Schema, Types } from "mongoose";

interface IDay {
    day: string;
    recipes: Types.ObjectId[];
}


export interface ISpeedPrep {
    ingredient: string; 
    steps: string[];   
}

export interface IPrepItem {
    name: string;
    amount: string;
    instruction: string;
    storage: string;
    usedIn: string; 
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
interface IMealPlanWeek extends Document {
    user: Schema.Types.ObjectId;
    name: string;
    startDate: Date;
    endDate: Date;
    data: IDay[];
    weekendPrepAdvice?:IWeekendPrep;
    createdAt: Date;
    types: string;
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
