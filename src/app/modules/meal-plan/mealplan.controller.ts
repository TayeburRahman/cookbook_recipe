import { IReqUser } from '../auth/auth.interface';

const addMealPlan = async (user: IReqUser) => {
    // const { userId } = req.params;
    // const { message } = req.body;

    // const user = await User.findById(userId);
    // if (!user) {
    //     throw new ApiError(httpStatus.NOT_FOUND, 'User not found');
    // }

    // await sendEmail(user.email, message);

    return {
        status: 'success',
        message: 'Message sent successfully',
    };
};

export const MealPlanController = {
    addMealPlan
};
