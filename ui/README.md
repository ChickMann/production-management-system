# UI PMS Structure Guide

## Current structure
- [`ui/index.html`](ui/index.html): Simple portal page for the available UI screens.
- [`ui/auth/index.html`](ui/auth/index.html): Simplified sign-in page.
- [`ui/admin/index.html`](ui/admin/index.html): Simplified admin workspace shell.
- [`ui/shared/styles/tokens.css`](ui/shared/styles/tokens.css): Shared design tokens.
- [`ui/shared/styles/base.css`](ui/shared/styles/base.css): Shared layout and component utilities.
- [`ui/shared/scripts/i18n.js`](ui/shared/scripts/i18n.js): Shared EN/VI translation dictionary.
- [`ui/shared/scripts/utils.js`](ui/shared/scripts/utils.js): Shared UI helpers.
- [`ui/admin/assets/admin.css`](ui/admin/assets/admin.css): Admin-specific styles.
- [`ui/admin/assets/modules.js`](ui/admin/assets/modules.js): Simplified admin module data.
- [`ui/admin/assets/admin.js`](ui/admin/assets/admin.js): Admin rendering logic with default language `en`.

## UI goals
The current UI has been simplified to:
- use a clearer layout
- reduce visual noise inside dashboard and modules
- keep only the main PMS production modules
- support both English and Vietnamese
- default to English for labels and screen copy

## Admin modules
The simplified admin workspace keeps these modules:
- Dashboard
- Users
- Items
- BOM
- Routing
- Work Orders
- Production Logs
- Suppliers
- Purchase Orders
- Bills

## Language behavior
- Default language: `en`
- Secondary language: `vi`
- Shared dictionary location: [`ui/shared/scripts/i18n.js`](ui/shared/scripts/i18n.js)
- Shared helper functions: [`ui/shared/scripts/utils.js`](ui/shared/scripts/utils.js)

## How the admin UI works
- [`ui/admin/index.html`](ui/admin/index.html) provides the shell layout.
- [`ui/admin/assets/modules.js`](ui/admin/assets/modules.js) stores simplified module metadata and demo rows.
- [`ui/admin/assets/admin.js`](ui/admin/assets/admin.js) renders dashboard content, module content, and language switching.
- [`ui/admin/assets/admin.css`](ui/admin/assets/admin.css) controls the simplified admin layout.

## Why the structure was changed
Compared with the old version, the new structure:
- separates shared assets from admin-specific assets
- reduces one large mixed file into clearer folders
- makes future JSP mapping easier
- makes module-level updates easier
- keeps dashboard content shorter and easier to scan

## Suggested JSP mapping
Example mapping in [`web/`](web/):
- Admin shell assets → `web/assets/admin/`
- Shared assets → `web/assets/shared/`
- Login page assets → `web/assets/auth/`

Suggested screens:
- Admin dashboard → `web/admin.jsp`
- Login page → `web/login.jsp`

## Next integration step
To connect with backend controllers, replace demo rows in [`ui/admin/assets/modules.js`](ui/admin/assets/modules.js) with real servlet/JSP data from controllers such as:
- [`UserController`](src/java/pms/controllers/UserController.java:1)
- [`ItemController`](src/java/pms/controllers/ItemController.java:1)
- [`BomController`](src/java/pms/controllers/BomController.java:1)
- [`RoutingController`](src/java/pms/controllers/RoutingController.java:1)
- [`WorkOrderController`](src/java/pms/controllers/WorkOrderController.java:1)
- [`ProductionLogController`](src/java/pms/controllers/ProductionLogController.java:1)
- [`SupplierController`](src/java/pms/controllers/SupplierController.java:1)

## Notes
Legacy files such as [`ui/app.js`](ui/app.js:1), [`ui/styles.css`](ui/styles.css), [`ui/admin/app.js`](ui/admin/app.js:1), and [`ui/admin/styles.css`](ui/admin/styles.css) are no longer the primary implementation path for the simplified workspace.
