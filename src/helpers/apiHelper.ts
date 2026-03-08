import OpenAI from "openai";

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY, 
});

export const getAIWeekendPrep = async (ingredientsWithRecipes: any[]) => {
  const prompt = `
    You are an Executive Chef. Analyze these ingredients and their recipes:
    ${JSON.stringify(ingredientsWithRecipes)}

    TASK: Create a professional Weekend Prep guide. 
    
    CRITICAL RULES:
    1. ONLY include a section if there are items for it. (Do not return empty arrays like "items": []).
    2. Category Titles: BAKE, PREPARE GRAINS, STEAM, BLEND, REFRIGERATE, FREEZE.
    3. SPEED PREP Grouping: Group by ingredient. 
       - Header: The ingredient name (e.g., "1/2 red bell pepper")
       - Steps: An array of specific actions (e.g., ["wash and dry", "cut into 1/4-inch matchsticks"])

    Return ONLY this JSON structure:
    {
      "sections": [
        {
          "title": "BAKE", 
          "items": [{ "name": "Pumpkin", "amount": "1 medium", "instruction": "...", "storage": "...", "usedIn": "..." }]
        }
      ],
      "speed_prep": [
        {
          "ingredient": "1/2 red bell pepper",
          "steps": ["cut into 1/4-inch matchsticks"]
        },
        {
          "ingredient": "2 sweet potatoes",
          "steps": ["peel and cube into 1-inch pieces"]
        }
      ],
      "prep_notes": ["General tip 1"]
    }
  `;

  const response = await openai.chat.completions.create({
    model: "gpt-4o-mini",
    messages: [
      { role: "system", content: "You are a professional chef. You provide only valid JSON without empty categories." },
      { role: "user", content: prompt }
    ],
    response_format: { type: "json_object" },
    temperature: 0.2, 
  });

//   console.log("openAI worked");
  return JSON.parse(response.choices[0].message.content || "{}");
};

