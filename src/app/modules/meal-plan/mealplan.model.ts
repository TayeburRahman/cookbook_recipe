import mongoose, { Model, Schema, Types } from "mongoose";
import { IDay, IMealPlanCustom, IMealPlanWeek, INotification } from "./mealplan.interface";

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


const MealPlanWeekSchema = new Schema<IMealPlanWeek>({
  user: { type: Types.ObjectId, ref: "Auth" },
  name: { type: String },
  startDate: { type: Date },
  endDate: { type: Date },
  data: [daySchema],
  types: {
    type: String,
    enum: ['week', 'custom', 'featured'],
  },
  createdAt: { type: Date, default: Date.now },
});

const NotificationSchema = new Schema<INotification>({
  user: { type: Types.ObjectId, ref: "Auth" },
  title: { type: String },
  message: { type: String },
  renderId: { type: String },
  isSeen: { type: Boolean },
  createdAt: { type: Date, default: Date.now },
});

const MealPlanWeek: Model<IMealPlanWeek> = mongoose.model<IMealPlanWeek>('MealPlanWeek', MealPlanWeekSchema);
const Notification: Model<INotification> = mongoose.model<INotification>('Notification', NotificationSchema);



export { MealPlanWeek, Notification };
