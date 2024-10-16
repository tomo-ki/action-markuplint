function convertSeverity(s) {
  switch (s.toLowerCase()) {
    case "error":
      return "ERROR";
    case "warning":
      return "WARNING";
    default:
      return "INFO";
  }
}

module.exports = function (results) {
  const rdjson = {
    source: {
      name: "markuplint",
      url: "https://markuplint.dev/",
    },
    diagnostics: [],
  };

  results.forEach((result) => {
    const diagnostic = {
      message: result.message,
      location: {
        path: result.filePath,
        range: {
          start: { line: result.line, column: result.col },
        },
      },
      severity: convertSeverity(result.severity),
      code: {
        value: result.ruleId,
        url: `https://markuplint.dev/rules/${result.ruleId}`,
      },
      original_output: JSON.stringify(result),
    };

    rdjson.diagnostics.push(diagnostic);
  });

  return JSON.stringify(rdjson);
};
