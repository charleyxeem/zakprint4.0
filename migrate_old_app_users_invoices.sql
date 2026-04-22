-- ============================================================
-- ZakPrinting V4: Legacy Users + Invoices Data Migration
-- Source staging tables: legacy_users, legacy_invoices, legacy_invoice_items, legacy_invoice_payments (same database)
-- Target DB: current active database (run USE <new_db> before this)
--
-- Scope:
-- 1) Migrate users with roles: super_admin, admin, developer
-- 2) Migrate invoices
-- 3) Migrate invoice_items
-- 4) Migrate invoice_payments
--
-- Notes:
-- - Idempotent for users/invoices (email + invoice_no keys)
-- - Item/payment inserts use value-based duplicate checks
-- - Maps legacy status "completed" to "paid" for V4 compatibility
-- ============================================================

START TRANSACTION;

-- ------------------------------------------------------------
-- 0) Source staging tables must exist in CURRENT database
-- Create and fill these first:
--   legacy_users
--   legacy_invoices
--   legacy_invoice_items
--   legacy_invoice_payments
SELECT CASE
  WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'legacy_users')
   AND EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'legacy_invoices')
   AND EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'legacy_invoice_items')
   AND EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'legacy_invoice_payments')
  THEN 'OK: legacy staging tables found'
  ELSE 'ERROR: create legacy_* staging tables in this DB before running migration'
END AS source_staging_check;

