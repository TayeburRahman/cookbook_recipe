import Groq from "groq-sdk";
import config from "../config";

const groq = new Groq({ apiKey: config.groq_api_key });

export const getAIWeekendPrep = async (ingredients: string[]) => {
  const prompt = `
    You are an expert Executive Chef specialized in weekend meal preparation for a full 7-day weekly meal plan.
    Analyze these ingredients: ${ingredients.join(", ")}.
    
    Create a highly detailed preparation guide in JSON format. The goal is to do most of the work on the weekend to save time during the week.

    JSON Structure Requirements:
    1. BAKE Section: 
       Identify root vegetables (potatoes, beets, etc.) or proteins that can be roasted ahead. 
       - title: (e.g., "BAKE SWEET POTATOES")
       - ingredients: Specific items to bake (e.g., "2 sweet potatoes")
       - instruction: Provide a full cooking method (oven temp, tray prep, timing, and cooling).
       - storage: How to store them (e.g., "Store in an airtight container for up to 5 days").

    2. SPEED PREP Section: 
       Focus on vegetables that can be pre-cut.
       - item: The specific vegetable (e.g., "1/2 red bell pepper")
       - action: Specific knife skill (e.g., "cut into 1/4-inch matchsticks").

    3. PREP NOTES Section: 
       General professional chef tips for the 7-day storage.

    Return ONLY this JSON structure:
    {
      "bake": [
        {
          "title": "String",
          "ingredients": "String",
          "instruction": "String",
          "storage": "String"
        }
      ],
      "speed_prep": [
        { "item": "String", "action": "String" }
      ],
      "prep_notes": ["String"]
    }
  `;

  try {
    const response = await groq.chat.completions.create({
      messages: [{ role: "user", content: prompt }],
      model: "llama-3.3-70b-versatile", 
      response_format: { type: "json_object" },
    });

    return JSON.parse(response.choices[0].message.content || "{}");
  } catch (error) {
    console.error("AI Error:", error);
    return null;
  }
};

// import OpenAI from "openai";
// import config from "../config";


// const openai = new OpenAI({
//   apiKey: process.env.OPENAI_API_KEY, 
// });

// export const getAIWeekendPrep = async (ingredients: string[]) => {
//   const prompt = `
//     You are an expert Executive Chef specialized in weekend meal preparation for a 7-day weekly meal plan.
//     Analyze these ingredients: ${ingredients.join(", ")}.
    
//     Create a highly detailed preparation guide in JSON format. 
    
//     JSON Structure Requirements:
//     1. BAKE: Title, detailed instruction (oven temp, tray prep, cooling), ingredients list, and storage info.
//     2. SPEED PREP: Specific vegetable/item and the knife skill action.
//     3. PREP NOTES: Professional storage tips for 7 days.

//     Return ONLY this JSON structure:
//     {
//       "bake": [{"title": "String", "ingredients": "String", "instruction": "String", "storage": "String"}],
//       "speed_prep": [{"item": "String", "action": "String"}],
//       "prep_notes": ["String"]
//     }
//   `;

//   try {
//     const response = await openai.chat.completions.create({
//       model: "gpt-4o-mini",
//       messages: [
//         { role: "system", content: "You are a professional chef assistant." },
//         { role: "user", content: prompt }
//       ],
//       response_format: { type: "json_object" }, 
//     });

//     const content = response.choices[0].message.content;
//     return content ? JSON.parse(content) : null;
//   } catch (error) {
//     console.error("OpenAI API Error:", error);
//     return null;
//   }
// };