import ApiError from "../../../errors/ApiError";
import { IReqUser } from "../auth/auth.interface";
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

const getUserNotifications = async (user: IReqUser) => {
    const { authId } = user;
    try {
        const notification = await Notification.find({ user: authId });

        return notification;

    } catch (error: any) {
        console.error("Error sending notification:", error.message);
    }
};

const seenNotifications = async (req: any) => {
    const id = req.query?.id;
    const { authId } = req.user;

    try {
        if (id) {
            const notification = await Notification.findByIdAndUpdate(id, { seen: true }, { new: true });
            if (!notification) {
                throw new ApiError(404, "Notification not found.");
            }
            return { success: true, notification };
        } else {
            const updateResult = await Notification.updateMany({ user: authId }, { $set: { seen: true } });

            return { success: true, modifiedCount: updateResult.modifiedCount };
        }
    } catch (error) {
        console.error("Error marking notifications as seen:", error);
        throw new ApiError(500, "Failed to update notifications.");
    }
};


export const NotificationService = {
    sendNotification,
    getUserNotifications,
    seenNotifications
};