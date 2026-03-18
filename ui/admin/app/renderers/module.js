// File này render phần nội dung của từng module CRUD.
// Mục tiêu hiện tại:
// - mỗi tab chỉ có màn list / create / edit
// - không nhồi list và form trên cùng một màn
// - toàn bộ điều hướng đang là frontend demo, chưa gọi backend thật
window.PMS_ADMIN = window.PMS_ADMIN || {};

// Chuyển màn hình con trong cùng một module.
// Ví dụ: từ list sang create, hoặc từ list sang edit.
// Đây là điều hướng nội bộ phía frontend, chưa phải route thật của server.
window.PMS_ADMIN.openModuleScreen = function openModuleScreen(screen, recordId) {
  window.PMS_ADMIN.state.app.activeScreen = screen;
  window.PMS_ADMIN.state.app.activeRecordId = recordId || null;

  const current = window.PMS_ADMIN.moduleMap[window.PMS_ADMIN.state.app.activeTab];
  if (current) {
    window.PMS_ADMIN.renderContent(current);
  }
};

// Trả về nhãn hiển thị cho từng màn con hoặc action CRUD.
// Hiện tại đây là text dùng cho UI demo và có hỗ trợ en/vi theo state hiện tại.
window.PMS_ADMIN.getScreenLabel = function getScreenLabel(screen) {
  const language = window.PMS_ADMIN.state.currentLanguage;
  const labels = {
    list: language === 'vi' ? 'Danh sách' : 'List',
    create: language === 'vi' ? 'Tạo mới' : 'Create',
    edit: language === 'vi' ? 'Chỉnh sửa' : 'Edit',
    back: language === 'vi' ? 'Quay lại danh sách' : 'Back to list',
    editAction: language === 'vi' ? 'Sửa' : 'Edit',
    deleteAction: language === 'vi' ? 'Xóa' : 'Delete',
    createTitle: language === 'vi' ? 'Tạo bản ghi mới' : 'Create new record',
    editTitle: language === 'vi' ? 'Cập nhật bản ghi' : 'Update record',
    crudTitle: language === 'vi' ? 'Chức năng' : 'Actions',
    noRecord: language === 'vi' ? 'Không tìm thấy bản ghi phù hợp.' : 'No matching record found.',
  };

  return labels[screen] || screen;
};

