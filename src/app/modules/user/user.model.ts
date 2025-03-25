import mongoose, { Document, Schema, Model } from "mongoose";
import { IUser } from "./user.interface";



const UserSchema = new Schema<IUser>(
  {
    authId: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      ref: "Auth",
    },
    name: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true,
    },
    profile_image: {
      type: String,
      default: null,
    },
    phone_number: {
      type: String,
      default: null,
    },
    isPhoneNumberVerified: {
      type: Boolean,
      default: false,
    },
    street: {
      type: String,
      default: null,
    },
    neighborhood: {
      type: String,
      default: null,
    },
    mail_types: {
      type: String,
      default: 'None',
      enum: ["None", "Breakfasts", "Lunches and Dinners", "Desserts", "Snacks", "Sides"]
    },
    relevant_dielary: {
      type: String,
      default: null,
    },
    age: {
      type: String,
      default: null,
    },
    weight: {
      type: String,
    },
    hight: {
      type: String,
    },
    activety_lavel: {
      type: String,
    },
    date_of_birth: {
      type: Date,
    },
    amount: {
      type: Number,
      default: 0,
    },
    status: {
      type: String,
      enum: ["active", "deactivate"],
      default: "active",
    },
  },
  {
    timestamps: true,
  }
);

const User: Model<IUser> = mongoose.model<IUser>("User", UserSchema);

export default User;
