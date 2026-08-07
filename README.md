# Cookbook Recipe Backend(Client: Jaykou69)

Backend service for a cookbook and recipe platform built with Node.js, TypeScript, Express, and MongoDB.

## Features
- Authentication, registration, and password reset
- Recipe, category, banner, dashboard, and meal-plan management
- File upload support and Cloudinary image handling
- Stripe checkout integration for subscriptions
- Analytics dashboard and Excel recipe import
- OpenAI-powered meal plan generation
- Centralized error handling and request validation

## Requirements
- Node.js 16 or newer
- Yarn or npm
- MongoDB database
- `.env` configuration file

## Installation
1. Install dependencies:
   ```bash
yarn install
```
2. Create a `.env` file at the project root with required values.
3. Start the development server:
   ```bash
yarn dev
```

## Build and Run
- Build project: `yarn build`
- Start production server: `yarn start`
- Run development server: `yarn dev`

## Useful Scripts
- `yarn lint:check` - Check ESLint issues
- `yarn lint:fix` - Fix lint issues automatically
- `yarn prettier:fix` - Format files with Prettier

## Environment Variables
The project reads environment variables from `.env` via `src/config/index.ts`.
Common variables include:
- `NODE_ENV`
- `PORT`
- `BASE_URL`
- `MONGO_URL`
- `DB_PASSWORD`
- `JWT_SECRET`
- `JWT_REFRESH_SECRET`
- `JWT_EXPIRES_IN`
- `JWT_REFRESH_EXPIRES_IN`
- `SMTP_HOST`
- `SMTP_PORT`
- `SMTP_SERVICE`
- `SMTP_MAIL`
- `SMTP_PASSWORD`
- `SERVICE_NAME`
- `CLOUD_NAME`
- `API_KEY`
- `API_SECRET`
- `SEND_GRIDAPI_KEY`
- `STRIPE_SECRET_KEY`
- `OPENAI_API_KEY`
- `RESET_PASS_UI_LINK`
- `SERVER_PASS_UI_LINK`

## Project Structure
- `src/server.ts` - Server start and database connection
- `src/app.ts` - Express application configuration
- `src/app/modules` - Feature modules (auth, banner, category, dashboard, meal-plan, payment, user)
- `src/shared/logger.ts` - Winston logging setup
- `src/config/index.ts` - Environment config loader

## Notes
- `logs/` is used by Winston for persisted logging
- Keep `.env` values secure and do not commit them to source control