// Render bảng danh sách chính của module.
// Dữ liệu trong bảng lấy từ `module.rows` trong [`ui/admin/app/modules.js`](ui/admin/app/modules.js).
// Nếu module có URL mapping thật thì sẽ link đến trang JSP, ngược lại dùng UI demo.
window.PMS_ADMIN.renderListTable = function renderListTable(module) {
  const { t, escapeHtml } = window.PMS_ADMIN;
  const hasRealUrls = module.urls && (module.urls.list || module.urls.create);

  // Tạo URL cho action
  const getListUrl = () => module.urls?.list || '#';
  const getCreateUrl = () => module.urls?.create || 'javascript:void(0)';
  const getEditUrl = (id) => {
    if (module.urls?.edit) {
      return module.urls.edit.includes('?')
        ? `${module.urls.edit}&id=${encodeURIComponent(id)}`
        : `${module.urls.edit}?id=${encodeURIComponent(id)}`;
    }
    return 'javascript:void(0)';
  };

  return `
    <div class="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
      <div class="flex items-center justify-between border-b border-slate-100 px-5 py-4 bg-slate-50/50">
        <div>
          <p class="text-sm font-semibold text-slate-800">${escapeHtml(t('tableTitle'))}</p>
          <p class="text-xs text-slate-500">${escapeHtml(window.PMS_ADMIN.getScreenLabel('list'))}</p>
        </div>
        ${hasRealUrls
          ? `<a class="rounded-xl bg-teal-600 px-4 py-2.5 text-sm font-semibold text-white hover:bg-teal-700 hover:shadow-lg hover:shadow-teal-600/25 transition-all duration-200" href="${escapeHtml(getCreateUrl())}">
              <span class="flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4" />
                </svg>
                ${escapeHtml(t('formView'))}
              </span>
            </a>`
          : `<button class="rounded-xl bg-teal-600 px-4 py-2.5 text-sm font-semibold text-white hover:bg-teal-700 hover:shadow-lg hover:shadow-teal-600/25 transition-all duration-200" type="button" onclick="window.PMS_ADMIN.openModuleScreen('create')">
              <span class="flex items-center gap-2">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4" />
                </svg>
                ${escapeHtml(t('formView'))}
              </span>
            </button>`
        }
      </div>
      <div class="overflow-x-auto">
        <table class="min-w-full">
          <thead class="bg-slate-50">
            <tr>
              <th class="px-5 py-3 text-left text-xs font-bold uppercase tracking-wider text-slate-500">ID</th>
              <th class="px-5 py-3 text-left text-xs font-bold uppercase tracking-wider text-slate-500">Name</th>
              <th class="px-5 py-3 text-left text-xs font-bold uppercase tracking-wider text-slate-500">Type</th>
              <th class="px-5 py-3 text-left text-xs font-bold uppercase tracking-wider text-slate-500">${escapeHtml(t('status'))}</th>
              <th class="px-5 py-3 text-left text-xs font-bold uppercase tracking-wider text-slate-500">${escapeHtml(window.PMS_ADMIN.getScreenLabel('crudTitle'))}</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-100">
            ${module.rows
              .map(
                (row) => `
                  <tr class="hover:bg-teal-50/50 transition-colors duration-150 group">
                    <td class="px-5 py-4 text-sm font-medium text-slate-700">${escapeHtml(row.id)}</td>
                    <td class="px-5 py-4 text-sm text-slate-600">${escapeHtml(row.name)}</td>
                    <td class="px-5 py-4 text-sm text-slate-600">
                      <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-slate-100 text-slate-600 group-hover:bg-teal-100 group-hover:text-teal-700 transition-colors">
                        ${escapeHtml(row.type)}
                      </span>
                    </td>
                    <td class="px-5 py-4 text-sm text-slate-600">
                      <span class="inline-flex items-center gap-1.5">
                        <span class="h-2 w-2 rounded-full ${row.status === 'Active' || row.status === 'Ready' || row.status === 'Running' || row.status === 'Approved' || row.status === 'Available' ? 'bg-emerald-500' : row.status === 'Pending' || row.status === 'Planned' ? 'bg-amber-500' : 'bg-slate-400'}"></span>
                        ${escapeHtml(row.status)}
                      </span>
                    </td>
                    <td class="px-5 py-4 text-sm">
                      <div class="flex gap-2">
                        ${hasRealUrls
                          ? `<a class="rounded-lg border border-slate-200 bg-white px-3 py-1.5 text-xs font-semibold text-slate-600 hover:border-teal-500 hover:text-teal-600 hover:bg-teal-50 transition-all duration-150" href="${escapeHtml(getEditUrl(row.id))}">${escapeHtml(window.PMS_ADMIN.getScreenLabel('editAction'))}</a>`
                          : `<button class="rounded-lg border border-slate-200 bg-white px-3 py-1.5 text-xs font-semibold text-slate-600 hover:border-teal-500 hover:text-teal-600 hover:bg-teal-50 transition-all duration-150" type="button" onclick="window.PMS_ADMIN.openModuleScreen('edit', '${escapeHtml(row.id)}')">${escapeHtml(window.PMS_ADMIN.getScreenLabel('editAction'))}</button>`
                        }
                        <button class="rounded-lg border border-rose-200 bg-white px-3 py-1.5 text-xs font-semibold text-rose-500 hover:bg-rose-50 hover:border-rose-300 transition-all duration-150" type="button" onclick="if(confirm('Are you sure you want to delete this item?')) { window.PMS_ADMIN.showToast('Item deleted successfully', 'success'); }">
                          ${escapeHtml(window.PMS_ADMIN.getScreenLabel('deleteAction'))}
                        </button>
                      </div>
                    </td>
                  </tr>
                `,
              )
              .join('')}
          </tbody>
        </table>
      </div>
    </div>
  `;
};
                      </div>
                    </td>
                  </tr>
                `,
              )
              .join('')}
          </tbody>
        </table>
      </div>
    </div>
  `;
};

