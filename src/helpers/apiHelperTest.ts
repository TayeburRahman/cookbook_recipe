
// import Groq from "groq-sdk";
// import config from "../config";

// const groq = new Groq({ apiKey: config.groq_api_key });

// export const getAIWeekendPrep = async (ingredientData: any[]) => {
//   try {
//     const response = await groq.chat.completions.create({
//       model: "llama-3.3-70b-versatile",
//       messages: [
//         {
//           role: "system",
//           content: `You are a professional chef. For "speed_prep", you MUST group tasks by ingredient. 
//           Example:
//           "speed_prep": [
//             {
//               "ingredient": "1/2 red bell pepper",
//               "steps": ["1/2 cut into matchsticks"]
//             }
//           ]`
//         },
//         {
//           role: "user",
//           content: `Analyze these ingredients and recipes: ${JSON.stringify(ingredientData)}.
          
//           Structure the response EXACTLY like this JSON example:
//           {
//             "sections": [
//               {
//                 "title": "BAKE",
//                 "items": [
//                   {
//                     "name": "Sweet Potatoes",
//                     "amount": "2 large",
//                     "instruction": "Preheat oven to 400°F. Bake for 45 mins.",
//                     "storage": "Airtight container for 5 days",
//                     "usedIn": "Savory Sweet Potato Toasts"
//                   }
//                 ]
//               }
//             ],
//             "speed_prep": [
//               {
//                 "ingredient": "1/2 red bell pepper",
//                 "steps": ["1/2 cut into matchsticks"]
//               }
//             ],
//             "prep_notes": ["Tip 1"]
//           }`
//         }
//       ],
//       response_format: { type: "json_object" },
//       temperature: 0.1,
//     });

//     const aiResult = JSON.parse(response.choices[0].message.content || "{}");
//     return aiResult;
//   } catch (error) {
//     console.error("Groq API Error:", error);
//     throw new Error("AI failed to generate response");
//   }
// };