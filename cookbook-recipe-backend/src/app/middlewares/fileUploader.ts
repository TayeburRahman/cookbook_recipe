/* eslint-disable @typescript-eslint/ban-ts-comment */
import { Request } from 'express';
import multer from 'multer';
import fs from 'fs';
import path from 'path';

export const uploadFile = () => {
  const storage = multer.diskStorage({
    destination: function (req, file, cb) {
      const fieldFolders: Record<string, string> = {
        profile_image: 'uploads/images/profile',
        cover_image: 'uploads/images/profile',
        product_img: 'uploads/images/products',
        image: 'uploads/images/image',
        message_img: 'uploads/images/message',
        video: 'uploads/video',
        video_thumbnail: 'uploads/thumbnails/video',
        thumbnail: 'uploads/thumbnails',
        document: 'uploads/documents',
      };

      const uploadPath = fieldFolders[file.fieldname] || 'uploads/others';

      // Create folder if not exists
      if (!fs.existsSync(uploadPath)) {
        fs.mkdirSync(uploadPath, { recursive: true });
      }

      cb(null, uploadPath);
    },

    filename: function (req, file, cb) {
      const uniqueName = `${Date.now()}-${file.originalname}`;
      cb(null, uniqueName);
    },
  });

  const allowedFieldnames = [
    'image',
    'profile_image',
    'cover_image',
    'product_img',
    'video',
    'thumbnail',
    'video_thumbnail',
    'message_img',
    'document',
  ];

  const fileFilter = (req: Request, file: Express.Multer.File, cb: multer.FileFilterCallback) => {
    if (!allowedFieldnames.includes(file.fieldname)) {
      return cb(new Error(`Field "${file.fieldname}" is not allowed`));
    }

    // Allow all file types
    cb(null, true);
  };

  const upload = multer({
    storage,
    fileFilter,
    limits: {
      fileSize: 50 * 1024 * 1024,
    },
  }).fields([
    { name: 'image', maxCount: 30 },
    { name: 'product_img', maxCount: 10 },
    { name: 'cover_image', maxCount: 1 },
    { name: 'profile_image', maxCount: 1 },
    { name: 'video', maxCount: 1 },
    { name: 'video_thumbnail', maxCount: 1 },
    { name: 'thumbnail', maxCount: 1 },
    { name: 'message_img', maxCount: 10 },
    { name: 'document', maxCount: 5 },
  ]);

  return upload;
};
