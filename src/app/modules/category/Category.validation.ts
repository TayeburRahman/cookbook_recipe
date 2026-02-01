import { z } from 'zod';
import { VISIBLITY_VALUES } from '../../../constants/global.constant';
import { TVisibility } from '../../../types/global.type';
export const categoryRegex = /^[A-Za-z\s'.\-&,()]+$/;

export const createCategorySchema = z.object({
  name: z
    .string({
      invalid_type_error: 'name must be string',
      required_error: 'name is required',
    })
    .min(1, 'name is required')
    .trim()
    .regex(/^[^0-9]*$/, {
      message: 'name cannot contain numbers',
    })
    .regex(/^[^~!@#$%\^*\+\?><=;:"]*$/, {
      message:
        'name cannot contain special characters: ~ ! @ # $ % ^ * + ? > < = ; : "',
    }),
});

export const updateCategorySchema = z.object({
  name: z
    .string({
      invalid_type_error: 'name must be string',
      required_error: 'name is required',
    })
    .min(1, 'name is required')
    .trim()
    .regex(/^[^0-9]*$/, {
      message: 'name cannot contain numbers',
    })
    .regex(/^[^~!@#$%\^*\+\?><=;:"]*$/, {
      message:
        'name cannot contain special characters: ~ ! @ # $ % ^ * + ? > < = ; : "',
    })
    .optional(),
  status: z
    .string({
      invalid_type_error: 'status must be a valid string value.',
    })
    .refine(val => VISIBLITY_VALUES.includes(val as TVisibility), {
      message: `status must be one of: ${VISIBLITY_VALUES.map((cv) => `'${cv}'`).join(",")}`,
    })
    .optional(),
});
