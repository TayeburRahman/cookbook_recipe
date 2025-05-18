import { Document, Schema, Types } from "mongoose";

interface IDay {
    day: string;
    recipes: Types.ObjectId[];
}
interface IMealPlanWeek extends Document {
    user: Schema.Types.ObjectId;
    name: string;
    startDate: Date;
    endDate: Date;
    data: IDay[];
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
    isSeen: boolean;
    createdAt: Date;
    renderId: Schema.Types.ObjectId;
}


export { IDay, IMealPlanWeek, IMealPlanCustom, INotification };
