-- ============================================================
-- ZakPrinting V4
-- CSV Import Script for refactored_products.csv
--
-- What this script does:
-- 1) Creates a staging table and loads refactored_products.csv
-- 2) Normalizes common spelling/casing inconsistencies
-- 3) Upserts parent products into products table (price defaults to 0)
-- 4) Preserves all combinations as product variants
--
-- ============================================================

START TRANSACTION;

-- ------------------------------------------------------------
-- 0) Input CSV path (use forward slashes on Windows)
-- ------------------------------------------------------------
SET @csv_path = 'c:/xampp/htdocs/zakprintingV4/refactored_products.csv';

-- ------------------------------------------------------------
-- 1) Staging table
-- ------------------------------------------------------------
DROP TABLE IF EXISTS stg_refactored_products;

CREATE TABLE stg_refactored_products (
  row_id INT NOT NULL AUTO_INCREMENT,
  product_handle VARCHAR(150) NOT NULL,
  product_title VARCHAR(255) NOT NULL,
  royalty_level VARCHAR(150) NULL,
  sub_product_type VARCHAR(255) NULL,
  size VARCHAR(100) NULL,
  paper_type VARCHAR(150) NULL,
  paper_grammage VARCHAR(100) NULL,
  lamination_or_color VARCHAR(150) NULL,
  specialty VARCHAR(255) NULL,
  PRIMARY KEY (row_id),
  KEY idx_stg_handle (product_handle),
  KEY idx_stg_title (product_title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- 2) Load CSV into staging (inline VALUES; no FILE privilege needed)
-- ------------------------------------------------------------
INSERT INTO stg_refactored_products (
  product_handle, product_title, royalty_level, sub_product_type, size, paper_type, paper_grammage, lamination_or_color, specialty
) VALUES
('business-cards', 'Business Cards', 'Standard', '300 Gsm Single Side', '3.2" x 1.9"', NULL, NULL, 'Shine', NULL),
('business-cards', 'Business Cards', 'Standard', '300 Gsm Single Side', '3.2" x 1.9"', NULL, NULL, 'Matte', NULL),
('business-cards', 'Business Cards', NULL, '300 Gsm Front 4 color + single color back', '3.2" x 1.9"', NULL, NULL, 'Shine', NULL),
('business-cards', 'Business Cards', NULL, '300 Gsm Front 4 color + single color back', '3.2" x 1.9"', NULL, NULL, 'Matte', NULL),
('business-cards', 'Business Cards', 'UV CARD', '350 Gsm Single Side Round Corner', '3.2" x 1.9"', NULL, NULL, 'Spot UV', NULL),
('business-cards', 'Business Cards', 'UV CARD', '350 Gsm Single Side Round Corner', '3.2" x 1.9"', NULL, NULL, 'Matte UV', NULL),
('business-cards', 'Business Cards', NULL, '350 Gsm Double Side Round Corner', '3.2" x 1.9"', NULL, NULL, 'Spot UV', NULL),
('business-cards', 'Business Cards', NULL, '350 Gsm Double Side Round Corner', '3.2" x 1.9"', NULL, NULL, 'Matte UV', NULL),
('business-cards', 'Business Cards', 'Foil Card', '350 Gsm Foil + UV Card Single Side', '3.2" x 1.9"', NULL, NULL, 'Golden Foil + UV Matte', NULL),
('business-cards', 'Business Cards', 'Foil Card', '350 Gsm Foil + UV Card Single Side', '3.2" x 1.9"', NULL, NULL, 'Golden foil  + Spot UV', NULL),
('business-cards', 'Business Cards', 'Foil Card', '350 Gsm Foil + UV Card Single Side', '3.2" x 1.9"', NULL, NULL, 'Silver Foil + Spot UV', NULL),
('business-cards', 'Business Cards', 'Foil Card', '350 Gsm Foil + UV Card Single Side', '3.2" x 1.9"', NULL, NULL, 'Silver Foil + Matte UV', NULL),
('business-cards', 'Business Cards', 'Custom Shape Card', '700 Gsm Custom Shaped Card', '3.5" x 2"', NULL, NULL, 'Spot UV', NULL),
('business-cards', 'Business Cards', 'Custom Shape Card', '700 Gsm Custom Shaped Card', '3.5" x 2"', NULL, NULL, 'Matte UV', NULL),
('business-cards', 'Business Cards', 'Premium', '700 Gsm Double Side Round Corner', '3.25" x 1.9"', NULL, NULL, 'Matte UV', NULL),
('business-cards', 'Business Cards', NULL, '700 Gsm Double Side ATM Card Size', '3.4" x 2"', NULL, NULL, 'Spot UV', NULL),
('business-cards', 'Business Cards', NULL, '700 Gsm Double Side ATM Card Size', '3.4" x 2"', NULL, NULL, 'Matte UV', NULL),
('business-cards', 'Business Cards', NULL, '700 Gsm Foil Card Double Side', '3.25" x 1.9"', NULL, NULL, 'Golden Foil + UV Matte', NULL),
('business-cards', 'Business Cards', NULL, '700 Gsm Foil Card Double Side', '3.25" x 1.9"', NULL, NULL, 'Golden foil  + Spot UV', NULL),
('business-cards', 'Business Cards', NULL, '700 Gsm Foil Card Double Side', '3.25" x 1.9"', NULL, NULL, 'Silver Foil + Spot UV', NULL),
('business-cards', 'Business Cards', NULL, '700 Gsm Foil Card Double Side', '3.25" x 1.9"', NULL, NULL, 'Silver Foil + Matte UV', NULL),
('business-cards', 'Business Cards', 'PVC Card', '0.76 MM PVC CARD Round Corner', '3.4" x 2"', NULL, NULL, 'Heat Transfer', NULL),
('business-cards', 'Business Cards', 'PVC Card', '0.76 MM PVC CARD Round Corner', '3.4" x 2"', NULL, NULL, 'UV FLAT BED', NULL),
('business-cards', 'Business Cards', 'Mettalic Card', '24 Gauge Metal Card', '3.5" x 2"', NULL, NULL, 'Black', NULL),
('business-cards', 'Business Cards', 'Mettalic Card', '24 Gauge Metal Card', '3.5" x 2"', NULL, NULL, 'Silver', NULL),
('business-cards', 'Business Cards', 'Mettalic Card', '24 Gauge Metal Card', '3.5" x 2"', NULL, NULL, 'Golden', NULL),
('envelopes', 'Envelopes', 'Standard', 'C5 Envelope', '9" x 6.4""', 'Plain Paper', '90 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', 'Standard', 'C5 Envelope', '9" x 6.4""', 'Plain Paper', '113 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', 'Standard', 'C5 Envelope', '9" x 6.4""', 'Plain Paper', '125 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', 'Standard', 'C5 Envelope', '9" x 6.4""', 'Plain Paper', '150 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', 'Standard', 'C5 Envelope', '9" x 6.4""', 'Art Paper', '90 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', 'Standard', 'C5 Envelope', '9" x 6.4""', 'Art Paper', '113 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', 'Standard', 'C5 Envelope', '9" x 6.4""', 'Art Paper', '125 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', 'Standard', 'C5 Envelope', '9" x 6.4""', 'Art Paper', '150 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', 'Standard', 'C5 Envelope', '9" x 6.4""', 'Matter Paper', '90 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', 'Standard', 'C5 Envelope', '9" x 6.4""', 'Matter Paper', '113 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', 'Standard', 'C5 Envelope', '9" x 6.4""', 'Matter Paper', '125 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', 'Standard', 'C5 Envelope', '9" x 6.4""', 'Matter Paper', '150 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', 'Standard', 'C5 Envelope', '9" x 6.4""', 'Kraft Paper', '90 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', 'Standard', 'C5 Envelope', '9" x 6.4""', 'Kraft Paper', '113 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', 'Standard', 'C5 Envelope', '9" x 6.4""', 'Kraft Paper', '125 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', 'Standard', 'C5 Envelope', '9" x 6.4""', 'Kraft Paper', '150 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'A4 Envelopes', '9" x 12.8"', 'Plain Paper', '90 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'A4 Envelopes', '9" x 12.8"', 'Plain Paper', '113 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'A4 Envelopes', '9" x 12.8"', 'Plain Paper', '125 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'A4 Envelopes', '9" x 12.8"', 'Plain Paper', '150 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'A4 Envelopes', '9" x 12.8"', 'Art Paper', '90 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'A4 Envelopes', '9" x 12.8"', 'Art Paper', '113 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'A4 Envelopes', '9" x 12.8"', 'Art Paper', '125 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'A4 Envelopes', '9" x 12.8"', 'Art Paper', '150 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'A4 Envelopes', '9" x 12.8"', 'Matter Paper', '90 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'A4 Envelopes', '9" x 12.8"', 'Matter Paper', '113 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'A4 Envelopes', '9" x 12.8"', 'Matter Paper', '125 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'A4 Envelopes', '9" x 12.8"', 'Matter Paper', '150 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'A4 Envelopes', '9" x 12.8"', 'Kraft Paper', '90 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'A4 Envelopes', '9" x 12.8"', 'Kraft Paper', '113 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'A4 Envelopes', '9" x 12.8"', 'Kraft Paper', '125 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'A4 Envelopes', '9" x 12.8"', 'Kraft Paper', '150 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'Legal Envelopes', '9.5" x 15"', 'Plain Paper', '90 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'Legal Envelopes', '9.5" x 15"', 'Plain Paper', '113 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'Legal Envelopes', '9.5" x 15"', 'Plain Paper', '125 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'Legal Envelopes', '9.5" x 15"', 'Plain Paper', '150 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'Legal Envelopes', '9.5" x 15"', 'Art Paper', '90 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'Legal Envelopes', '9.5" x 15"', 'Art Paper', '113 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'Legal Envelopes', '9.5" x 15"', 'Art Paper', '125 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'Legal Envelopes', '9.5" x 15"', 'Art Paper', '150 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'Legal Envelopes', '9.5" x 15"', 'Matter Paper', '90 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'Legal Envelopes', '9.5" x 15"', 'Matter Paper', '113 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'Legal Envelopes', '9.5" x 15"', 'Matter Paper', '125 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'Legal Envelopes', '9.5" x 15"', 'Matter Paper', '150 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'Legal Envelopes', '9.5" x 15"', 'Kraft Paper', '90 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'Legal Envelopes', '9.5" x 15"', 'Kraft Paper', '113 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'Legal Envelopes', '9.5" x 15"', 'Kraft Paper', '125 gsm', NULL, 'Windows Yes/NO'),
('envelopes', 'Envelopes', NULL, 'Legal Envelopes', '9.5" x 15"', 'Kraft Paper', '150 gsm', NULL, 'Windows Yes/NO'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '68 Gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '68 Gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '68 Gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '90 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '90 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '90 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '113 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '113 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '113 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '125 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '125 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '125 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '150 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '150 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '150 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '68 Gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '68 Gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '68 Gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '90 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '90 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '90 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '113 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '113 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '113 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '125 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '125 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '125 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '150 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '150 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '150 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '68 Gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '68 Gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '68 Gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '90 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '90 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '90 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '113 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '113 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '113 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '125 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '125 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '125 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '150 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '150 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '150 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '68 Gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '68 Gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '68 Gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '90 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '90 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '90 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '113 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '113 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '113 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '125 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '125 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '125 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '150 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '150 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', 'Standard', 'A4 Single Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '150 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '68 Gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '68 Gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '68 Gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '90 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '90 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '90 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '113 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '113 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '113 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '125 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '125 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '125 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '150 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '150 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Local', '150 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '68 Gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '68 Gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '68 Gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '90 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '90 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '90 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '113 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '113 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '113 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '125 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '125 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '125 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '150 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '150 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Plain Paper', '150 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '68 Gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '68 Gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '68 Gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '90 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '90 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '90 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '113 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '113 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '113 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '125 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '125 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '125 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '150 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '150 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Art Paper', '150 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '68 Gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '68 Gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '68 Gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '90 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '90 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '90 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '113 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '113 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '113 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '125 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '125 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '125 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '150 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '150 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A4 Double Side Brochure/Flyer', '8.25" x 11.69"', 'Matte Paper', '150 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Local', '68 Gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Local', '68 Gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Local', '68 Gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Local', '90 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Local', '90 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Local', '90 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Local', '113 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Local', '113 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Local', '113 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Local', '125 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Local', '125 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Local', '125 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Local', '150 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Local', '150 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Local', '150 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Plain Paper', '68 Gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Plain Paper', '68 Gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Plain Paper', '68 Gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Plain Paper', '90 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Plain Paper', '90 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Plain Paper', '90 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Plain Paper', '113 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Plain Paper', '113 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Plain Paper', '113 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Plain Paper', '125 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Plain Paper', '125 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Plain Paper', '125 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Plain Paper', '150 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Plain Paper', '150 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Plain Paper', '150 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Art Paper', '68 Gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Art Paper', '68 Gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Art Paper', '68 Gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Art Paper', '90 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Art Paper', '90 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Art Paper', '90 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Art Paper', '113 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Art Paper', '113 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Art Paper', '113 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Art Paper', '125 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Art Paper', '125 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Art Paper', '125 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Art Paper', '150 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Art Paper', '150 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Art Paper', '150 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Matte Paper', '68 Gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Matte Paper', '68 Gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Matte Paper', '68 Gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Matte Paper', '90 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Matte Paper', '90 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Matte Paper', '90 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Matte Paper', '113 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Matte Paper', '113 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Matte Paper', '113 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Matte Paper', '125 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Matte Paper', '125 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Matte Paper', '125 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Matte Paper', '150 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Matte Paper', '150 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Single Side Brochre/ Flyer', '5.8" x 8.25"', 'Matte Paper', '150 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Local', '68 Gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Local', '68 Gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Local', '68 Gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Local', '90 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Local', '90 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Local', '90 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Local', '113 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Local', '113 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Local', '113 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Local', '125 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Local', '125 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Local', '125 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Local', '150 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Local', '150 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Local', '150 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Plain Paper', '68 Gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Plain Paper', '68 Gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Plain Paper', '68 Gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Plain Paper', '90 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Plain Paper', '90 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Plain Paper', '90 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Plain Paper', '113 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Plain Paper', '113 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Plain Paper', '113 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Plain Paper', '125 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Plain Paper', '125 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Plain Paper', '125 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Plain Paper', '150 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Plain Paper', '150 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Plain Paper', '150 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Art Paper', '68 Gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Art Paper', '68 Gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Art Paper', '68 Gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Art Paper', '90 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Art Paper', '90 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Art Paper', '90 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Art Paper', '113 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Art Paper', '113 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Art Paper', '113 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Art Paper', '125 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Art Paper', '125 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Art Paper', '125 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Art Paper', '150 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Art Paper', '150 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Art Paper', '150 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Matte Paper', '68 Gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Matte Paper', '68 Gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Matte Paper', '68 Gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Matte Paper', '90 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Matte Paper', '90 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Matte Paper', '90 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Matte Paper', '113 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Matte Paper', '113 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Matte Paper', '113 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Matte Paper', '125 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Matte Paper', '125 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Matte Paper', '125 gsm', NULL, 'Trifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Matte Paper', '150 gsm', NULL, 'MonoFold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Matte Paper', '150 gsm', NULL, 'Bifold'),
('brochures', 'Brochures', NULL, 'A5 Double Side Brochure/Flyer', '5.8" x 8.25"', 'Matte Paper', '150 gsm', NULL, 'Trifold'),
('letterhead', 'Letterhead', 'Standard', 'A4', '8.25" x 11.69"', 'Plain Paper', '80', NULL, NULL),
('letterhead', 'Letterhead', 'Standard', 'A4', '8.25" x 11.69"', 'Plain Paper', '90', NULL, NULL),
('letterhead', 'Letterhead', 'Standard', 'A4', '8.25" x 11.69"', 'Plain Paper', '113', NULL, NULL),
('letterhead', 'Letterhead', 'Standard', 'A4', '8.25" x 11.69"', 'Plain Paper', '125', NULL, NULL),
('letterhead', 'Letterhead', 'Standard', 'A4', '8.25" x 11.69"', 'Plain Paper', '150', NULL, NULL),
('letterhead', 'Letterhead', 'Standard', 'A4', '8.25" x 11.69"', 'Art Paper', '80', NULL, NULL),
('letterhead', 'Letterhead', 'Standard', 'A4', '8.25" x 11.69"', 'Art Paper', '90', NULL, NULL),
('letterhead', 'Letterhead', 'Standard', 'A4', '8.25" x 11.69"', 'Art Paper', '113', NULL, NULL),
('letterhead', 'Letterhead', 'Standard', 'A4', '8.25" x 11.69"', 'Art Paper', '125', NULL, NULL),
('letterhead', 'Letterhead', 'Standard', 'A4', '8.25" x 11.69"', 'Art Paper', '150', NULL, NULL),
('letterhead', 'Letterhead', 'Standard', 'A4', '8.25" x 11.69"', 'Matte Paper', '80', NULL, NULL),
('letterhead', 'Letterhead', 'Standard', 'A4', '8.25" x 11.69"', 'Matte Paper', '90', NULL, NULL),
('letterhead', 'Letterhead', 'Standard', 'A4', '8.25" x 11.69"', 'Matte Paper', '113', NULL, NULL),
('letterhead', 'Letterhead', 'Standard', 'A4', '8.25" x 11.69"', 'Matte Paper', '125', NULL, NULL),
('letterhead', 'Letterhead', 'Standard', 'A4', '8.25" x 11.69"', 'Matte Paper', '150', NULL, NULL),
('letterhead', 'Letterhead', 'Textured', 'A4', '8.25" x 11.69"', 'Cheque', '100+', NULL, NULL),
('letterhead', 'Letterhead', 'Textured', 'A4', '8.25" x 11.69"', 'Lining', '100+', NULL, NULL),
('panaflex', 'Panaflex', 'Standard', 'China', 'Custom', 'Glossy', '260 gsm', NULL, NULL),
('panaflex', 'Panaflex', 'Standard', 'China', 'Custom', 'Glossy', '280 gsm', NULL, NULL),
('panaflex', 'Panaflex', 'Standard', 'China', 'Custom', 'Matte', '260 gsm', NULL, NULL),
('panaflex', 'Panaflex', 'Standard', 'China', 'Custom', 'Matte', '280 gsm', NULL, NULL),
('panaflex', 'Panaflex', 'Premium', 'Star', 'Custom', 'Glossy', '310 Gsm', NULL, NULL),
('panaflex', 'Panaflex', 'Premium', 'Star', 'Custom', 'Glossy', '340 Gsm', NULL, NULL),
('panaflex', 'Panaflex', 'Premium', 'Star', 'Custom', 'Glossy', '410 Gsm', NULL, NULL),
('panaflex', 'Panaflex', 'Premium', 'Star', 'Custom', 'Matte', '310 Gsm', NULL, NULL),
('panaflex', 'Panaflex', 'Premium', 'Star', 'Custom', 'Matte', '340 Gsm', NULL, NULL),
('panaflex', 'Panaflex', 'Premium', 'Star', 'Custom', 'Matte', '410 Gsm', NULL, NULL),
('standees', 'Standees', 'Standard', 'Panda Standee', '2'' x 5''', 'GLossy', '310 GSm', NULL, NULL),
('standees', 'Standees', 'Standard', 'Panda Standee', '2'' x 5''', 'GLossy', '410 Gsm', NULL, NULL),
('standees', 'Standees', 'Standard', 'Panda Standee', '2'' x 5''', 'MAtte', '310 GSm', NULL, NULL),
('standees', 'Standees', 'Standard', 'Panda Standee', '2'' x 5''', 'MAtte', '410 Gsm', NULL, NULL),
('standees', 'Standees', 'Premium', 'Roll up Stand', '2.5'' x 6''', 'Glossy', '340 gsm', NULL, NULL),
('standees', 'Standees', 'Premium', 'Roll up Stand', '2.5'' x 6''', 'Glossy', '410 gsm', NULL, NULL),
('standees', 'Standees', 'Premium', 'Roll up Stand', '2.5'' x 6''', 'Matte', '340 gsm', NULL, NULL),
('standees', 'Standees', 'Premium', 'Roll up Stand', '2.5'' x 6''', 'Matte', '410 gsm', NULL, NULL),
('diaries', 'Diaries', 'Standard', 'China Imported Diary', 'A5', NULL, NULL, NULL, 'Loop Binding'),
('diaries', 'Diaries', 'Standard', 'China Imported Diary', 'A5', NULL, NULL, NULL, 'Hard Bind'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'Yellow', '70 Gsm', 'Glossy', 'Loop Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'Yellow', '70 Gsm', 'Glossy', 'Hard Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'Yellow', '70 Gsm', 'Glossy', 'Spiral Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'Yellow', '70 Gsm', 'Shiny', 'Loop Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'Yellow', '70 Gsm', 'Shiny', 'Hard Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'Yellow', '70 Gsm', 'Shiny', 'Spiral Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'Yellow', '80 Gsm', 'Glossy', 'Loop Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'Yellow', '80 Gsm', 'Glossy', 'Hard Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'Yellow', '80 Gsm', 'Glossy', 'Spiral Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'Yellow', '80 Gsm', 'Shiny', 'Loop Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'Yellow', '80 Gsm', 'Shiny', 'Hard Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'Yellow', '80 Gsm', 'Shiny', 'Spiral Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'White', '70 Gsm', 'Glossy', 'Loop Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'White', '70 Gsm', 'Glossy', 'Hard Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'White', '70 Gsm', 'Glossy', 'Spiral Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'White', '70 Gsm', 'Shiny', 'Loop Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'White', '70 Gsm', 'Shiny', 'Hard Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'White', '70 Gsm', 'Shiny', 'Spiral Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'White', '80 Gsm', 'Glossy', 'Loop Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'White', '80 Gsm', 'Glossy', 'Hard Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'White', '80 Gsm', 'Glossy', 'Spiral Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'White', '80 Gsm', 'Shiny', 'Loop Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'White', '80 Gsm', 'Shiny', 'Hard Binding'),
('diaries', 'Diaries', 'Premium', 'Custom Offset Diary', 'A5', 'White', '80 Gsm', 'Shiny', 'Spiral Binding'),
('t-shirts', 'T-Shirts', 'Standard', 'Polo Shirt (Polyester)', 'Small', NULL, NULL, 'Black', 'Half Sleeve'),
('t-shirts', 'T-Shirts', 'Standard', 'Polo Shirt (Polyester)', 'Small', NULL, NULL, 'White', 'Half Sleeve'),
('t-shirts', 'T-Shirts', 'Standard', 'Polo Shirt (Polyester)', 'Small', NULL, NULL, 'Blue', 'Half Sleeve'),
('t-shirts', 'T-Shirts', 'Standard', 'Polo Shirt (Polyester)', 'Small', NULL, NULL, 'Yellow + more', 'Half Sleeve'),
('t-shirts', 'T-Shirts', NULL, NULL, 'Medium', NULL, NULL, 'Black', 'Half Sleeve'),
('t-shirts', 'T-Shirts', NULL, NULL, 'Medium', NULL, NULL, 'White', 'Half Sleeve'),
('t-shirts', 'T-Shirts', NULL, NULL, 'Medium', NULL, NULL, 'Blue', 'Half Sleeve'),
('t-shirts', 'T-Shirts', NULL, NULL, 'Medium', NULL, NULL, 'Yellow + more', 'Half Sleeve'),
('t-shirts', 'T-Shirts', NULL, NULL, 'Large', NULL, NULL, 'Black', 'Half Sleeve'),
('t-shirts', 'T-Shirts', NULL, NULL, 'Large', NULL, NULL, 'White', 'Half Sleeve'),
('t-shirts', 'T-Shirts', NULL, NULL, 'Large', NULL, NULL, 'Blue', 'Half Sleeve'),
('t-shirts', 'T-Shirts', NULL, NULL, 'Large', NULL, NULL, 'Yellow + more', 'Half Sleeve'),
('t-shirts', 'T-Shirts', NULL, NULL, 'XL', NULL, NULL, 'Black', 'Half Sleeve'),
('t-shirts', 'T-Shirts', NULL, NULL, 'XL', NULL, NULL, 'White', 'Half Sleeve'),
('t-shirts', 'T-Shirts', NULL, NULL, 'XL', NULL, NULL, 'Blue', 'Half Sleeve'),
('t-shirts', 'T-Shirts', NULL, NULL, 'XL', NULL, NULL, 'Yellow + more', 'Half Sleeve'),
('t-shirts', 'T-Shirts', NULL, NULL, 'XXL', NULL, NULL, 'Black', 'Half Sleeve'),
('t-shirts', 'T-Shirts', NULL, NULL, 'XXL', NULL, NULL, 'White', 'Half Sleeve'),
('t-shirts', 'T-Shirts', NULL, NULL, 'XXL', NULL, NULL, 'Blue', 'Half Sleeve'),
('t-shirts', 'T-Shirts', NULL, NULL, 'XXL', NULL, NULL, 'Yellow + more', 'Half Sleeve'),
('t-shirts', 'T-Shirts', NULL, 'Cotton Shirt', 'Small', NULL, NULL, 'Black', 'Round Neck'),
('t-shirts', 'T-Shirts', NULL, 'Cotton Shirt', 'Small', NULL, NULL, 'Black', 'V Neck'),
('t-shirts', 'T-Shirts', NULL, 'Cotton Shirt', 'Small', NULL, NULL, 'White', 'Round Neck'),
('t-shirts', 'T-Shirts', NULL, 'Cotton Shirt', 'Small', NULL, NULL, 'White', 'V Neck'),
('t-shirts', 'T-Shirts', NULL, NULL, 'Medium', NULL, NULL, 'Black', 'Round Neck'),
('t-shirts', 'T-Shirts', NULL, NULL, 'Medium', NULL, NULL, 'Black', 'V Neck'),
('t-shirts', 'T-Shirts', NULL, NULL, 'Medium', NULL, NULL, 'White', 'Round Neck'),
('t-shirts', 'T-Shirts', NULL, NULL, 'Medium', NULL, NULL, 'White', 'V Neck'),
('t-shirts', 'T-Shirts', NULL, NULL, 'Large', NULL, NULL, 'Black', 'Round Neck'),
('t-shirts', 'T-Shirts', NULL, NULL, 'Large', NULL, NULL, 'Black', 'V Neck'),
('t-shirts', 'T-Shirts', NULL, NULL, 'Large', NULL, NULL, 'White', 'Round Neck'),
('t-shirts', 'T-Shirts', NULL, NULL, 'Large', NULL, NULL, 'White', 'V Neck'),
('t-shirts', 'T-Shirts', NULL, NULL, 'XL', NULL, NULL, 'Black', 'Round Neck'),
('t-shirts', 'T-Shirts', NULL, NULL, 'XL', NULL, NULL, 'Black', 'V Neck'),
('t-shirts', 'T-Shirts', NULL, NULL, 'XL', NULL, NULL, 'White', 'Round Neck'),
('t-shirts', 'T-Shirts', NULL, NULL, 'XL', NULL, NULL, 'White', 'V Neck'),
('t-shirts', 'T-Shirts', NULL, NULL, 'XXL', NULL, NULL, 'Black', 'Round Neck'),
('t-shirts', 'T-Shirts', NULL, NULL, 'XXL', NULL, NULL, 'Black', 'V Neck'),
('t-shirts', 'T-Shirts', NULL, NULL, 'XXL', NULL, NULL, 'White', 'Round Neck'),
('t-shirts', 'T-Shirts', NULL, NULL, 'XXL', NULL, NULL, 'White', 'V Neck'),
('mugs', 'Mugs', 'Standard', 'White Mug', '11 Oz', NULL, NULL, NULL, 'China'),
('mugs', 'Mugs', 'Standard', 'White Mug', '11 Oz', NULL, NULL, NULL, 'Local'),
('mugs', 'Mugs', NULL, 'Color Mug', '11 Oz', NULL, NULL, 'Black', 'China'),
('mugs', 'Mugs', NULL, 'Color Mug', '11 Oz', NULL, NULL, 'Black', 'Local'),
('mugs', 'Mugs', NULL, 'Color Mug', '11 Oz', NULL, NULL, 'Yellow', 'China'),
('mugs', 'Mugs', NULL, 'Color Mug', '11 Oz', NULL, NULL, 'Yellow', 'Local'),
('mugs', 'Mugs', NULL, 'Color Mug', '11 Oz', NULL, NULL, 'red', 'China'),
('mugs', 'Mugs', NULL, 'Color Mug', '11 Oz', NULL, NULL, 'red', 'Local'),
('mugs', 'Mugs', NULL, 'Color Mug', '11 Oz', NULL, NULL, 'orange', 'China'),
('mugs', 'Mugs', NULL, 'Color Mug', '11 Oz', NULL, NULL, 'orange', 'Local'),
('mugs', 'Mugs', 'Premium', 'Patch Mug', '11 Oz', NULL, NULL, NULL, NULL),
('mugs', 'Mugs', NULL, 'Matte Mug Laser engraved', '11 oz', NULL, NULL, 'Black', NULL),
('mugs', 'Mugs', NULL, 'Matte Mug Laser engraved', '11 oz', NULL, NULL, 'Blue', NULL),
('mugs', 'Mugs', NULL, 'Matte Mug Laser engraved', '11 oz', NULL, NULL, 'red', NULL)
;

SET @staging_rows = (SELECT COUNT(*) FROM stg_refactored_products);
SELECT CASE
  WHEN @staging_rows = 0 THEN 'ERROR: No rows loaded into stg_refactored_products.'
  ELSE CONCAT('OK: Loaded rows into staging = ', @staging_rows)
END AS load_status;

-- Trim and null-normalize empty strings
UPDATE stg_refactored_products
SET
  product_handle = LOWER(TRIM(product_handle)),
  product_title = TRIM(product_title),
  royalty_level = NULLIF(TRIM(royalty_level), ''),
  sub_product_type = NULLIF(TRIM(sub_product_type), ''),
  size = NULLIF(TRIM(size), ''),
  paper_type = NULLIF(TRIM(paper_type), ''),
  paper_grammage = NULLIF(TRIM(paper_grammage), ''),
  lamination_or_color = NULLIF(TRIM(lamination_or_color), ''),
  specialty = NULLIF(TRIM(specialty), '');

-- Clean known CSV inconsistencies
UPDATE stg_refactored_products
SET
  royalty_level = REPLACE(royalty_level, 'Mettalic', 'Metallic'),
  paper_type = REPLACE(paper_type, 'Matter Paper', 'Matte Paper'),
  specialty = REPLACE(specialty, 'Golden foil', 'Golden Foil'),
  specialty = REPLACE(specialty, 'GLossy', 'Glossy'),
  lamination_or_color = REPLACE(lamination_or_color, 'GLossy', 'Glossy'),
  lamination_or_color = REPLACE(lamination_or_color, 'MAtte', 'Matte');

-- Drop clearly invalid rows
DELETE FROM stg_refactored_products
WHERE product_handle = '' OR product_title = '';

-- ------------------------------------------------------------
-- 3) Ensure products table has fields this importer uses
-- ------------------------------------------------------------
-- Existing API uses these fields already. This only adds missing columns safely.
CREATE TABLE IF NOT EXISTS products (
  id INT NOT NULL AUTO_INCREMENT,
  tenant_id INT NOT NULL DEFAULT 1,
  title VARCHAR(255) NOT NULL,
  price DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  sale_price DECIMAL(12,2) NULL,
  category VARCHAR(150) NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'active',
  description TEXT NULL,
  image VARCHAR(255) NULL,
  image2 VARCHAR(255) NULL,
  image3 VARCHAR(255) NULL,
  image4 VARCHAR(255) NULL,
  weight VARCHAR(100) NULL,
  dimensions TEXT NULL,
  colors TEXT NULL,
  is_featured TINYINT(1) NOT NULL DEFAULT 0,
  featured_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_products_title (title),
  KEY idx_products_category (category),
  KEY idx_products_status (status),
  KEY idx_products_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE products
  ADD COLUMN IF NOT EXISTS sale_price DECIMAL(12,2) NULL AFTER price,
  ADD COLUMN IF NOT EXISTS category VARCHAR(150) NULL AFTER sale_price,
  ADD COLUMN IF NOT EXISTS status VARCHAR(30) NOT NULL DEFAULT 'active' AFTER category,
  ADD COLUMN IF NOT EXISTS description TEXT NULL AFTER status,
  ADD COLUMN IF NOT EXISTS image VARCHAR(255) NULL AFTER description,
  ADD COLUMN IF NOT EXISTS image2 VARCHAR(255) NULL AFTER image,
  ADD COLUMN IF NOT EXISTS image3 VARCHAR(255) NULL AFTER image2,
  ADD COLUMN IF NOT EXISTS image4 VARCHAR(255) NULL AFTER image3,
  ADD COLUMN IF NOT EXISTS weight VARCHAR(100) NULL AFTER image4,
  ADD COLUMN IF NOT EXISTS dimensions TEXT NULL AFTER weight,
  ADD COLUMN IF NOT EXISTS colors TEXT NULL AFTER dimensions,
  ADD COLUMN IF NOT EXISTS is_featured TINYINT(1) NOT NULL DEFAULT 0 AFTER colors,
  ADD COLUMN IF NOT EXISTS featured_order INT NOT NULL DEFAULT 0 AFTER is_featured,
  ADD COLUMN IF NOT EXISTS tenant_id INT NOT NULL DEFAULT 1 AFTER featured_order;

-- ------------------------------------------------------------
-- 4) Upsert parent products from distinct handle/title
-- ------------------------------------------------------------
-- Insert missing products (price defaults to 0 for quote-based catalog)
INSERT INTO products (
  title,
  price,
  sale_price,
  category,
  status,
  description,
  image,
  image2,
  image3,
  image4,
  weight,
  dimensions,
  colors,
  is_featured,
  featured_order,
  tenant_id
)
SELECT
  s.product_title AS title,
  0.00 AS price,
  NULL AS sale_price,
  s.product_handle AS category,
  'active' AS status,
  CONCAT(
    'Imported from refactored_products.csv. ',
    'Variants: ', COUNT(*),
    '. Includes multiple combinations for size, paper, grammage, finish, and specialty.'
  ) AS description,
  '' AS image,
  '' AS image2,
  '' AS image3,
  '' AS image4,
  '' AS weight,
  COALESCE(
    NULLIF(GROUP_CONCAT(DISTINCT s.size ORDER BY s.size SEPARATOR ', '), ''),
    ''
  ) AS dimensions,
  COALESCE(
    NULLIF(
      GROUP_CONCAT(
        DISTINCT COALESCE(s.lamination_or_color, s.specialty)
        ORDER BY COALESCE(s.lamination_or_color, s.specialty)
        SEPARATOR ', '
      ),
      ''
    ),
    ''
  ) AS colors,
  0 AS is_featured,
  0 AS featured_order,
  1 AS tenant_id
FROM stg_refactored_products s
LEFT JOIN products p
  ON p.title = s.product_title
 AND COALESCE(p.category, '') = s.product_handle
GROUP BY s.product_handle, s.product_title
HAVING SUM(CASE WHEN p.id IS NULL THEN 1 ELSE 0 END) > 0;

-- Refresh metadata for already-existing products from latest CSV aggregate
UPDATE products p
JOIN (
  SELECT
    s.product_handle,
    s.product_title,
    CONCAT(
      'Imported from refactored_products.csv. ',
      'Variants: ', COUNT(*),
      '. Includes multiple combinations for size, paper, grammage, finish, and specialty.'
    ) AS agg_description,
    COALESCE(
      NULLIF(GROUP_CONCAT(DISTINCT s.size ORDER BY s.size SEPARATOR ', '), ''),
      ''
    ) AS agg_dimensions,
    COALESCE(
      NULLIF(
        GROUP_CONCAT(
          DISTINCT COALESCE(s.lamination_or_color, s.specialty)
          ORDER BY COALESCE(s.lamination_or_color, s.specialty)
          SEPARATOR ', '
        ),
        ''
      ),
      ''
    ) AS agg_colors
  FROM stg_refactored_products s
  GROUP BY s.product_handle, s.product_title
) x
  ON p.title = x.product_title
 AND COALESCE(p.category, '') = x.product_handle
SET
  p.description = x.agg_description,
  p.dimensions = x.agg_dimensions,
  p.colors = x.agg_colors,
  p.status = COALESCE(NULLIF(p.status, ''), 'active'),
  p.tenant_id = COALESCE(p.tenant_id, 1);

-- ------------------------------------------------------------
-- 5) Variant table (keeps all row-level combinations)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS product_variants (
  id BIGINT NOT NULL AUTO_INCREMENT,
  product_id INT NOT NULL,
  royalty_level VARCHAR(150) NULL,
  sub_product_type VARCHAR(255) NULL,
  size VARCHAR(100) NULL,
  paper_type VARCHAR(150) NULL,
  paper_grammage VARCHAR(100) NULL,
  lamination_or_color VARCHAR(150) NULL,
  specialty VARCHAR(255) NULL,
  variant_label VARCHAR(500) NOT NULL,
  variant_signature VARCHAR(900) NOT NULL,
  base_price DECIMAL(12,2) NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'active',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uk_variant_signature (product_id, variant_signature),
  KEY idx_variants_product (product_id),
  CONSTRAINT fk_product_variants_product
    FOREIGN KEY (product_id) REFERENCES products(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Map each CSV family to one parent product row (latest id wins if duplicates exist)
DROP TEMPORARY TABLE IF EXISTS tmp_product_map;
CREATE TEMPORARY TABLE tmp_product_map AS
SELECT
  p.category AS product_handle,
  p.title AS product_title,
  MAX(p.id) AS product_id
FROM products p
JOIN stg_refactored_products s
  ON s.product_handle = COALESCE(p.category, '')
 AND s.product_title = p.title
GROUP BY p.category, p.title;

-- Insert/update all variants
INSERT INTO product_variants (
  product_id,
  royalty_level,
  sub_product_type,
  size,
  paper_type,
  paper_grammage,
  lamination_or_color,
  specialty,
  variant_label,
  variant_signature,
  base_price,
  status
)
SELECT
  m.product_id,
  s.royalty_level,
  s.sub_product_type,
  s.size,
  s.paper_type,
  s.paper_grammage,
  s.lamination_or_color,
  s.specialty,
  CONCAT_WS(
    ' | ',
    NULLIF(s.royalty_level, ''),
    NULLIF(s.sub_product_type, ''),
    NULLIF(s.size, ''),
    NULLIF(s.paper_type, ''),
    NULLIF(s.paper_grammage, ''),
    NULLIF(s.lamination_or_color, ''),
    NULLIF(s.specialty, '')
  ) AS variant_label,
  CONCAT_WS(
    '||',
    COALESCE(s.royalty_level, '-'),
    COALESCE(s.sub_product_type, '-'),
    COALESCE(s.size, '-'),
    COALESCE(s.paper_type, '-'),
    COALESCE(s.paper_grammage, '-'),
    COALESCE(s.lamination_or_color, '-'),
    COALESCE(s.specialty, '-')
  ) AS variant_signature,
  NULL AS base_price,
  'active' AS status
FROM stg_refactored_products s
JOIN tmp_product_map m
  ON m.product_handle = s.product_handle
 AND m.product_title = s.product_title
ON DUPLICATE KEY UPDATE
  royalty_level = VALUES(royalty_level),
  sub_product_type = VALUES(sub_product_type),
  size = VALUES(size),
  paper_type = VALUES(paper_type),
  paper_grammage = VALUES(paper_grammage),
  lamination_or_color = VALUES(lamination_or_color),
  specialty = VALUES(specialty),
  variant_label = VALUES(variant_label),
  status = VALUES(status),
  updated_at = CURRENT_TIMESTAMP;

-- ------------------------------------------------------------
-- 6) Verification output
-- ------------------------------------------------------------
SELECT 'staging_rows' AS metric, COUNT(*) AS value FROM stg_refactored_products
UNION ALL
SELECT 'products_families', COUNT(*) FROM (SELECT DISTINCT product_handle, product_title FROM stg_refactored_products) t
UNION ALL
SELECT 'products_in_catalog', COUNT(*) FROM products p WHERE EXISTS (
  SELECT 1 FROM stg_refactored_products s
  WHERE s.product_handle = COALESCE(p.category, '')
    AND s.product_title = p.title
)
UNION ALL
SELECT 'variants_loaded', COUNT(*) FROM product_variants v WHERE EXISTS (
  SELECT 1 FROM products p
  WHERE p.id = v.product_id
    AND EXISTS (
      SELECT 1 FROM stg_refactored_products s
      WHERE s.product_handle = COALESCE(p.category, '')
        AND s.product_title = p.title
    )
);

COMMIT;

-- Optional cleanup after validation:
-- DROP TABLE stg_refactored_products;

