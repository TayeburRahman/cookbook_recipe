import cron from "node-cron";
import { logger } from "../../../shared/logger";
import { MealPlanWeek } from "./mealplan.model";

// cron.schedule("* * * * *", async () => {
//     try {
//         const now = new Date();
//         const result = await MealPlanWeek.updateMany(
//             {
//                 isActive: false,
//                 expirationTime: { $lte: now },
//                 activationCode: { $ne: null },
//             },
//             {
//                 $unset: { activationCode: "" },
//             }
//         );

//         if (result.modifiedCount > 0) {
//             logger.info(`Removed activation codes from ${result.modifiedCount} expired inactive users`);
//         }
//     } catch (error) {
//         logger.error("Error removing activation codes from expired users:", error);
//     }
// });






// const activateAccount = async (payload: ActivationPayload) => {

// };



export const MealService = {
    // activateAccount
};

