
import { IMAGE_BASE_URL } from "@/redux/feature/baseApi";
import { clsx } from "clsx";
import { format } from "date-fns";
import { toast } from "sonner";
import { twMerge } from "tailwind-merge"

export function cn(...inputs) {
  return twMerge(clsx(inputs));
}

// Replace White Background
export const replaceWhiteBackground = (html) => {
  if (!html) return "";

  return html.replace(/style="([^"]*)"/g, (match, styleString) => {
    const styleProperties = styleString.split(';').filter(prop => prop.trim() !== '');

    const filteredProperties = styleProperties.filter(prop => {
      const i = prop.indexOf(':');
      if (i === -1) return true;

      const propName = prop.substring(0, i).trim();
      const propValue = prop.substring(i + 1).trim();

      // Exclude 'background-color' only if it's white
      if (propName === 'background-color') {
        const lowerCaseValue = propValue.toLowerCase().replace(/\s/g, '');
        if (
          lowerCaseValue === 'white' ||
          lowerCaseValue === '#fff' ||
          lowerCaseValue === '#ffffff' ||
          lowerCaseValue === 'rgb(255,255,255)'
        ) {
          return false;
        }
      }

      return true;
    });

    if (filteredProperties.length > 0) {
      const newStyleString = filteredProperties.join('; ');
      return `style="${newStyleString};"`;
    } else {
      return '';
    }
  });
};

// Success Toast
export const SuccessToast = (msg) => {
  toast.success(msg)
}

// Error Toast 
export const ErrorToast = (msg) => {
  toast.error(msg)
}

// Warning Toast
export const WarningToast = (msg) => {
  toast.warning(msg)
}

// Info Toast
export const InfoToast = (msg) => {
  toast.info(msg)
}

// Get Initials
export const getInitials = (name) => {
  if (!name) return "NA";
  const parts = name.trim().split(/\s+/);
  const first = parts[0]?.[0] || "N";
  const second = parts[1]?.[0] || parts[0]?.[1] || "A";
  return (first + second).toUpperCase();
};

// Format Date 
export const formatDate = (dateString) => {
  if (!dateString) return 'N/A';
  return format(new Date(dateString), 'dd MMM yyyy');
};

// Get Image URL
export const getImageUrl = (imagePath) => {
  if (!imagePath) return '';
  return imagePath.startsWith('/') ? `${IMAGE_BASE_URL}${imagePath}` : `${IMAGE_BASE_URL}/${imagePath}`;
};

// Time Ago
export const timeAgo = (createdAt) => {
  if (!createdAt) return ""
  const s = Math.floor((Date.now() - new Date(createdAt).getTime()) / 1000)
  if (s < 60) return "Just now"
  const m = Math.floor(s / 60)
  if (m < 60) return `${m}m ago`
  const h = Math.floor(m / 60)
  if (h < 24) return `${h}h ago`
  const d = Math.floor(h / 24)
  return `${d}d ago`
}