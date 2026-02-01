import catchAsync from "../../../shared/catchasync";
import sendResponse from "../../../shared/sendResponse";
import { createCategoryService, deleteCategoryService, getCategoriesService, getCategoryDropDownService, updateCategoryService } from "./Category.service";


const createCategory = catchAsync(async (req, res) => {
  const result = await createCategoryService(req, req.body);

  sendResponse(res, {
    statusCode: 201,
    success: true,
    message: "Category is created successfully",
    data: result
  });
});


const getCategories = catchAsync(async (req, res) => {
  const result = await getCategoriesService(req.query);

  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Categories are retrieved successfully',
    meta: result.meta,
    data: result.data,
  });
});


const getCategoryDropDown = catchAsync(async (req, res) => {
  const result = await getCategoryDropDownService();

  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Categories are retrieved successfully",
    data: result
  });
});


const updateCategory = catchAsync(async (req, res) => {
  const { categoryId } = req.params;
  const result = await updateCategoryService(req, categoryId, req.body);

  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Category is updated successfully",
    data: result
  });
});


const deleteCategory = catchAsync(async (req, res) => {
   const { categoryId } = req.params;
  const result = await deleteCategoryService(categoryId);

  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Category is deleted successfully",
    data: result
  });
});


const CategoryController = {
  createCategory,
  getCategories,
  getCategoryDropDown,
  updateCategory,
  deleteCategory
}

export default CategoryController;