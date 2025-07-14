import { Request, Response } from "express";
import { UserService } from "./user.service";
import sendResponse from "../../../shared/sendResponse";
import catchAsync from "../../../shared/catchasync";
import { IReqUser } from "../auth/auth.interface";

const updateProfile = catchAsync(async (req: Request, res: Response) => {
  const result = await UserService.updateMyProfile(req as any);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Profile updated successfully",
    data: result,
  });
});

const getProfile = catchAsync(async (req: Request, res: Response) => {
  const result = await UserService.getProfile(req.user as IReqUser);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "User retrieved successfully",
    data: result,
  });
});

const deleteMyAccount = catchAsync(async (req: Request, res: Response) => {
  await UserService.deleteUSerAccount(req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: "Account deleted!",
  });
});

const checkTheUserInfo = catchAsync(async (req: Request, res: Response) => {
  const data = await UserService.checkTheUserInfo(req.user as IReqUser);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    data: data,
    message: "Get Successfully!",
  });
});


export const UserController = {
  deleteMyAccount,
  getProfile,
  updateProfile,
  checkTheUserInfo
};

