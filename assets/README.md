# Assets Directory

This directory contains static assets for the VapeLab application.

## Structure

- `images/` - Application images, logos, and graphics
- `icons/` - Icon files for the app

## Adding Assets

1. Place your image files in the appropriate subdirectory
2. Update `pubspec.yaml` if needed to include new asset paths
3. Reference assets in code using:
   ```dart
   Image.asset('assets/images/your-image.png')
   ```

## Recommended Formats

- **Images**: PNG, JPG, WebP
- **Icons**: SVG, PNG (with multiple resolutions)

## Icon Sizes

For web deployment, consider these sizes:
- 192x192 (for PWA)
- 512x512 (for PWA)
- Favicon: 32x32, 16x16

## Placeholder Assets

Currently, the app uses placeholder icons from Material Icons.
Replace with custom assets as needed.
