import ApiError from "../../../errors/ApiError";
import httpStatus from "http-status";
import { Request } from "express";
import { RequestData } from "../../../interfaces/common";
import Auth from "../auth/auth.model";
import { IUser } from "./user.interface";
import User from "./user.model";
import { IReqUser } from "../auth/auth.interface";

const updateMyProfile = async (req: RequestData): Promise<IUser> => {
  const { files, body: data } = req;
  const { userId, authId } = req.user;

  if (!Object.keys(data as any).length) {
    throw new ApiError(
      httpStatus.BAD_REQUEST,
      "Data is missing in the request body!"
    );
  }

  const checkUser = await User.findById(userId);

  if (!checkUser) {
    throw new ApiError(httpStatus.NOT_FOUND, "User not found!");
  }

  const checkAuth = await Auth.findById(authId);
  if (!checkAuth) {
    throw new ApiError(httpStatus.NOT_FOUND, "You are not authorized");
  }

  let profile_image: string | undefined = undefined;
  if (files && files.profile_image) {
    profile_image = `/images/profile/${files.profile_image[0].filename}`;
  }

  const updatedData = { ...data };

  if (updatedData?.relevant_dielary?.length) {
    updatedData.relevant_dielary = JSON.parse(updatedData.relevant_dielary)
  }
  if (updatedData?.mail_types?.length) {
    updatedData.mail_types = JSON.parse(updatedData.mail_types)
  }

  const [, updateUser] = await Promise.all([
    Auth.findByIdAndUpdate(
      authId,
      { name: updatedData.name },
      {
        new: true,
      }
    ),
    User.findByIdAndUpdate(
      userId,
      { profile_image, ...updatedData },
      {
        new: true,
      }
    ).populate("authId"),
  ]);

  return updateUser as IUser;
};

const getProfile = async (user: { userId: string }): Promise<IUser> => {
  const { userId } = user;
  console.log("=========", user)
  const result = await User.findById(userId).populate("authId");
  if (!result) {
    throw new ApiError(httpStatus.NOT_FOUND, "User not found");
  }

  const auth = await Auth.findById(result.authId);
  if (auth?.is_block) {
    throw new ApiError(httpStatus.FORBIDDEN, "You are blocked. Contact support");
  }

  return result;
};

const deleteUSerAccount = async (payload: { email: string; password: string; }): Promise<void> => {
  const { email, password } = payload;

  const isUserExist = await Auth.isAuthExist(email);
  if (!isUserExist) {
    throw new ApiError(httpStatus.NOT_FOUND, "User does not exist");
  }

  if (
    isUserExist.password &&
    !(await Auth.isPasswordMatched(password, isUserExist.password))
  ) {
    throw new ApiError(httpStatus.UNAUTHORIZED, "Password is incorrect");
  }

  await User.deleteOne({ authId: isUserExist._id });
  await Auth.deleteOne({ email });
};

const checkTheUserInfo = async (user: IReqUser) => {
  const { userId } = user;

  if (!userId) {
    return { status: false, message: "User ID missing." };
  }

  const existingUser = await User.findById(userId).lean();

  if (!existingUser) {
    return { status: false, message: "User not found." };
  }

  const { relevant_dielary, mail_types, profile_image } = existingUser;

  const isProfileComplete =
    Array.isArray(relevant_dielary) &&
    relevant_dielary.length > 0 &&
    Array.isArray(mail_types) &&
    mail_types.length > 0 &&
    profile_image !== null &&
    profile_image !== "";

  return {
    status: isProfileComplete,
    message: isProfileComplete ? "Complete" : "Incomplete",
  };
};

export const UserService = {
  getProfile,
  deleteUSerAccount,
  updateMyProfile,
  checkTheUserInfo
};

