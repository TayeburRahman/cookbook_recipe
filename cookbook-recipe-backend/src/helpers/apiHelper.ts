import OpenAI from "openai";

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY, 
});

export const getAIWeekendPrep = async (ingredientsWithRecipes: any[]) => {
  const prompt = `
    You are an Executive Chef. Analyze these ingredients and their recipes across the entire weekly meal plan:
    ${JSON.stringify(ingredientsWithRecipes)}

    TASK: Create a professional Weekend Prep guide.
    
    CRITICAL INGREDIENT CALCULATION RULES:
    1. CONSOLIDATE AND CALCULATE TOTAL QUANTITIES: Scan ALL recipes for the week. If an ingredient appears across multiple recipes or days (e.g., 2 tomatoes in Recipe A and 2 tomatoes in Recipe B), SUM the total quantity needed for the full week (e.g., "4 tomatoes" or "2 bell peppers").
    2. SPEED PREP SECTION:
       - Header: State the main ingredient with its CUMULATIVE TOTAL QUANTITY needed for the entire week (e.g., "4 medium tomatoes", "2 red bell peppers", "3 cups brown rice").
       - Steps: Provide clear, actionable instructions telling people exactly what to do (e.g., "Wash thoroughly", "Chop all 4 tomatoes into 1/2-inch dice to cover all week's recipes", "Store in an airtight container in fridge").
       - Each step inside the "steps" array MUST be an object with:
         "text": (Clear instruction string mentioning preparation and exact total handling)
         "isDone": false (MANDATORY: Always set this to false)
    3. SECTIONS: Category Titles: GRAINS, LEGUMES, VEGETABLES, PROTEINS, SAUCES & DRESSINGS, OTHER, BAKE, STEAM, BLEND, REFRIGERATE, FREEZE.
       - ONLY include a section if there are items for it. (Do not return empty arrays like "items": []).

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
          "ingredient": "2 red bell peppers (Total for Week)",
          "steps": [
            { "text": "Wash thoroughly", "isDone": false },
            { "text": "Dice both peppers into 1/4-inch matchsticks to cover all week's recipes", "isDone": false }
          ]
        },
        {
          "ingredient": "4 tomatoes (Total for Week)",
          "steps": [
            { "text": "Wash and core all 4 tomatoes", "isDone": false },
            { "text": "Chop into 1/2-inch cubes for use throughout the week", "isDone": false }
          ]
        }
      ],
      "prep_notes": ["General tip 1"]
    }
  `;

  const response = await openai.chat.completions.create({
    model: "gpt-4o-mini",
    messages: [
      { role: "system", content: "You are an executive chef. You calculate cumulative total ingredient quantities across all recipes for the full week and provide actionable JSON prep guides." },
      { role: "user", content: prompt }
    ],
    response_format: { type: "json_object" },
    temperature: 0.2, 
  });

//   console.log("openAI worked");
  return JSON.parse(response.choices[0].message.content || "{}");
};

