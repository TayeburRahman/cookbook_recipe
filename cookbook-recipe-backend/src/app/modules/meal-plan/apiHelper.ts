import OpenAI from "openai";
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});
export const getAIFullMealPlanAndGrocery = async (mealPlanData: any[]) => {
  const prompt = `
    You are an expert culinary nutritionist and professional grocery organizer.
    Input Data: ${JSON.stringify(mealPlanData)}

    TASK:
    Based on the provided recipes and days, generate a comprehensive Meal Plan and a consolidated "COMPLETE GROCERY LIST".

    STRUCTURE REQUIREMENTS:

    1. MEAL PLAN OVERVIEW:
       - Maintain the "Day X" structure.
       - For each day, include "Breakfast", "Lunch", and "Dinner".
       - For each meal, provide: "Recipe Name", "Ingredients (with measurements)", and "Instructions".

    2. COMPLETE GROCERY LIST (The most important part):
       - CONSOLIDATE: You must scan all recipes. If an ingredient appears in multiple recipes, sum the total quantity (e.g., if Day 1 needs 1/2 onion and Day 3 needs 1 onion, the grocery list should say "2 onions" or "1 bag").
       - PURCHASE SIZE: Instead of just raw measurements, suggest standard supermarket purchase sizes (e.g., "1 bag (16 oz)", "1 bulb", "1 loaf", "1 jar", "1 container").
       - CATEGORIZE: Group ingredients strictly into these exact Aisles/Departments:
         - FRESH PRODUCE
         - PLANT MILK
         - BREAD & BAKED GOODS
         - FROZEN
         - CANNED & PRESERVED GOODS
         - HERBS & SPICES
         - CONDIMENTS & SAUCES
         - BAKING SUPPLIES
         - WORLD CUISINE
         - GRAIN / RICE / PASTA
         - REFRIGERATED
         - SEAFOOD
         - MEAT
         - NUTS & SEEDS

    STRICT JSON OUTPUT FORMAT:
    {
      "plan_title": "THE KOUMANIS DIET",
      "duration": "7-Day Meal Plan",
      "days": [
        {
          "day": 1,
          "meals": [
            {
              "category": "Breakfast",
              "recipe_name": "String",
              "ingredients": ["String - measurement"],
              "instructions": ["String"]
            }
          ]
        }
      ],
      "complete_grocery_list": [
        {
          "department": "Produce Department",
          "items": [
            { "name": "Bananas", "amount_to_purchase": "1" },
            { "name": "Blueberries", "amount_to_purchase": "1 pint" }
          ]
        }
      ]
    }

    Rules:
    - Do not return any text other than the JSON.
    - If a department has no items, do not include it.
    - Ensure instructions are clear and step-by-step.
  `;

  try {
    const response = await openai.chat.completions.create({
      model: "gpt-4o-mini",
      messages: [
        { role: "system", content: "You are a professional nutritionist that provides meal plans and consolidated shopping lists in strict JSON format." },
        { role: "user", content: prompt }
      ],
      response_format: { type: "json_object" },
      temperature: 0.3, 
    });

    return JSON.parse(response.choices[0].message.content || "{}");
  } catch (error) {
    console.error("OpenAI API Error:", error);
    return null;
  }
};