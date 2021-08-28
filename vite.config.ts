import { escapeRegExp } from "lodash";
import { defineConfig } from "vite";
import reactRefresh from "@vitejs/plugin-react-refresh";
import electron from "vitejs-plugin-electron";

import builtinModules from "builtin-modules";
// For two package.json structure
// For single package.json structure
import pkg from "./package.json";
import commonjsExternals from "vite-plugin-commonjs-externals";

const commonjsPackages = [
  "electron",
  "electron/main",
  "electron/common",
  "electron/renderer",
  "original-fs",
  ...builtinModules,
  ...Object.keys(pkg.dependencies).map(
    (name) => new RegExp("^" + escapeRegExp(name) + "(\\/.+)?$")
  ),
] as const;

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    electron(),
    commonjsExternals({ externals: commonjsPackages }),
    reactRefresh(),
  ],
});
