import { Document, Schema, Types } from "mongoose";

interface IDay {
    day: number;
    recipes: Types.ObjectId[];
}

interface IWeek extends Document {
    startDate: Date;
    endDate: Date;
    days: IDay[];
    createdAt: Date;
}

export { IDay, IWeek };
