import { Request, Response } from 'express';
import catchAsync from '../../../shared/catchasync';
import sendResponse from '../../../shared/sendResponse';
import { BannerService } from './banner.service';

const createBanner = catchAsync(async (req: Request, res: Response) => {
  const result = await BannerService.createBanner(req, req.body);
  sendResponse(res, {
    statusCode: 201,
    success: true,
    message: 'Banner created successfully',
    data: result,
  });
});

const getAllBanners = catchAsync(async (req: Request, res: Response) => {
  const result = await BannerService.getAllBanners();
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Banners retrieved successfully',
    data: result,
  });
});

const getAdminBanners = catchAsync(async (req: Request, res: Response) => {
  const result = await BannerService.getAdminBanners();
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Banners retrieved successfully',
    data: result,
  });
});

const updateBanner = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  const result = await BannerService.updateBanner(req, id, req.body);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Banner updated successfully',
    data: result,
  });
});

const deleteBanner = catchAsync(async (req: Request, res: Response) => {
  const { id } = req.params;
  await BannerService.deleteBanner(id);
  sendResponse(res, {
    statusCode: 200,
    success: true,
    message: 'Banner deleted successfully',
    data: null,
  });
});

export const BannerController = {
  createBanner,
  getAllBanners,
  getAdminBanners,
  updateBanner,
  deleteBanner,
};
