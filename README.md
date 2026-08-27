# Cookbook & AI Meal Planner System

A comprehensive, full-stack AI-powered Meal Planning, Recipe Management, and Smart Grocery System consisting of a **Flutter Mobile App**, a **TypeScript Node.js/Express Backend**, and a **Vite/React Web Platform**.

---

## System Architecture & Overview

The project is structured as a unified monorepo containing three core applications:

```text
cookbook_recipe/
├── Recipe_App/                 # Flutter Cross-Platform Mobile Application (iOS & Android)
├── cookbook-recipe-backend/    # Node.js, Express, TypeScript & MongoDB REST API Service
└── cookbook-recipe-website/    # React + Vite Web Application & Admin Interface
```

---

## ✨ Key Features

### 🧠 1. AI-Powered Meal Planning
- **Weekly Meal Plans**: Automated, balanced meal plan generation powered by OpenAI.
- **Custom Meal Plans**: Create, customize, and swap recipes for any day of the week.
- **Featured Plans**: Curated meal plans tailored for weight loss, muscle building, and specific diet goals.

### 🛒 2. Smart Grocery List with Real-time Two-Way Sync
- **Dual Views**: Toggle seamlessly between **BY AISLE** (Departmentalized: Produce, Grains, Dairy, etc.) and **BY RECIPE** (Recipe-grouped ingredients).
- **Two-Way Checkbox Synchronization**: Checking an item in the *Aisle View* instantly checks the corresponding ingredient in the *Recipe View*, and vice versa.
- **Database Persistence**: Purchased items stay checked across app reloads and devices via MongoDB API synchronization.
- **Live Progress Summary**: Real-time progress bar showing total completed items (`X / Y Items`) and department completion counters.
- **Custom Items**: Add custom grocery items directly into your personal aisle list.

### 🔪 3. Weekend Speed Prep Guide
- **AI Prep Generator**: Consolidates ingredients across all 7 days of a meal plan.
- **Batch Preparation Steps**: Step-by-step prep tasks for grain cooking, vegetable chopping, sauce preparation, and freezing/refrigeration storage.
- **Interactive Checklists**: Interactive speed prep step checkoff with database persistence.

### 📖 4. Recipe Box & Exploration
- Category dropdowns, diet goals, satiety score metrics, nutritional breakdowns, and ingredient filters.
- Create, update, favorite, and bookmark custom recipes.

---

## 🛠️ Technology Stack

### **Mobile App (`Recipe_App`)**
- **Framework**: Flutter (Dart)
- **State Management**: GetX
- **Networking**: Http / GetConnect / REST API Integration
- **UI & Styling**: ScreenUtil, Custom Responsive Aesthetics, Animated Containers

### **Backend Service (`cookbook-recipe-backend`)**
- **Runtime & Language**: Node.js, TypeScript
- **Framework**: Express.js
- **Database**: MongoDB with Mongoose ODM
- **AI Integration**: OpenAI GPT-4 API Integration
- **Authentication**: JWT (JSON Web Tokens), Bcrypt Password Hashing
- **File Storage**: Cloudinary / Multer Integration

### **Web Application (`cookbook-recipe-website`)**
- **Framework**: React, Vite
- **State Management**: Redux Toolkit & RTK Query
- **Styling**: TailwindCSS, Shadcn UI components

---

## ⚙️ Getting Started & Setup Guide

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.x+)
- [Node.js](https://nodejs.org/) (v18+ or v20+)
- [MongoDB Server](https://www.mongodb.com/) (Local or Cloud Atlas Instance)

---

### 1. Backend Setup (`cookbook-recipe-backend`)

1. Navigate to the backend directory:
   ```bash
   cd cookbook-recipe-backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Create a `.env` file in `cookbook-recipe-backend/`:
   ```env
   PORT=5005
   DATABASE_URL=mongodb+srv://<username>:<password>@cluster.mongodb.net/cookbook
   JWT_SECRET=your_jwt_secret_key
   OPENAI_API_KEY=your_openai_api_key
   CLOUDINARY_CLOUD_NAME=your_cloudinary_name
   CLOUDINARY_API_KEY=your_cloudinary_key
   CLOUDINARY_API_SECRET=your_cloudinary_secret
   ```
4. Start the development server:
   ```bash
   npm run dev
   ```

---

### 2. Mobile App Setup (`Recipe_App`)

1. Navigate to the mobile app directory:
   ```bash
   cd Recipe_App
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure Backend URL in `lib/app/services/app_url.dart`:
   ```dart
   static const baseUrl = "https://backend.koumanisdietapp.com"; // Live URL
   // static const baseUrl = "http://10.0.2.2:5005";            // Local Emulator
   ```
4. Run the application:
   ```bash
   flutter run
   ```
5. Build Release APK:
   ```bash
   flutter build apk --release
   ```

---

### 3. Web App Setup (`cookbook-recipe-website`)

1. Navigate to the website directory:
   ```bash
   cd cookbook-recipe-website
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start the Vite dev server:
   ```bash
   npm run dev
   ```

---

## 📌 API Endpoints Overview

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/meal_plan/get_weekly_plane` | Get user's weekly meal plan |
| `GET` | `/meal_plan/get_grocery_list/:id` | Get recipe-based grocery list |
| `GET` | `/meal_plan/grocery-list-advice/:planId` | Get AI consolidated grocery list (By Aisle) |
| `PATCH` | `/meal_plan/toggle_ingredient_buy_status/:id` | Toggle recipe ingredient purchase status |
| `PATCH` | `/meal_plan/toggle-aisle-item` | Toggle aisle item purchase status in MongoDB |
| `GET` | `/meal_plan/weekend-prep/:planId` | Generate & retrieve AI Weekend Prep advice |
| `PATCH` | `/meal_plan/toggle-speed-prep` | Toggle weekend prep step status |

---

## 👨‍💻 Authors & Maintenance

Developed and maintained by **Tayebur Rahman** & Team.
