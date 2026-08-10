import ApiError from '../../../errors/ApiError';
import uploadToCloudinary from '../../../utils/uploadToCloudinary';
import { IBanner } from './banner.interface';
import Banner from './banner.model';

const createBanner = async (req: any, payload: IBanner) => {
  if (!req.file) {
    throw new ApiError(400, 'Banner image is required');
  }

  const image = await uploadToCloudinary(req.file.path, 'banner');
  const result = await Banner.create({
    ...payload,
    image,
  });
  return result;
};

const getAllBanners = async () => {
  const result = await Banner.find({ status: 'active' }).sort('-createdAt');
  return result;
};

const getAdminBanners = async () => {
  const result = await Banner.find().sort('-createdAt');
  return result;
};

const updateBanner = async (req: any, id: string, payload: Partial<IBanner>) => {
  const isExist = await Banner.findById(id);
  if (!isExist) {
    throw new ApiError(404, 'Banner not found');
  }

  if (req.file) {
    payload.image = await uploadToCloudinary(req.file.path, 'banner');
  }

  const result = await Banner.findByIdAndUpdate(id, payload, { new: true });
  return result;
};

const deleteBanner = async (id: string) => {
  const isExist = await Banner.findById(id);
  if (!isExist) {
    throw new ApiError(404, 'Banner not found');
  }

  const result = await Banner.findByIdAndDelete(id);
  return result;
};

export const BannerService = {
  createBanner,
  getAllBanners,
  getAdminBanners,
  updateBanner,
  deleteBanner,
};
