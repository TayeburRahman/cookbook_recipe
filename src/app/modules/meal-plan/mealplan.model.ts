import mongoose, { Model, Schema, Types } from "mongoose";
import { IDay, IMealPlanCustom, IMealPlanWeek } from "./mealplan.interface";

const daySchema = new Schema<IDay>({
  day: {
    type: String,
    required: true,
    enum: ["Day-1", 'Day-2', "Day-3", "Day-3", "Day-4", "Day-5", "Day-6", "Day-7"]
  },
  recipes: [{
    recipe: { type: Types.ObjectId, ref: "Recipe" },
    ingredients: [{
      ingredient: { type: String },
      buy: { type: Boolean, default: false },
    }]
  }]
});

const MealPlanCustomSchema = new Schema<IMealPlanCustom>({
  user: { type: Types.ObjectId, ref: "Auth" },
  name: { type: String, required: true },
  data: [daySchema],
  types: {
    type: String,
    enum: ['custom', 'featured'],
  },
  createdAt: { type: Date, default: Date.now },
});

const MealPlanWeekSchema = new Schema<IMealPlanWeek>({
  user: { type: Types.ObjectId, ref: "Auth" },
  startDate: { type: Date, required: true },
  endDate: { type: Date, required: true },
  data: [daySchema],
  createdAt: { type: Date, default: Date.now },
});

const MealPlanWeek: Model<IMealPlanWeek> = mongoose.model<IMealPlanWeek>('MealPlanWeek', MealPlanWeekSchema);
const MealPlanCustom: Model<IMealPlanCustom> = mongoose.model<IMealPlanCustom>('IMealPlanCustom', MealPlanCustomSchema);

export { MealPlanWeek, MealPlanCustom };
