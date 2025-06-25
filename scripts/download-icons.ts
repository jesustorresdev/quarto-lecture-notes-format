// Icon downloader script for Iconify
//
// Usage: deno run --allow-net --allow-read --allow-write download-icons.ts <prefix> <icon1,icon2,icon3>
// Example: deno run --allow-net --allow-read --allow-write download-icons.ts fa6-brands github,twitter,facebook

import * as path from "stdlib/path";
import { IconifyJSON } from "npm:@iconify/types";
import { IconSet, blankIconSet,    mergeIconSets } from 'npm:@iconify/tools';
import { validateIconSet } from 'npm:@iconify/utils';

const ICON_ASSETS_DIR = path.join('assets', 'icons');

async function downloadIcons(prefix: string, iconNames: string[]): Promise<IconSet | null> {
  const url = `https://api.iconify.design/${prefix}.json?icons=${iconNames.join(',')}`;
  
  console.log(`Downloading icons from: ${url}`);
  
  try {
    const response = await fetch(url);
    
    if (!response.ok) {
      console.error(`Failed to fetch icons: ${response.status} ${response.statusText}`);
      return null;
    }
    
    const data: IconifyJSON = await response.json();
    const iconSet = new IconSet(data);
    console.log(`Downloaded ${iconSet.count()} icons`);
    
    if (data.not_found && data.not_found.length > 0) {
      console.warn(`Icons not found: ${data.not_found.join(', ')}`);
    }
    
    return iconSet;
  } catch (error) {
    console.error(`Error downloading icons: ${error.message}`);
    return null;
  }
}

async function loadExistingIcons(filePath: string): Promise<IconSet | null> {
  try {
    const data = JSON.parse(await Deno.readTextFile(filePath));
    const validatedData = validateIconSet(data);
    return new IconSet(validatedData);
  } catch (error) {
    if (error instanceof Deno.errors.NotFound) {
      console.log(`File ${filePath} does not exist, will create new file`);
      return null;
    }
    console.error(`Error reading existing file: ${error.message}`);
    return null;
  }
}

async function saveIcons(filePath: string, iconSet: IconSet): Promise<boolean> {
  try {
    // Ensure directory exists
    const dir = path.dirname(filePath);
    await Deno.mkdir(dir, { recursive: true });
    
    const json = JSON.stringify(iconSet.export(), null, 2);
    await Deno.writeTextFile(filePath, json);
    
    console.log(`Icons saved to: ${filePath}`);
    return true;
  } catch (error) {
    console.error(`Error saving icons: ${error.message}`);
    return false;
  }
}

function printUsage() {
  console.log(`
Usage: quarto run deno run scripts/download-icons.ts <prefix> <icons>

Arguments:
  prefix  - Iconify icon set prefix (e.g., fa6-brands, ph, simple-icons)
  icons   - Comma-separated list of icon names (e.g., github,twitter,facebook)

Examples:
  quarto run deno run scripts/download-icons.ts fa6-brands github,twitter
  quarto run deno run scripts/download-icons.ts ph cube-bold,brackets-curly-bold
  quarto run deno run scripts/download-icons.ts simple-icons blueprint
`);
}

async function main() {
  const args = Deno.args;
  
  if (args.length !== 2) {
    printUsage();
    Deno.exit(1);
  }
  
  const [prefix, iconsArg] = args;
  const iconNames = iconsArg.split(',').map(name => name.trim()).filter(name => name.length > 0);
  
  if (iconNames.length === 0) {
    console.error("Error: No valid icon names provided");
    Deno.exit(1);
  }
  
  console.log(`Prefix: ${prefix}`);
  console.log(`Icons: ${iconNames.join(', ')}`);

  const filePath = path.join(ICON_ASSETS_DIR, `${prefix}.json`);

  console.log(`Target file: ${filePath}`);
  
  const existingIcons = await loadExistingIcons(filePath) || blankIconSet(prefix);
  
  const newIcons = await downloadIcons(prefix, iconNames);
  if (!newIcons) {
    console.error("Failed to download icons");
    Deno.exit(1);
  }

  const newIconSet = mergeIconSets(existingIcons, newIcons);

  // Save to file
  const success = await saveIcons(filePath, newIconSet);
  if (!success) {
    Deno.exit(1);
  }

  console.log(`✅ Successfully saved ${newIconSet.count()} total icons`);
  
  if (existingIcons.count() > 0) {
    console.log(`📊 Added ${newIcons.count()} new icons to existing ${existingIcons.count()} icons`);
  }
}

if (import.meta.main) {
  await main();
}