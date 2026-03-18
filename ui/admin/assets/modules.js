window.PMS_ADMIN_MODULES = [
  {
    id: 'dashboard',
    key: 'dashboard',
    controller: 'MainController',
    actions: ['Open dashboard', 'Review KPIs', 'Check latest updates'],
    dependencies: ['Users', 'Items', 'Work Orders'],
    metrics: [
      { label: 'Open work orders', value: '24', note: '4 due today' },
      { label: 'Items in stock', value: '128', note: '12 low stock' },
      { label: 'Production logs', value: '56', note: 'Today entries' },
      { label: 'Pending bills', value: '8', note: 'Need review' }
    ],
    activity: [
      { module: 'Work Orders', detail: 'WO-1024 released for assembly', time: '10:30' },
      { module: 'Production Logs', detail: 'Shift A reported 2 defects', time: '09:50' },
      { module: 'Purchase Orders', detail: 'PO-204 sent to supplier', time: '09:10' }
    ],
    quickActions: ['Create work order', 'Review production log', 'Update item stock'],
    summary: ['9 core modules active', 'Language toggle ready', 'Simple layout for JSP integration']
  },
  {
    id: 'users',
    key: 'users',
    controller: 'UserController',
    actions: ['listUser', 'addUser', 'updateUser', 'removeUser'],
    dependencies: ['Session user'],
    rows: [
      { id: 'U01', name: 'John Admin', role: 'Admin', status: 'Active' },
      { id: 'U02', name: 'Lan Tran', role: 'Supervisor', status: 'Active' },
      { id: 'U03', name: 'Minh Le', role: 'Worker', status: 'Inactive' }
    ]
  },
  {
    id: 'items',
    key: 'items',
    controller: 'ItemController',
    actions: ['listItem', 'addItem', 'updateItem', 'removeItem'],
    dependencies: ['None'],
    rows: [
      { id: 'IT01', name: 'Steel Sheet', type: 'Material', status: 'Available' },
      { id: 'IT02', name: 'Motor Housing', type: 'Finished Good', status: 'Available' },
      { id: 'IT03', name: 'Bearing Kit', type: 'Component', status: 'Low stock' }
    ]
  },
  {
    id: 'bom',
    key: 'bom',
    controller: 'BomController',
    actions: ['listBOM', 'addBOM', 'updateBOM', 'deleteBOM'],
    dependencies: ['Items'],
    rows: [
      { id: 'BOM01', name: 'Motor Set', type: 'Assembly', status: 'Ready' },
      { id: 'BOM02', name: 'Fan Unit', type: 'Assembly', status: 'Draft' },
      { id: 'BOM03', name: 'Panel Kit', type: 'Sub Assembly', status: 'Ready' }
    ]
  },
  {
    id: 'routing',
    key: 'routing',
    controller: 'RoutingController',
    actions: ['listRouting', 'addRouting', 'updateRouting', 'deleteRouting'],
    dependencies: ['None'],
    rows: [
      { id: 'R01', name: 'Assembly Line A', type: 'Line', status: 'Ready' },
      { id: 'R02', name: 'Packaging Route', type: 'Route', status: 'Ready' },
      { id: 'R03', name: 'Inspection Route', type: 'Route', status: 'Review' }
    ]
  },
  {
    id: 'work-orders',
    key: 'workOrders',
    controller: 'WorkOrderController',
    actions: ['search', 'insert', 'update', 'delete'],
    dependencies: ['Items', 'Routing'],
    rows: [
      { id: 'WO01', name: 'Motor Batch 01', type: 'Production', status: 'Running' },
      { id: 'WO02', name: 'Panel Batch 04', type: 'Production', status: 'Planned' },
      { id: 'WO03', name: 'Repair Batch 02', type: 'Rework', status: 'On hold' }
    ]
  },
  {
    id: 'production-logs',
    key: 'productionLogs',
    controller: 'ProductionLogController',
    actions: ['listProduction', 'insert', 'update', 'delete'],
    dependencies: ['Work Orders', 'Routing Step', 'Users'],
    rows: [
      { id: 'PL01', name: 'Shift A / WO01', type: 'Daily log', status: 'Submitted' },
      { id: 'PL02', name: 'Shift B / WO02', type: 'Daily log', status: 'Pending' },
      { id: 'PL03', name: 'Shift A / WO03', type: 'Issue log', status: 'Reviewed' }
    ]
  },
  {
    id: 'suppliers',
    key: 'suppliers',
    controller: 'SupplierController',
    actions: ['listSupplier', 'addSupplier', 'updateSupplier', 'removeSupplier'],
    dependencies: ['None'],
    rows: [
      { id: 'S01', name: 'ABC Metals', type: 'Raw material', status: 'Approved' },
      { id: 'S02', name: 'Fast Parts Co.', type: 'Component', status: 'Approved' },
      { id: 'S03', name: 'Delta Pack', type: 'Packaging', status: 'Review' }
    ]
  },
  {
    id: 'purchase-orders',
    key: 'purchaseOrders',
    controller: 'PurchaseOrderController',
    actions: ['listPurchaseOrder', 'addPurchaseOrder', 'updatePurchaseOrder', 'searchPurchaseOrder'],
    dependencies: ['Suppliers', 'Items'],
    rows: [
      { id: 'PO01', name: 'Steel Sheet Refill', type: 'Material order', status: 'Open' },
      { id: 'PO02', name: 'Bearing Kit Order', type: 'Component order', status: 'Approved' },
      { id: 'PO03', name: 'Packing Cartons', type: 'Packaging order', status: 'Draft' }
    ]
  },
  {
    id: 'bills',
    key: 'bills',
    controller: 'BillController',
    actions: ['listBill', 'addBill', 'updateBill', 'searchBill'],
    dependencies: ['Customers'],
    rows: [
      { id: 'B01', name: 'Invoice 2026-001', type: 'Sales bill', status: 'Pending' },
      { id: 'B02', name: 'Invoice 2026-002', type: 'Sales bill', status: 'Paid' },
      { id: 'B03', name: 'Invoice 2026-003', type: 'Sales bill', status: 'Review' }
    ]
  }
];
