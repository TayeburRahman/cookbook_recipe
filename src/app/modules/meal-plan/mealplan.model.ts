import mongoose, { Model, Schema, Types } from "mongoose";
import { string } from "zod";
import { IDay, IWeek } from "./mealplan.interface";

const daySchema = new Schema<IDay>({
  day: { type: Number, required: true },
  recipes: [{
    recipe: { type: Types.ObjectId, ref: "Recipe" },
    ingredients: [{
      ingredient: { type: String },
      buy: { type: Boolean, default: false },
    }]
  }]
});

const MealPlanSchema = new Schema<IWeek>({
  startDate: { type: Date, required: true },
  endDate: { type: Date, required: true },
  days: [daySchema],
  createdAt: { type: Date, default: Date.now },
});

const MealPlan: Model<IWeek> = mongoose.model<IWeek>('MealPlan', MealPlanSchema);

export { MealPlan };
