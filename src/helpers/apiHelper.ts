
import Groq from "groq-sdk";
import config from "../config";

const groq = new Groq({ apiKey: config.groq_api_key });

export const getAIWeekendPrep = async (ingredients: string[]) => {
  const prompt = `
    Analyze these ingredients for a weekly meal plan: ${ingredients.join(", ")}.
    Create a "Weekend Prep" guide to save time during the week.
    
    Categorize into:
    1. BAKE: Items to roast/bake ahead (e.g., Sweet Potatoes, Beets).
    2. SPEED PREP: Items to chop, slice, or mince (e.g., Peppers, Celery).
    3. PREP NOTES: Important storage or preparation tips.

    Return ONLY a JSON object in this format:
    {
      "bake": [{"title": "String", "instruction": "String", "ingredients": ["String"]}],
      "speed_prep": [{"item": "String", "action": "String"}],
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