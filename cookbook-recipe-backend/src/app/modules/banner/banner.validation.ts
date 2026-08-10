import { z } from 'zod';

const createBannerSchema = z.object({
  body: z.object({
    title: z.string().optional(),
    link: z.string().optional(),
    status: z.enum(['active', 'inactive']).optional(),
  }),
});

const updateBannerSchema = z.object({
  body: z.object({
    title: z.string().optional(),
    link: z.string().optional(),
    status: z.enum(['active', 'inactive']).optional(),
  }),
});

export const BannerValidation = {
  createBannerSchema,
  updateBannerSchema,
};