// Render form create/edit riêng cho module.
// Đây mới là form UI demo để mô phỏng flow CRUD tách trang.
// Chưa có submit thật và chưa gọi servlet/controller backend.
window.PMS_ADMIN.renderModuleForm = function renderModuleForm(module, mode) {
  const { escapeHtml } = window.PMS_ADMIN;
  const record = module.rows.find((item) => item.id === window.PMS_ADMIN.state.app.activeRecordId) || module.rows[0] || null;
  const title = mode === 'edit' ? window.PMS_ADMIN.getScreenLabel('editTitle') : window.PMS_ADMIN.getScreenLabel('createTitle');

  if (mode === 'edit' && !record) {
    return `
      <div class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
        <p class="text-sm text-slate-600">${escapeHtml(window.PMS_ADMIN.getScreenLabel('noRecord'))}</p>
        <button class="mt-4 rounded-xl border border-slate-200 px-4 py-2 text-sm font-semibold text-slate-700" type="button" onclick="window.PMS_ADMIN.openModuleScreen('list')">
          ${escapeHtml(window.PMS_ADMIN.getScreenLabel('back'))}
        </button>
      </div>
    `;
  }

  return `
    <div class="rounded-2xl border border-slate-100 bg-white p-6 shadow-sm">
      <div class="mb-6 flex items-center justify-between gap-3">
        <div>
          <p class="text-xs font-semibold uppercase tracking-wide text-teal-600">${escapeHtml(window.PMS_ADMIN.getScreenLabel(mode))}</p>
          <h3 class="mt-1 text-xl font-semibold text-slate-800">${escapeHtml(title)}</h3>
        </div>
        <button class="rounded-xl border border-slate-200 px-4 py-2 text-sm font-semibold text-slate-700" type="button" onclick="window.PMS_ADMIN.openModuleScreen('list')">
          ${escapeHtml(window.PMS_ADMIN.getScreenLabel('back'))}
        </button>
      </div>

      <div class="grid gap-4 md:grid-cols-2">
        ${[
          { key: 'id', value: record?.id || '' },
          { key: 'name', value: record?.name || '' },
          { key: 'type', value: record?.type || '' },
          { key: 'status', value: record?.status || '' },
        ]
          .map(
            (field) => `
              <label class="block">
                <span class="mb-1 block text-xs font-medium uppercase tracking-wide text-slate-500">${escapeHtml(field.key)}</span>
                <input
                  type="text"
                  value="${escapeHtml(field.value)}"
                  class="w-full rounded-xl border border-slate-200 bg-slate-50 px-3 py-2.5 text-sm text-slate-700 focus:border-teal-500 focus:outline-none focus:ring-2 focus:ring-teal-200"
                />
              </label>
            `,
          )
          .join('')}
      </div>

      <div class="mt-6 flex gap-3">
        <button class="rounded-xl bg-teal-600 px-4 py-2.5 text-sm font-semibold text-white" type="button">${escapeHtml(window.PMS_ADMIN.t('save'))}</button>
        <button class="rounded-xl border border-slate-200 px-4 py-2.5 text-sm font-semibold text-slate-600" type="button" onclick="window.PMS_ADMIN.openModuleScreen('list')">${escapeHtml(window.PMS_ADMIN.t('reset'))}</button>
      </div>
    </div>
  `;
};

// Hàm render tổng của từng module.
// Nếu đang ở screen `list` thì hiện bảng.
// Nếu đang ở `create` hoặc `edit` thì hiện form riêng.
// Nếu module có URL mapping thật thì hiện nút "Open full page" để đến trang JSP.
window.PMS_ADMIN.renderModule = function renderModule(module) {
  const { t, escapeHtml, getText, renderInfoRow } = window.PMS_ADMIN;
  const screen = window.PMS_ADMIN.state.app.activeScreen || 'list';
  const isFormScreen = screen === 'create' || screen === 'edit';
  const hasRealUrls = module.urls && (module.urls.list || module.urls.create);

  const getListUrl = () => module.urls?.list || '#';
  const getCreateUrl = () => module.urls?.create || 'javascript:void(0)';

  return `
    <section class="grid gap-6 xl:grid-cols-[1.6fr_0.8fr]">
      <article class="space-y-6">
        <div class="rounded-2xl bg-white p-6 shadow-sm">
          <div class="flex flex-wrap items-start justify-between gap-4">
            <div class="flex items-center gap-3">
              <span class="inline-flex h-11 w-11 items-center justify-center rounded-2xl bg-teal-500/10 text-lg text-teal-700">${escapeHtml(module.icon)}</span>
              <div>
                <h3 class="text-xl font-semibold text-slate-800">${escapeHtml(getText(module.title))}</h3>
                <p class="mt-1 text-sm text-slate-500">${escapeHtml(getText(module.subtitle))}</p>
              </div>
            </div>
            <div class="flex items-center gap-2">
              ${hasRealUrls
                ? `<a class="rounded-full bg-teal-100 px-3 py-1 text-xs font-semibold text-teal-700" href="${escapeHtml(getListUrl())}">Open full page</a>`
                : ''
              }
              <div class="rounded-full bg-slate-100 px-3 py-1 text-xs font-semibold text-slate-600">
                ${escapeHtml(window.PMS_ADMIN.getScreenLabel(isFormScreen ? screen : 'list'))}
              </div>
            </div>
          </div>
        </div>

        ${isFormScreen ? window.PMS_ADMIN.renderModuleForm(module, screen) : window.PMS_ADMIN.renderListTable(module)}
      </article>

      <aside class="space-y-6">
        <article class="rounded-2xl bg-white p-6 shadow-sm">
          <h3 class="text-lg font-semibold text-slate-800">${escapeHtml(t('summaryTitle'))}</h3>
          <div class="mt-4 space-y-3">
            ${renderInfoRow(t('controller'), module.controller)}
            ${renderInfoRow(t('dependencies'), module.dependencies.length ? module.dependencies.join(', ') : t('noDependency'))}
            ${renderInfoRow(t('actions'), module.actions.join(', '))}
          </div>
        </article>
      </aside>
    </section>
  `;
};
