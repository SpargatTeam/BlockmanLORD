const vuepressBar = require("vuepress-bar");
const { SideBar, NavBar } = require("./bars.js");
const { sidebar } = vuepressBar({
  addReadMeToFirstGroup: false,
});
module.exports = {
  title: "BlockmanLORD",
  description:
    "BlockmanLORD, Spargat's LORD Remake",
  base: "/",
  dest: "./dist",
  theme: "vuepress-theme-succinct",
  globalUIComponents: ["ThemeManager"],
  themeConfig: {
    displayAllHeaders: false,
    lastUpdated: true,
    repo: "https://github.com/SpargatTeam/BlockmanLORD/",
    docsDir: "web",
    docsBranch: "develop",
    editLinks: true,
    editLinkText: "Help BlockmanLORD project!",
    sidebar: SideBar,
    nav: NavBar,
  },
  plugins: [
    ["vuepress-plugin-code-copy", true],
    ["flexsearch"],
    ["code-switcher"],
    "@vuepress/plugin-back-to-top",
    "vuepress-plugin-smooth-scroll",
    [
      "vuepress-plugin-medium-zoom",
      {
        selector: "img",
        options: {
          background: "var(--bodyBgColor)",
        },
      },
    ],
  ],
};