import CategoryModel from './Category.model';
import { ICategory, TCategoryQuery } from './Category.interface';
import { makeSearchQuery } from '../../../helpers/QueryBuilder';
import convertToSlug from '../../../utils/convertToSlug';
import ApiError from '../../../errors/ApiError';
import uploadToCloudinary from '../../../utils/uploadToCloudinary';
import isNotObjectId from '../../../utils/isNotObjectId';
import { CATEGORY_SEARCHABLE_FIELDS } from './Category.constant';

const createCategoryService = async (req: any, payload: ICategory) => {
  const { name } = payload;

  const slug = convertToSlug(name);

  if (!req.file) {
    throw new ApiError(400, 'Upload an image');
  }

  //check category is already existed
  const category = await CategoryModel.findOne({
    slug,
  });

  if (category) {
    throw new ApiError(409, 'This category already exists.');
  }

  //upload image
  const image = await uploadToCloudinary(req?.file?.path as string, 'category');

  const result = await CategoryModel.create({
    name,
    slug,
    image,
  });
  return result;
};

const getCategoriesService = async (query: TCategoryQuery) => {
  const {
    searchTerm,
    page = 1,
    limit = 10,
    sortOrder = 'desc',
    sortBy = 'createdAt',
    ...filters // Any additional filters
  } = query;

  // 2. Set up pagination
  const skip = (Number(page) - 1) * Number(limit);

  //3. setup sorting
  const sortDirection = sortOrder === 'asc' ? 1 : -1;

  //4. setup searching
  let searchQuery = {};
  if (searchTerm) {
    searchQuery = makeSearchQuery(searchTerm, CATEGORY_SEARCHABLE_FIELDS);
  }

  const result = await CategoryModel.aggregate([
    {
      $match: {
        ...searchQuery, // Apply search query
      },
    },
    { $sort: { [sortBy]: sortDirection } },
    {
      $project: {
        _id: 1,
        name: 1,
        image: 1,
        status: 1,
      },
    },
    { $skip: skip },
    { $limit: Number(limit) },
  ]).collation({ locale: 'en', strength: 2 });

  // total count
  const totalCountResult = await CategoryModel.aggregate([
    {
      $match: {
        ...searchQuery,
      },
    },
    { $count: 'totalCount' },
  ]);

  const totalCount = totalCountResult[0]?.totalCount || 0;
  const totalPages = Math.ceil(totalCount / Number(limit));

  return {
    meta: {
      page: Number(page), //currentPage
      limit: Number(limit),
      totalPages,
      total: totalCount,
    },
    data: result,
  };
};

const getCategoryDropDownService = async () => {
  const result = await CategoryModel.find({ status: 'visible' })
    .select('_id name image')
    .sort('-createdAt');
  return result;
};

const updateCategoryService = async (
  req: any,
  categoryId: string,
  payload: Partial<ICategory>,
) => {
  if (isNotObjectId(categoryId)) {
    throw new ApiError(400, 'categoryId must be a valid ObjectId');
  }

  const existingCategory = await CategoryModel.findById(categoryId);
  if (!existingCategory) {
    throw new ApiError(404, 'This categoryId not found');
  }

  if (payload.name) {
    const slug = convertToSlug(payload.name);
    payload.slug = slug;
    const categoryExist = await CategoryModel.findOne({
      _id: { $ne: categoryId },
      slug,
    });
    if (categoryExist) {
      throw new ApiError(409, 'Sorry, This category already exists.');
    }
  }

  //if image is available
  if (req.file) {
    payload.image = await uploadToCloudinary(
      req?.file?.path as string,
      'category',
    );
  }

  const result = await CategoryModel.updateOne({ _id: categoryId }, payload, {
    runValidators: true,
  });

  return result;
};

const deleteCategoryService = async (categoryId: string) => {
  const category = await CategoryModel.findById(categoryId);
  if (!category) {
    throw new ApiError(404, 'This categoryId not found');
  }

  //check if categoryId is associated with Product
  // const associateWithProduct = await ProductModel.findOne({
  //      categoryId
  // });
  // if(associateWithProduct){
  //     throw new ApiError(409, 'Failled to delete, This category is associated with Product');
  // }

  const result = await CategoryModel.deleteOne({ _id: categoryId });
  return result;
};

export {
  createCategoryService,
  getCategoriesService,
  getCategoryDropDownService,
  updateCategoryService,
  deleteCategoryService,
};
