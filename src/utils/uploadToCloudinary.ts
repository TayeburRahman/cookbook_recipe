/* eslint-disable @typescript-eslint/no-explicit-any */

import cloudinary from '../helpers/cloudinary';

type TFolder = 'user' | 'recipe' | 'adds' | 'category';

const uploadToCloudinary = async (path: string, folder: TFolder) => {
  try {
    const result = await cloudinary.uploader.upload(path, {
      folder: `Cook-Recipe/${folder}`,
    });

    return result.secure_url;
  } catch (err: any) {
    throw new Error(err);
  }
};

export default uploadToCloudinary;
