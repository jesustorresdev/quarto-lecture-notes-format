// Generate the service worker before publishing the website.
//
// Usage: quarto run generate-sw.ts

import * as path from "stdlib/path";

if (!Deno.env.get("QUARTO_PROJECT_RENDER_ALL") || Deno.env.get("QUARTO_PROFILE") !== 'prod') {
  Deno.exit(0);
}

// The path to the extension directory is the directory of this file.
const extensionDir = path.resolve(path.dirname(path.fromFileUrl(import.meta.url)));

console.log("Generating service worker...")
const command = new Deno.Command('npx', {
  args: ['workbox', 'generateSW', 'workbox-config.js'],
  cwd: extensionDir,
  stdout: "inherit",
  stderr: "inherit"
})
const child = command.spawn()
const status = await child.status

Deno.exit(status.code);