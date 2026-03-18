(function () {
  const { t, getLanguage, setLanguage, createRows } = window.PMS_UTILS;
  const modules = window.PMS_ADMIN_MODULES;

  const state = {
    language: getLanguage(),
    activeModule: 'dashboard',
  };

  const nav = document.getElementById('adminNav');
  const pageTitle = document.getElementById('pageTitle');
  const pageSubtitle = document.getElementById('pageSubtitle');
  const languageLabel = document.getElementById('languageLabel');
  const content = document.getElementById('adminContent');
  const langButtons = Array.from(document.querySelectorAll('[data-language]'));

  function label(key) {
    return t(state.language, key);
  }

  function getModule(moduleId) {
    return modules.find((item) => item.id === moduleId) || modules[0];
  }

  function renderNav() {
    nav.innerHTML = modules
      .map((module) => {
        const activeClass = module.id === state.activeModule ? 'is-active' : '';
        return `
          <button type="button" class="${activeClass}" data-module="${module.id}">
            <span>${label(module.key)}</span>
            <span>›</span>
          </button>
        `;
      })
      .join('');

    Array.from(nav.querySelectorAll('[data-module]')).forEach((button) => {
      button.addEventListener('click', () => {
        state.activeModule = button.dataset.module;
        render();
      });
    });
  }

  function renderDashboard(module) {
    const kpis = module.metrics
      .map(
        (metric) => `
          <article class="simple-card kpi-card">
            <span>${metric.label}</span>
            <strong>${metric.value}</strong>
            <span>${metric.note}</span>
          </article>
        `
      )
      .join('');

    const activityRows = createRows(module.activity, ['module', 'detail', 'time']);
    const quickActions = module.quickActions
      .map((item) => `<div class="panel-list-item">${item}</div>`)
      .join('');
    const summary = module.summary
      .map((item) => `<div class="panel-list-item">${item}</div>`)
      .join('');

    return `
      <div class="content-grid">
        <section>
          <h3 class="section-title">${label('dashboard')}</h3>
          <p class="section-subtitle">${label('dashboardDescription')}</p>
        </section>

        <section class="kpi-grid">${kpis}</section>

        <section class="two-column">
          <article class="simple-card panel">
            <h3>${label('recentActivity')}</h3>
            <div class="table-wrap">
              <table class="data-table">
                <thead>
                  <tr>
                    <th>Module</th>
                    <th>Detail</th>
                    <th>Time</th>
                  </tr>
                </thead>
                <tbody>${activityRows}</tbody>
              </table>
            </div>
          </article>

          <div class="content-grid">
            <article class="simple-card panel">
              <h3>${label('quickActions')}</h3>
              <div class="panel-list">${quickActions}</div>
            </article>

            <article class="simple-card panel">
              <h3>${label('summary')}</h3>
              <div class="panel-list">${summary}</div>
            </article>
          </div>
        </section>
      </div>
    `;
  }

  function renderModule(module) {
    const rows = createRows(module.rows, ['id', 'name', 'type', 'status']);
    const actions = module.actions.map((item) => `<li>${item}</li>`).join('');
    const dependencies = module.dependencies.map((item) => `<li>${item}</li>`).join('');

    return `
      <div class="content-grid">
        <section class="simple-card panel">
          <h3>${label(module.key)}</h3>
          <p>${label('moduleDescription')}</p>
          <div class="module-actions">
            <button class="btn btn-primary" type="button">${label('viewList')}</button>
            <button class="btn btn-secondary" type="button">${label('createNew')}</button>
          </div>
        </section>

        <section class="simple-card panel">
          <h3>${label('recentActivity')}</h3>
          <div class="table-wrap">
            <table class="data-table">
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Name</th>
                  <th>Type</th>
                  <th>${label('status')}</th>
                </tr>
              </thead>
              <tbody>${rows}</tbody>
            </table>
          </div>
        </section>

        <section class="meta-grid">
          <article class="simple-card meta-card">
            <h4>${label('controller')}</h4>
            <p>${module.controller}</p>
          </article>
          <article class="simple-card meta-card">
            <h4>${label('actions')}</h4>
            <ul>${actions}</ul>
          </article>
          <article class="simple-card meta-card">
            <h4>${label('dependencies')}</h4>
            <ul>${dependencies}</ul>
          </article>
        </section>
      </div>
    `;
  }

  function renderLanguageButtons() {
    languageLabel.textContent = label('language');
    langButtons.forEach((button) => {
      button.classList.toggle('is-active', button.dataset.language === state.language);
    });
  }

  function renderHeader(module) {
    pageTitle.textContent = module.id === 'dashboard' ? label('adminTitle') : label(module.key);
    pageSubtitle.textContent = module.id === 'dashboard' ? label('adminSubtitle') : label('moduleDescription');
  }

  function renderContent(module) {
    content.innerHTML = module.id === 'dashboard' ? renderDashboard(module) : renderModule(module);
  }

  function render() {
    const module = getModule(state.activeModule);
    document.documentElement.lang = state.language;
    renderLanguageButtons();
    renderNav();
    renderHeader(module);
    renderContent(module);
  }

  langButtons.forEach((button) => {
    button.addEventListener('click', () => {
      state.language = button.dataset.language;
      setLanguage(state.language);
      render();
    });
  });

  render();
})();
