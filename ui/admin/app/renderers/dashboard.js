// File này render dashboard tổng quan của admin UI.
// Dashboard hiện là màn demo để mô phỏng bố cục quản trị.
// Các số liệu KPI, recent activity và summary bên dưới đều là dữ liệu mẫu,
// về sau cần thay bằng dữ liệu thật từ backend hoặc API.
window.PMS_ADMIN = window.PMS_ADMIN || {};

window.PMS_ADMIN.renderDashboard = function renderDashboard() {
  const { t, escapeHtml, renderMetricCard } = window.PMS_ADMIN;

  return `
    <section class="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
      ${renderMetricCard(t('dashboardMetric1'), '24', t('dashboardNote1'))}
      ${renderMetricCard(t('dashboardMetric2'), '128', t('dashboardNote2'))}
      ${renderMetricCard(t('dashboardMetric3'), '56', t('dashboardNote3'))}
      ${renderMetricCard(t('dashboardMetric4'), '8', t('dashboardNote4'))}
    </section>

    <section class="grid gap-6 lg:grid-cols-[1.35fr_1fr]">
      <article class="rounded-2xl bg-white p-6 shadow-sm hover:shadow-md transition-shadow duration-300">
        <div class="flex items-center justify-between gap-4">
          <div>
            <h3 class="text-lg font-semibold text-slate-800">${escapeHtml(t('recentActivity'))}</h3>
            <p class="mt-1 text-sm text-slate-500">${escapeHtml(t('dashboardSubtitle'))}</p>
          </div>
          <span class="rounded-full bg-emerald-100 px-3 py-1 text-xs font-semibold text-emerald-700">${escapeHtml(t('ready'))}</span>
        </div>
        <div class="mt-6 overflow-x-auto">
          <table class="min-w-full">
            <thead class="bg-slate-50">
              <tr>
                <th class="px-5 py-3 text-left text-xs font-bold uppercase tracking-wider text-slate-500">${escapeHtml(t('activityModule'))}</th>
                <th class="px-5 py-3 text-left text-xs font-bold uppercase tracking-wider text-slate-500">${escapeHtml(t('activityDetail'))}</th>
                <th class="px-5 py-3 text-left text-xs font-bold uppercase tracking-wider text-slate-500">${escapeHtml(t('activityTime'))}</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
              ${[
                ['Production Orders', 'WO-1024 released for assembly', '10:30'],
                ['Production Logs', 'Shift A reported 2 defects', '09:50'],
                ['Purchase Orders', 'PO-204 sent to supplier', '09:10'],
              ]
                .map(
                  (row) => `
                    <tr class="hover:bg-slate-50 transition-colors duration-150 cursor-pointer">
                      <td class="px-5 py-4 text-sm font-medium text-slate-700">${escapeHtml(row[0])}</td>
                      <td class="px-5 py-4 text-sm text-slate-600">${escapeHtml(row[1])}</td>
                      <td class="px-5 py-4 text-sm text-slate-500">${escapeHtml(row[2])}</td>
                    </tr>
                  `,
                )
                .join('')}
            </tbody>
          </table>
        </div>
      </article>

      <div class="space-y-6">
        <article class="rounded-2xl bg-white p-6 shadow-sm hover:shadow-md transition-shadow duration-300">
          <h3 class="text-lg font-semibold text-slate-800">${escapeHtml(t('quickActionsTitle'))}</h3>
          <div class="mt-4 grid gap-3">
            ${[t('quickAction1'), t('quickAction2'), t('quickAction3')]
              .map(
                (item) => `
                  <button class="rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-left text-sm font-semibold text-slate-700 hover:bg-teal-50 hover:border-teal-200 hover:text-teal-700 transition-all duration-200 group" type="button">
                    <span class="flex items-center gap-3">
                      <span class="flex h-8 w-8 items-center justify-center rounded-lg bg-slate-200 group-hover:bg-teal-100 transition-colors">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-slate-500 group-hover:text-teal-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                          <path stroke-linecap="round" stroke-linejoin="round" d="M13 10V3L4 14h7v7l9-11h-7z" />
                        </svg>
                      </span>
                      ${escapeHtml(item)}
                    </span>
                  </button>
                `,
              )
              .join('')}
          </div>
        </article>

        <article class="rounded-2xl bg-white p-6 shadow-sm hover:shadow-md transition-shadow duration-300">
          <h3 class="text-lg font-semibold text-slate-800">${escapeHtml(t('summaryTitle'))}</h3>
          <div class="mt-4 space-y-3">
            ${[t('summary1'), t('summary2'), t('summary3')]
              .map(
                (item) => `
                  <div class="rounded-xl border border-slate-100 px-4 py-3 text-sm text-slate-600 hover:border-teal-200 hover:bg-teal-50/50 transition-all duration-200 cursor-default">
                    ${escapeHtml(item)}
                  </div>
                `,
              )
              .join('')}
          </div>
        </article>
      </div>
    </section>
  `;
};
