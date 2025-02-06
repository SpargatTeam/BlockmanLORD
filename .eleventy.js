module.exports = function (eleventyConfig) {
    return {
        dir: {
            input: "web/pages",
            includes: "web/components",
            output: "dist"
        },
        templateFormats: ["ejs", "html"],
        htmlTemplateEngine: "ejs",
        markdownTemplateEngine: "ejs",
        passthroughFileCopy: true
    };
};