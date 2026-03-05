// // src/helpers/aiHelper.ts
// import OpenAI from "openai";



// const openai = new OpenAI({
//   apiKey: process.env.OPENAI_API_KEY, 
// });

// export const getAIWeekendPrep = async (ingredientsWithRecipes: any[]) => {
//   const prompt = `
//     You are a professional chef. Analyze the following ingredients and their associated recipes:
//     ${JSON.stringify(ingredientsWithRecipes)}

//     Create a Weekend Prep guide by categorizing items into these specific headers if applicable:
//     - BAKE (Oven roasting)
//     - PREPARE GRAINS (Rice, Lentils, Quinoa)
//     - STEAM (Steamed vegetables)
//     - BLEND (Dips, sauces, puddings)
//     - REFRIGERATE (Pickling, chilling, or marinating)
//     - FREEZE (Items that must be frozen)
//     - SPEED PREP (Chopping/Mincing raw veggies)

//     Rules for JSON:
//     1. For BAKE, GRAINS, STEAM, BLEND, REFRIGERATE, FREEZE:
//        Each item must have: "name", "amount", "instruction" (step-by-step), "storage" (how long & where), and "usedIn" (Recipe name).
//     2. For SPEED PREP: List "item" and "action" (e.g., "dice", "slice").
//     3. For PREP NOTES: General tips.

//     Return ONLY this structure:
//     {
//       "sections": [
//         {
//           "title": "BAKE", 
//           "items": [{"name": "", "amount": "", "instruction": "", "storage": "", "usedIn": ""}]
//         },
//         { "title": "PREPARE GRAINS", "items": [...] }
//       ],
//       "speed_prep": [{"item": "", "action": ""}],
//       "prep_notes": [""]
//     }
//   `;

//   const response = await openai.chat.completions.create({
//     model: "gpt-4o-mini",
//     messages: [{ role: "user", content: prompt }],
//     response_format: { type: "json_object" },
//   });

//   return JSON.parse(response.choices[0].message.content || "{}");
// };

// src/helpers/apiHelper.ts
import Groq from "groq-sdk";
import config from "../config";

const groq = new Groq({ apiKey: config.groq_api_key });
interface IIngredientInput {
    recipeName: string;
    ingredients: string[];
}
export const getAIWeekendPrep = async (ingredientData: any[]) => {
const prompt = `
  Analyze these ingredients and recipes: ${JSON.stringify(ingredientData)}.
  
  Create a Weekend Prep guide categorized by cooking method.
  IMPORTANT: Do NOT use a top-level key named "bake". 
  Instead, use a "sections" array where each object has a "title" (like "BAKE", "PREPARE GRAINS", "STEAM", "BLEND").

  Strict JSON Format:
  {
    "sections": [
      {
        "title": "BAKE",
        "items": [{"name": "", "amount": "", "instruction": "", "storage": "", "usedIn": ""}]
      },
      {
        "title": "PREPARE GRAINS",
        "items": [...]
      }
    ],
    "speed_prep": [{"item": "", "action": ""}],
    "prep_notes": [""]
  }
`;

  // Groq API call logic...
  const response = await groq.chat.completions.create({
    messages: [{ role: "user", content: prompt }],
    model: "llama-3.3-70b-versatile",
    response_format: { type: "json_object" },
  });

  return JSON.parse(response.choices[0].message.content || "{}");
};