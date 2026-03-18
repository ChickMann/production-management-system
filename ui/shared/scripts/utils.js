window.PMS_UTILS = {
  getLanguage() {
    return localStorage.getItem('pms-language') || window.PMS_I18N.defaultLanguage;
  },

  setLanguage(language) {
    localStorage.setItem('pms-language', language);
  },

  t(language, key) {
    const labels = window.PMS_I18N.labels[language] || window.PMS_I18N.labels.en;
    return labels[key] || window.PMS_I18N.labels.en[key] || key;
  },

  createRows(items, columns) {
    return items
      .map((item) => {
        const cells = columns.map((column) => `<td>${item[column] ?? ''}</td>`).join('');
        return `<tr>${cells}</tr>`;
      })
      .join('');
  },
};
