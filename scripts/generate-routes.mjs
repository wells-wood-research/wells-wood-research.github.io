import { cp, mkdir } from 'node:fs/promises';

const routes = ['news', 'people', 'publications', 'tools'];

for (const route of routes) {
  await mkdir(`dist/${route}`, { recursive: true });
  await cp('dist/index.html', `dist/${route}/index.html`);
}

await cp('dist/index.html', 'dist/404.html');
