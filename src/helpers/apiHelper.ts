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
// src/helpers/apiHelper.ts
import Groq from "groq-sdk";
import config from "../config";

const groq = new Groq({ apiKey: config.groq_api_key });

export const getAIWeekendPrep = async (ingredientData: any[]) => {
  try {
    const response = await groq.chat.completions.create({
      model: "llama-3.3-70b-versatile",
      messages: [
        {
          role: "system",
          content: `You are a professional chef. For "speed_prep", you MUST group tasks by ingredient. 
          Example:
          "speed_prep": [
            {
              "ingredient": "1/2 red bell pepper",
              "steps": ["1/2 cut into matchsticks"]
            }
          ]`
        },
        {
          role: "user",
          content: `Analyze these ingredients and recipes: ${JSON.stringify(ingredientData)}.
          
          Structure the response EXACTLY like this JSON example:
          {
            "sections": [
              {
                "title": "BAKE",
                "items": [
                  {
                    "name": "Sweet Potatoes",
                    "amount": "2 large",
                    "instruction": "Preheat oven to 400°F. Bake for 45 mins.",
                    "storage": "Airtight container for 5 days",
                    "usedIn": "Savory Sweet Potato Toasts"
                  }
                ]
              }
            ],
            "speed_prep": [
              {
                "ingredient": "1/2 red bell pepper",
                "steps": ["1/2 cut into matchsticks"]
              }
            ],
            "prep_notes": ["Tip 1"]
          }`
        }
      ],
      response_format: { type: "json_object" },
      temperature: 0.1,
    });

    const aiResult = JSON.parse(response.choices[0].message.content || "{}");
    return aiResult;
  } catch (error) {
    console.error("Groq API Error:", error);
    throw new Error("AI failed to generate response");
  }
};