import { model, Schema } from 'mongoose';
import { ICategory } from './Category.interface';

const categorySchema = new Schema<ICategory>(
  {
    name: {
      type: String,
      required: true,
      trim: true,
      unique: true,
    },
    slug: {
      type: String,
      required: true,
      trim: true,
      enum: ['breakfast', 'lunches-and-dinners', 'appetizers', 'salads', 'soups', 'desserts', 'smoothies/shakes', 'salad-dressings', 'jams/marmalades', 'sides']
    },
    image: {
      type: String,
      required: true,
      trim: true,
    },
    status: {
      type: String,
      enum: ['visible', 'hidden'],
      default: 'visible',
    },
  },
  {
    timestamps: true,
    versionKey: false,
  },
);

const CategoryModel = model<ICategory>('Category', categorySchema);
export default CategoryModel;
