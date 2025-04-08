// Update the service worker before publishing the website.
//
// Usage: quarto run update-sw.ts [--dry-run]

import { parse } from "stdlib/flags";
import { exists } from "stdlib/fs";

const SERVICE_WORKER_FILE = 'sw.js';
const START_CONFIG_MARKER = '//--- START CONFIG ---';
const END_CONFIG_MARKER = '//--- END CONFIG ---';

if (!Deno.env.get("QUARTO_PROJECT_RENDER_ALL")) {
  Deno.exit(0);
}

const PROYECT_OUTPUT_DIR = Deno.env.get('QUARTO_PROJECT_OUTPUT_DIR');
if (!PROYECT_OUTPUT_DIR) {
  console.error('Error: The environment variable "QUARTO_PROJECT_OUTPUT_DIR" is not set.');
  Deno.exit(1);
}

function getGitCommit(): string {
  const command = new Deno.Command('git', {
    args: ['rev-parse', '--short', 'HEAD'],
    stdout: 'piped',
    stderr: 'piped'
  })
  const { code, stdout } = command.outputSync();
  if (code == 0) {
    return new TextDecoder('utf-8').decode(stdout).trim();
  } else {
    console.warn('Warning: Could not get git commit. Using "(unknown)" as value.');
    return '(unknown)';
  }
}

function findAllFiles(directory: string): string[] {
  const files: string[] = [];
  
  const walkDirectories = (dirPath: string = '.'): void => {
    const dirEntries = Deno.readDirSync(`${directory}/${dirPath}`);
    
    for (const entry of dirEntries) {
      const relativePath = `${dirPath}/${entry.name}`;      
      if (entry.isDirectory) {
        walkDirectories(relativePath);
      } else if (!entry.name.startsWith('.')) {
        files.push(relativePath);
      }
    }
  };

  walkDirectories();
  return files;
}

function getUpdatedServiceWorker(serviceWorkerPath: string, version: string, urlsToCache: string[]): string {
  const urlsToCacheContent = urlsToCache.map(url => `'${url}'`).join(',\n');
  const newConfigContent = `${START_CONFIG_MARKER}
const VERSION = '${version}'
const URLS_TO_CACHE = [
${urlsToCacheContent}
]
${END_CONFIG_MARKER}`

  const existingFileContent = Deno.readTextFileSync(serviceWorkerPath);
  const updatedContent = existingFileContent.replace(
    new RegExp(`${START_CONFIG_MARKER}[\\s\\S]*${END_CONFIG_MARKER}`),
    newConfigContent
  );

  return updatedContent;
}

const args = parse(Deno.args, {
  boolean: ['dry-run'],
})

try {

  if (!exists(PROYECT_OUTPUT_DIR)) {
    throw Error(`The directory '${PROYECT_OUTPUT_DIR}' does not exist.`)
  }

  const gitCommit = getGitCommit();

  console.log('Generating list of files and directories...')
  const siteFiles = findAllFiles(PROYECT_OUTPUT_DIR)
  const filesToCache = [
    './', // The root directory
    ...siteFiles
  ].filter(entry => !entry.endsWith(`/${SERVICE_WORKER_FILE}`))
    .sort()

  console.log(`Updating ${SERVICE_WORKER_FILE} with commit ${gitCommit} and file list...`);
  const serviceWorkerPath = `${PROYECT_OUTPUT_DIR}/${SERVICE_WORKER_FILE}`;
  const serviceWorkerContent = getUpdatedServiceWorker(serviceWorkerPath, gitCommit, filesToCache);

  if (args['dry-run']) {
    console.log(`The ${SERVICE_WORKER_FILE} would be updated to:`);
    console.log('----------------------------------------');
    console.log(serviceWorkerContent);
    console.log('----------------------------------------');
  } else {
    Deno.writeTextFileSync(serviceWorkerPath, serviceWorkerContent);
    console.log('Update completed!');
  }

  console.log(`Commit: ${gitCommit}`);
  console.log(`Total files and directories included: ${filesToCache.length}`);

} catch (error) {
  console.error('Error:', error.message);
  Deno.exit(1);
}