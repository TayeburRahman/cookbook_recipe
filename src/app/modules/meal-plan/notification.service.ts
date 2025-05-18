import { Notification } from "./mealplan.model";

const sendNotification = async ({ title, message, user, renderId }: any) => {
    try {
        const notification = await Notification.create({
            title,
            user,
            message,
            renderId
        });

        return notification;

    } catch (error: any) {
        console.error("Error sending notification:", error.message);
    }
};


export const NotificationService = {
    sendNotification
};