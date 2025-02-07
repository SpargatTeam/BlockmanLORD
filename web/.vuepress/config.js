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
  themeConfig: {
    navbar: NavBar,
    sidebar: SideBar,
    sidebarDepth: 2,
  },
};