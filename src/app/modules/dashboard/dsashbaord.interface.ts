import { Types } from "mongoose";

export type ISubscriptions = {
  name: string;
  duration: string;
  fee: Number;
  description: string
};

export interface INutritional {
  calories: number;
  protein: number;
  carbs: number;
  fat: number;
  fiber: number;
  sugars: number;
  saturated_fat: number;
  sodium: number;
}

export interface IRecipe extends Document {
  name: string;
  creator: Types.ObjectId;
  duration: string;
  ingredients: string[];
  instructions: string;
  nutritional: INutritional;
  category: string;
  image: string;
  meal_type: string;
  temperature: string;
  flavor_type: string;
  cuisine_profiles: string;
  kid_approved: boolean;
  no_weekend_prep: boolean;
  time: string;
  serving_size: String;
  ratting: number;
  fevorite: Types.ObjectId[];
}

export interface IReview extends Document {
  userId: Types.ObjectId;
  review: number;
  feedback: string;
}


export interface IComment extends Document {
  userId: Types.ObjectId;
  replay: Types.ObjectId;
  text: string;
}


// export interface IComment extends Document {
//   userId: Types.ObjectId;
//   replay: Types.ObjectId;
//   text: string;
// } 