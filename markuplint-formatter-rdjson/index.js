const { createFormatter } = require("@markuplint/ml-core");

module.exports = createFormatter((results) => {
  const rdjsonResults = results.map((result) => ({
    message: result.message,
    location: {
      path: result.filePath,
      range: {
        start: {
          line: result.line,
          column: result.col,
        },
      },
    },
    severity: result.severity === "error" ? "ERROR" : "WARNING",
    code: {
      value: result.ruleId,
    },
  }));

  return JSON.stringify({
    source: {
      name: "markuplint",
      url: "https://github.com/markuplint/markuplint",
    },
    diagnostics: rdjsonResults,
  });
});
