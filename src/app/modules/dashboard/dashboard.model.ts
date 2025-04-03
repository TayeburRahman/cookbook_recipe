import mongoose, { Model, Schema, Types } from "mongoose";
import { IComment, INutritional, IRecipe, IReview, ISubscriptions } from "./dsashbaord.interface";
import { string } from "zod";


const SubscriptionSchema = new Schema<ISubscriptions>({
    name: {
        type: String,
        required: true
    },
    duration: {
        type: String,
        required: true,
        enum: ["Monthly", "Yearly"]
    },
    fee: {
        type: Number,
        required: true
    },
    description: {
        type: String,
        required: true
    }
}, { timestamps: true });


const CommentSchema = new Schema<IComment>({
    userId: {
        type: Schema.Types.ObjectId,
        ref: "User",
        required: true
    },
    replay: {
        type: Schema.Types.ObjectId,
        ref: "Comment"
    },
    text: {
        type: String,
        required: true
    }
})

const ReviewSchema = new Schema<IReview>({
    userId: {
        type: Schema.Types.ObjectId,
        ref: "User",
        required: true,
    },
    review: {
        type: Number,
        required: true,
        min: 1,
        max: 5,
    },
    feedback: {
        type: String,
        required: true,
    },
});

const nutritionalSchema = new Schema<INutritional>({
    calories: { type: Number, required: true },
    protein: { type: Number, required: true },
    carbs: { type: Number, required: true },
    fat: { type: Number, required: true },
    fiber: { type: Number, required: true }
})

const RecipeSchema = new Schema<IRecipe>({
    creator: {
        type: Schema.Types.ObjectId,
        ref: "Auth"
    },
    image: {
        type: [String],
        required: true
    },
    name: {
        type: String,
        required: true
    },
    ingredients: {
        type: [String],
        required: true
    },
    instructions: {
        type: String,
        required: true
    },
    nutritional: {
        type: nutritionalSchema,
        required: true
    },
    category: {
        type: String,
        required: true,
        enum: ['breakfast', 'lunches-and-dinners', 'desserts', 'snacks', 'sides'],
    },
    holiday_recipes: {
        type: String,
    },
    oils: {
        type: String,
        enum: ['oil_free', 'with_oil']
    },
    serving_temperature: {
        type: String,
        enum: ['Cold', 'Hot']
    },
    flavor: {
        type: String,
        enum: ['Sweet', 'Savory']
    },
    weight_and_muscle: {
        type: String,
        enum: ['weight_loss', 'muscle_gain']
    },
    whole_food_type: {
        type: String,
        enum: ['plant_based', 'whole_food', "paleo"]
    },
    serving_size: {
        type: Number,
    },
    prep_time: {
        type: Number
    },
    recipe_tips: {
        type: String
    },
    kid_approved: {
        type: Boolean,
        default: false
    },
    no_weekend_prep: {
        type: Boolean,
        default: false
    },
    ratting: {
        type: Number,
        required: true,
        default: 5,
    },
    fevorite: {
        type: [Schema.Types.ObjectId],
        ref: 'User',
        default: [],
    }
});
// const 

const Subscription: Model<ISubscriptions> = mongoose.model<ISubscriptions>('Subscription', SubscriptionSchema);
const Recipe: Model<IRecipe> = mongoose.model<IRecipe>('Recipe', RecipeSchema);
const Comment: Model<IComment> = mongoose.model<IComment>('Comment', CommentSchema);
const Review: Model<IReview> = mongoose.model<IReview>('Review', ReviewSchema);
// const
export { Subscription, Recipe, Comment, Review };


// enum: ["African", "American", "Asian", "Caribbean", "Chinese", "Cuban", "East-African", "Ethiopian", "European", "French", "German", "Greek", "Indian", "Irish", "Israeli", "Italian", "Jamaican", "Japanese", "Korean", "Latin-American", "Mediterranean", "Mexican", "Middle-Eastern", "Moroccan", "North-African", "Persian", "Peruvian", "Puerto-Rican", "Russian", "Spanish", "Tex-Mex", "Thai", "Vietnamese", "West-African"],
