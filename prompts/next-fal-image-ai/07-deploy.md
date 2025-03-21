---
description: Guidelines for deploying the Next.js 15 text-to-image app to Vercel
globs: **/*.ts, **/*.tsx, **/*.js, **/*.jsx
---

# Deploy the Text-to-Image App to Vercel

## Overview

1. Push your Next.js 15 project (with Fal.ai and ShadCN) to a Git repository.
2. Import the repository into Vercel.
3. Set environment variables (FAL_KEY, etc.) in Vercel.
4. Verify your serverless routes (Fal proxy) once deployed.

## CRITICAL INSTRUCTIONS
- Only store secrets (FAL_KEY) in Vercel environment variables (not in your code).
- Ensure Fal.ai proxy route works on your production domain.
- Use Node 18+ on Vercel if needed (check your project settings).

## Key Steps

1. Connect to Git
   - Commit all code to a Git provider (GitHub, GitLab, etc.).
   - Ensure your .gitignore excludes .env files so local secrets aren’t pushed.
2. Import Project into Vercel
   - Sign in to Vercel and select “Add New…” > “Project”.
   - Choose the repository with your Next.js 15 app.
   - Vercel should auto-detect Next.js and set the correct build command (npm run build or similar).
3. Configure Environment Variables
   - In the Vercel project settings, add:
     - FAL_KEY (your Fal.ai key)
   - Do not mark it as public, so it remains server-side only.
   - Rebuild once these variables are set.
4. Verify Production
   - After deployment, open your .vercel.app URL (or custom domain).
   - Test the dashboard page, prompt an image generation, and confirm Fal.ai works.
   - Check the logs or error messages if something fails (on the Vercel dashboard under “Functions” logs or “Deployments” logs).

## Verification Checklist
- Did you add FAL_KEY as a private environment variable in Vercel?
- Does the Fal.ai proxy route (app/api/fal/proxy/route.ts) return a valid response in production?
- Are you using the correct environment for Node (≥ 18) if needed?

## AI MODEL RESPONSE TEMPLATE
When asked about deploying to Vercel:
1. Outline linking the Git repo to Vercel.
2. Show how to add environment variables (FAL_KEY).
3. Emphasize verifying the Fal.ai proxy endpoint in your live environment.
```