-- ------------------------------------------------------------
-- 1) Ensure target tables/columns required by V4 APIs exist
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
  id INT(11) NOT NULL AUTO_INCREMENT,
  tenant_id INT(11) NOT NULL DEFAULT 1,
  name VARCHAR(200) NOT NULL,
  email VARCHAR(200) NOT NULL,
  phone VARCHAR(50) DEFAULT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(30) NOT NULL DEFAULT 'user',
  reset_token VARCHAR(255) DEFAULT NULL,
  reset_expires DATETIME DEFAULT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_users_email (email),
  KEY idx_users_role (role),
  KEY idx_users_tenant (tenant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE users
  ADD COLUMN IF NOT EXISTS tenant_id INT(11) NOT NULL DEFAULT 1 AFTER id,
  ADD COLUMN IF NOT EXISTS name VARCHAR(200) NOT NULL AFTER tenant_id,
  ADD COLUMN IF NOT EXISTS email VARCHAR(200) NOT NULL AFTER name,
  ADD COLUMN IF NOT EXISTS phone VARCHAR(50) DEFAULT NULL AFTER email,
  ADD COLUMN IF NOT EXISTS password_hash VARCHAR(255) NOT NULL AFTER phone,
  ADD COLUMN IF NOT EXISTS role VARCHAR(30) NOT NULL DEFAULT 'user' AFTER password_hash,
  ADD COLUMN IF NOT EXISTS reset_token VARCHAR(255) DEFAULT NULL AFTER role,
  ADD COLUMN IF NOT EXISTS reset_expires DATETIME DEFAULT NULL AFTER reset_token,
  ADD COLUMN IF NOT EXISTS created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP AFTER reset_expires,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at;

CREATE TABLE IF NOT EXISTS invoices (
  id INT(11) NOT NULL AUTO_INCREMENT,
  tenant_id INT(11) DEFAULT 1,
  created_by INT(11) DEFAULT NULL,
  invoice_no VARCHAR(100) NOT NULL,
  customer_name VARCHAR(200) DEFAULT NULL,
  total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  amount_paid DECIMAL(12,2) DEFAULT 0.00,
  status VARCHAR(50) NOT NULL DEFAULT 'unpaid',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  due_date DATE DEFAULT NULL,
  client_name VARCHAR(200) DEFAULT NULL,
  client_phone VARCHAR(50) DEFAULT NULL,
  client_email VARCHAR(200) DEFAULT NULL,
  client_company VARCHAR(200) DEFAULT NULL,
  include_tax TINYINT(1) DEFAULT 0,
  tax_percent DECIMAL(6,2) DEFAULT 0.00,
  subtotal DECIMAL(12,2) DEFAULT 0.00,
  design_file VARCHAR(255) DEFAULT NULL,
  external_design_link VARCHAR(255) DEFAULT NULL,
  notes TEXT DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_invoices_invoice_no (invoice_no),
  KEY idx_invoices_created_by (created_by),
  KEY idx_invoices_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE invoices
  ADD COLUMN IF NOT EXISTS tenant_id INT(11) DEFAULT 1 AFTER id,
  ADD COLUMN IF NOT EXISTS created_by INT(11) DEFAULT NULL AFTER tenant_id,
  ADD COLUMN IF NOT EXISTS invoice_no VARCHAR(100) NOT NULL AFTER created_by,
  ADD COLUMN IF NOT EXISTS customer_name VARCHAR(200) DEFAULT NULL AFTER invoice_no,
  ADD COLUMN IF NOT EXISTS total DECIMAL(12,2) NOT NULL DEFAULT 0.00 AFTER customer_name,
  ADD COLUMN IF NOT EXISTS amount_paid DECIMAL(12,2) DEFAULT 0.00 AFTER total,
  ADD COLUMN IF NOT EXISTS status VARCHAR(50) NOT NULL DEFAULT 'unpaid' AFTER amount_paid,
  ADD COLUMN IF NOT EXISTS created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP AFTER status,
  ADD COLUMN IF NOT EXISTS due_date DATE DEFAULT NULL AFTER created_at,
  ADD COLUMN IF NOT EXISTS client_name VARCHAR(200) DEFAULT NULL AFTER due_date,
  ADD COLUMN IF NOT EXISTS client_phone VARCHAR(50) DEFAULT NULL AFTER client_name,
  ADD COLUMN IF NOT EXISTS client_email VARCHAR(200) DEFAULT NULL AFTER client_phone,
  ADD COLUMN IF NOT EXISTS client_company VARCHAR(200) DEFAULT NULL AFTER client_email,
  ADD COLUMN IF NOT EXISTS include_tax TINYINT(1) DEFAULT 0 AFTER client_company,
  ADD COLUMN IF NOT EXISTS tax_percent DECIMAL(6,2) DEFAULT 0.00 AFTER include_tax,
  ADD COLUMN IF NOT EXISTS subtotal DECIMAL(12,2) DEFAULT 0.00 AFTER tax_percent,
  ADD COLUMN IF NOT EXISTS design_file VARCHAR(255) DEFAULT NULL AFTER subtotal,
  ADD COLUMN IF NOT EXISTS external_design_link VARCHAR(255) DEFAULT NULL AFTER design_file,
  ADD COLUMN IF NOT EXISTS notes TEXT DEFAULT NULL AFTER external_design_link;

CREATE TABLE IF NOT EXISTS invoice_items (
  id INT(11) NOT NULL AUTO_INCREMENT,
  invoice_id INT(11) NOT NULL,
  product_id INT(11) DEFAULT NULL,
  finance_product_id INT(11) DEFAULT NULL,
  description TEXT DEFAULT NULL,
  quantity INT(11) NOT NULL DEFAULT 1,
  price DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  line_total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  tax_percent DECIMAL(6,2) NOT NULL DEFAULT 0.00,
  tax_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (id),
  KEY idx_invoice_items_invoice_id (invoice_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE invoice_items
  ADD COLUMN IF NOT EXISTS product_id INT(11) DEFAULT NULL AFTER invoice_id,
  ADD COLUMN IF NOT EXISTS finance_product_id INT(11) DEFAULT NULL AFTER product_id,
  ADD COLUMN IF NOT EXISTS description TEXT DEFAULT NULL AFTER finance_product_id,
  ADD COLUMN IF NOT EXISTS quantity INT(11) NOT NULL DEFAULT 1 AFTER description,
  ADD COLUMN IF NOT EXISTS price DECIMAL(12,2) NOT NULL DEFAULT 0.00 AFTER quantity,
  ADD COLUMN IF NOT EXISTS line_total DECIMAL(12,2) NOT NULL DEFAULT 0.00 AFTER price,
  ADD COLUMN IF NOT EXISTS tax_percent DECIMAL(6,2) NOT NULL DEFAULT 0.00 AFTER line_total,
  ADD COLUMN IF NOT EXISTS tax_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00 AFTER tax_percent;

CREATE TABLE IF NOT EXISTS invoice_payments (
  id INT(11) NOT NULL AUTO_INCREMENT,
  invoice_id INT(11) NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  method VARCHAR(100) DEFAULT 'Migrated',
  paid_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_invoice_payments_invoice_id (invoice_id),
  KEY idx_invoice_payments_paid_at (paid_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE invoice_payments
  ADD COLUMN IF NOT EXISTS method VARCHAR(100) DEFAULT 'Migrated' AFTER amount;

-- ------------------------------------------------------------
-- 2) Users migration (super_admin/admin/developer only)
-- ------------------------------------------------------------
INSERT INTO users (
  tenant_id,
  name,
  email,
  phone,
  password_hash,
  role,
  reset_token,
  reset_expires,
  created_at
)
SELECT
  COALESCE(su.tenant_id, 1) AS tenant_id,
  su.name,
  su.email,
  su.phone,
  su.password_hash,
  su.role,
  su.reset_token,
  su.reset_expires,
  su.created_at
FROM legacy_users su
WHERE su.role IN ('super_admin', 'admin', 'developer')
ON DUPLICATE KEY UPDATE
  name = VALUES(name),
  phone = COALESCE(NULLIF(VALUES(phone), ''), users.phone),
  password_hash = VALUES(password_hash),
  role = VALUES(role),
  reset_token = VALUES(reset_token),
  reset_expires = VALUES(reset_expires),
  tenant_id = COALESCE(users.tenant_id, VALUES(tenant_id));

-- Build source->target user id map by email
DROP TEMPORARY TABLE IF EXISTS tmp_user_map;
CREATE TEMPORARY TABLE tmp_user_map AS
SELECT
  su.id AS source_user_id,
  tu.id AS target_user_id,
  su.email
FROM legacy_users su
JOIN users tu ON LOWER(tu.email) = LOWER(su.email)
WHERE su.role IN ('super_admin', 'admin', 'developer');

CREATE INDEX idx_tmp_user_map_source ON tmp_user_map(source_user_id);

-- ------------------------------------------------------------
-- 3) Invoices migration
-- ------------------------------------------------------------
INSERT INTO invoices (
  tenant_id,
  created_by,
  invoice_no,
  customer_name,
  total,
  amount_paid,
  status,
  created_at,
  due_date,
  client_name,
  client_phone,
  client_email,
  client_company,
  include_tax,
  tax_percent,
  subtotal,
  design_file,
  external_design_link,
  notes
)
SELECT
  COALESCE(si.tenant_id, 1) AS tenant_id,
  um.target_user_id AS created_by,
  si.invoice_no,
  si.customer_name,
  CAST(si.total AS DECIMAL(12,2)) AS total,
  CAST(COALESCE(si.amount_paid, 0) AS DECIMAL(12,2)) AS amount_paid,
  CASE
    WHEN si.status = 'completed' THEN 'paid'
    WHEN si.status IN ('draft', 'sent', 'accepted', 'unpaid', 'partial', 'paid', 'cancelled') THEN si.status
    ELSE 'unpaid'
  END AS status,
  si.created_at,
  si.due_date,
  si.client_name,
  si.client_phone,
  si.client_email,
  si.client_company,
  COALESCE(si.include_tax, 0) AS include_tax,
  COALESCE(si.tax_percent, 0) AS tax_percent,
  COALESCE(si.subtotal, si.total) AS subtotal,
  si.design_file,
  si.external_design_link,
  si.notes
FROM legacy_invoices si
LEFT JOIN tmp_user_map um ON um.source_user_id = si.created_by
LEFT JOIN invoices ti ON ti.invoice_no = si.invoice_no
WHERE ti.id IS NULL;

-- Keep existing invoices in sync for core numeric/status fields
UPDATE invoices ti
JOIN legacy_invoices si ON si.invoice_no = ti.invoice_no
LEFT JOIN tmp_user_map um ON um.source_user_id = si.created_by
SET
  ti.created_by = COALESCE(ti.created_by, um.target_user_id),
  ti.total = CAST(si.total AS DECIMAL(12,2)),
  ti.amount_paid = CAST(COALESCE(si.amount_paid, 0) AS DECIMAL(12,2)),
  ti.status = CASE
    WHEN si.status = 'completed' THEN 'paid'
    WHEN si.status IN ('draft', 'sent', 'accepted', 'unpaid', 'partial', 'paid', 'cancelled') THEN si.status
    ELSE 'unpaid'
  END,
  ti.include_tax = COALESCE(si.include_tax, 0),
  ti.tax_percent = COALESCE(si.tax_percent, 0),
  ti.subtotal = COALESCE(si.subtotal, si.total),
  ti.notes = COALESCE(si.notes, ti.notes);

-- Map source invoices to target invoices by stable invoice_no
DROP TEMPORARY TABLE IF EXISTS tmp_invoice_map;
CREATE TEMPORARY TABLE tmp_invoice_map AS
SELECT
  si.id AS source_invoice_id,
  ti.id AS target_invoice_id,
  si.invoice_no
FROM legacy_invoices si
JOIN invoices ti ON ti.invoice_no = si.invoice_no;

CREATE INDEX idx_tmp_invoice_map_source ON tmp_invoice_map(source_invoice_id);
CREATE INDEX idx_tmp_invoice_map_target ON tmp_invoice_map(target_invoice_id);

-- ------------------------------------------------------------
-- 4) Invoice items migration
-- ------------------------------------------------------------
INSERT INTO invoice_items (
  invoice_id,
  product_id,
  finance_product_id,
  description,
  quantity,
  price,
  line_total,
  tax_percent,
  tax_amount
)
SELECT
  im.target_invoice_id,
  sii.product_id,
  sii.finance_product_id,
  sii.description,
  sii.quantity,
  CAST(sii.price AS DECIMAL(12,2)) AS price,
  CAST(sii.line_total AS DECIMAL(12,2)) AS line_total,
  CAST(COALESCE(sii.tax_percent, 0) AS DECIMAL(6,2)) AS tax_percent,
  CAST(COALESCE(sii.tax_amount, 0) AS DECIMAL(12,2)) AS tax_amount
FROM legacy_invoice_items sii
JOIN tmp_invoice_map im ON im.source_invoice_id = sii.invoice_id
WHERE NOT EXISTS (
  SELECT 1
  FROM invoice_items tii
  WHERE tii.invoice_id = im.target_invoice_id
    AND COALESCE(tii.product_id, 0) = COALESCE(sii.product_id, 0)
    AND COALESCE(tii.finance_product_id, 0) = COALESCE(sii.finance_product_id, 0)
    AND COALESCE(tii.description, '') = COALESCE(sii.description, '')
    AND tii.quantity = sii.quantity
    AND CAST(tii.price AS DECIMAL(12,2)) = CAST(sii.price AS DECIMAL(12,2))
    AND CAST(tii.line_total AS DECIMAL(12,2)) = CAST(sii.line_total AS DECIMAL(12,2))
    AND CAST(COALESCE(tii.tax_percent, 0) AS DECIMAL(6,2)) = CAST(COALESCE(sii.tax_percent, 0) AS DECIMAL(6,2))
    AND CAST(COALESCE(tii.tax_amount, 0) AS DECIMAL(12,2)) = CAST(COALESCE(sii.tax_amount, 0) AS DECIMAL(12,2))
);

-- ------------------------------------------------------------
-- 5) Invoice payments migration
-- ------------------------------------------------------------
INSERT INTO invoice_payments (
  invoice_id,
  amount,
  method,
  paid_at
)
SELECT
  im.target_invoice_id,
  CAST(sip.amount AS DECIMAL(12,2)) AS amount,
  'Migrated' AS method,
  sip.paid_at
FROM legacy_invoice_payments sip
JOIN tmp_invoice_map im ON im.source_invoice_id = sip.invoice_id
WHERE NOT EXISTS (
  SELECT 1
  FROM invoice_payments tip
  WHERE tip.invoice_id = im.target_invoice_id
    AND CAST(tip.amount AS DECIMAL(12,2)) = CAST(sip.amount AS DECIMAL(12,2))
    AND tip.paid_at = sip.paid_at
);

-- ------------------------------------------------------------
-- 6) Verification metrics
-- ------------------------------------------------------------
SELECT 'source_admin_users' AS metric, COUNT(*) AS value
FROM legacy_users
WHERE role IN ('super_admin','admin','developer')
UNION ALL
SELECT 'target_admin_users', COUNT(*)
FROM users
WHERE role IN ('super_admin','admin','developer')
UNION ALL
SELECT 'source_invoices', COUNT(*)
FROM legacy_invoices
UNION ALL
SELECT 'target_invoices_matching_source', COUNT(*)
FROM invoices ti
JOIN legacy_invoices si ON si.invoice_no = ti.invoice_no
UNION ALL
SELECT 'source_invoice_items', COUNT(*)
FROM legacy_invoice_items
UNION ALL
SELECT 'target_invoice_items_mapped', COUNT(*)
FROM invoice_items tii
JOIN invoices ti ON ti.id = tii.invoice_id
JOIN legacy_invoices si ON si.invoice_no = ti.invoice_no
UNION ALL
SELECT 'source_invoice_payments', COUNT(*)
FROM legacy_invoice_payments
UNION ALL
SELECT 'target_invoice_payments_mapped', COUNT(*)
FROM invoice_payments tip
JOIN invoices ti ON ti.id = tip.invoice_id
JOIN legacy_invoices si ON si.invoice_no = ti.invoice_no;

COMMIT;

