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
    3. SPEED PREP Section: 
       - Group items by the main ingredient header.
       - Each step inside the "steps" array MUST be an object with:
         "text": (The instruction string)
         "isDone": false (MANDATORY: Always set this to false)

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
            "steps": [
            { "text": "wash thoroughly", "isDone": false },
            { "text": "cut into 1/4-inch matchsticks", "isDone": false }
          ]
        },
        {
          "ingredient": "2 sweet potatoes",
          "steps": [
            { "text": "peel and cube into 1-inch pieces", "isDone": false },
              { "text": "scrub and wash thoroughly", "isDone": false },
          ]
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

  return JSON.parse(response.choices[0].message.content || "{}");
};

