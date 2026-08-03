import { Request, Response } from "express";
import { UserService } from "./user.service";
import sendResponse from "../../../shared/sendResponse";
import catchAsync from "../../../shared/catchasync";
import { IReqUser } from "../auth/auth.interface";
import { Recipe } from "../dashboard/dashboard.model";
import xlsx from "xlsx";
import fs from "fs";
import path from "path";

const updateProfile = catchAsync(async (req: Request, res: Response) => {
  const result = await UserService.updateMyProfile(req as any);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Profile updated successfully",
    data: result,
  });
});

const getProfile = catchAsync(async (req: Request, res: Response) => {
  const result = await UserService.getProfile(req.user as IReqUser);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "User retrieved successfully",
    data: result,
  });
});

const deleteMyAccount = catchAsync(async (req: Request, res: Response) => {
  await UserService.deleteUSerAccount(req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Account deleted!",
  });
});

const checkTheUserInfo = catchAsync(async (req: Request, res: Response) => {
  const data = await UserService.checkTheUserInfo(req.user as IReqUser);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    data: data,
    message: "Get Successfully!",
  });
});

// ===============================================================================
// ---------------- HELPERS ----------------

// Safely parse a string that should be a JSON array (like "['a', 'b']")
const parseArrayString = (value: string) => {
  if (!value) return [];
  try {
    return JSON.parse(value.replace(/'/g, '"'));
  } catch {
    return [];
  }
};
const parseNutrition = (value: string) => {
  if (!value) return null;

  try {
    const obj = JSON.parse(value.replace(/'/g, '"'));
    return {
      calories: Number(obj.calories) || 0,
      protein: obj.protein ? Number(obj.protein.replace("g", "")) : 0,
      carbs: obj.carbohydrates ? Number(obj.carbohydrates.replace("g", "")) : 0,
      fiber: obj.fiber ? Number(obj.fiber.replace("g", "")) : 0,
      fat: obj.fat ? Number(obj.fat.replace("g", "")) : 0,
    };
  } catch {
    return null;
  }
};

// Normalize category: if valid in enum return as is, else default to 'breakfast'
const validCategories = [
  'breakfast', 'lunches-and-dinners', 'appetizers', 'salads', 'soups', 'desserts', 'smoothies/shakes', 'salad-dressings', 'jams/marmalades', 'sides'
];
const normalizeCategory = (value: string) => {
  const list = parseArrayString(value);
  for (const cat of list) {
    if (validCategories.includes(cat)) {
      return cat;
    }
  }
  return "breakfast";
};

// Normalize temperature
const normalizeTemp = (value: any) => {
  if (typeof value !== "string") return "Cold";
  return value.toLowerCase() === "hot" ? "Hot" : "Cold";
};

const parseBoolean = (value: any) => {
  if (typeof value !== "string") return false;
  return value.toLowerCase() === "true";
};

// ---------------- CONTROLLER ----------------

const exportDataFromFolder = async (req: Request, res: Response) => {
  try {
    const folderPath = path.join(__dirname, "./excel_files");
    const files = fs.readdirSync(folderPath).filter(file => file.endsWith(".xlsx"));

    let allRecipes: any[] = [];

    for (const file of files) {
      const filePath = path.join(folderPath, file);
      const workbook = xlsx.readFile(filePath);
      const sheet = workbook.Sheets[workbook.SheetNames[0]];
      const rows = xlsx.utils.sheet_to_json<any>(sheet);

      const recipes = rows
        .map((row) => ({
          creator: row.creator,
          image: row.image?.match(/https:\/\/[^\s"]+/)?.[0],
          name: row.name,
          ingredients: parseArrayString(row.ingredients),
          instructions: row?.instructions
            ? row.instructions
              .split(/\r?\n/)
              .map((step: string) => step.trim())
              .filter((step: string) => step)
            : [],
          prep: row.prep.split(/\r?\n/)
            .map((step: string) => step.replace(/^\d+\.\s*/, '').trim())
            .filter((step: string) => step)
            .join(' '),
          nutritional: parseNutrition(row.nutritional),
          serving_size: !isNaN(Number(row.serving_size)) ? Number(row.serving_size) : 0,
          prep_time: Number(row.prep_time),
          category: normalizeCategory(row.category),
          oils: row.oils === "with_oil" ? "with_oil" : "oil_free",
          whole_food_type: row.whole_food_type,
          flavor: row.flavor,
          weight_and_muscle: row.weight_and_muscle,
          kid_approved: parseBoolean(row.kid_approved),
          no_weekend_prep: parseBoolean(row.no_weekend_prep),
          holiday_recipes: row.holiday_recipes || null,
          serving_temperature: normalizeTemp(row.serving_temperature),
          rating: row.rating && row.rating > 0 ? row.rating : 5,
          recipe_tips: row.recipe_tips || "",
        }))
        .filter(
          (r) =>
            r.name &&
            r.ingredients.length > 0 &&
            r.instructions &&
            r.nutritional &&
            r.category &&
            r.prep
        );

      allRecipes = allRecipes.concat(recipes);
    }

    if (allRecipes.length === 0) {
      return sendResponse(res, {
        statusCode: 400,
        success: false,
        message: "No valid recipes found to import",
        data: null,
      });
    }

    const result = await Recipe.insertMany(allRecipes);

    sendResponse(res, {
      statusCode: 200,
      success: true,
      message: "All valid Excel data imported successfully",
      data: { totalInserted: result.length },
    });
  } catch (error: any) {
    sendResponse(res, {
      statusCode: 500,
      success: false,
      message: "Excel import failed",
      data: error.message,
    });
  }
};

export const UserController = {
  exportDataFromFolder,
  deleteMyAccount,
  getProfile,
  updateProfile,
  checkTheUserInfo
};

