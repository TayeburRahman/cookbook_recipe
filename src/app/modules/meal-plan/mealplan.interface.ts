import { Document, Schema, Types } from "mongoose";

interface IDay {
    day: string;
    recipes: Types.ObjectId[];
}
export interface IBakeItem {
    title: string;
    instruction: string;
    ingredients: string[];
}

export interface ISpeedPrepItem {
    item: string;
    action: string;
}

export interface IWeekendPrep {
    bake: IBakeItem[];
    speed_prep: ISpeedPrepItem[];
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
