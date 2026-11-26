CREATE DATABASE IF NOT EXISTS pharmacyDb
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE pharmacyDb;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Medicine;
CREATE TABLE Medicine (
    medicineId INT AUTO_INCREMENT PRIMARY KEY,
    medicineName VARCHAR(100) NOT NULL,
    genericName VARCHAR(100) NOT NULL,
    dosage VARCHAR(100) NOT NULL,
    unitPrice DECIMAL(10,2) NOT NULL,
    prescriptionRequired BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT chkMedPrice CHECK (unitPrice > 0)
);

--
-- Dumping data for table `Medicine`
--

INSERT INTO Medicine (medicineId, medicineName, genericName, dosage, unitPrice, prescriptionRequired) VALUES
    (1, 'Biogesic', 'Paracetamol', '500 mg', 4.5, 0),
    (2, 'Medicol Advance', 'Ibuprofen', '200 mg', 9.0, 0),
    (3, 'Alaxan FR', 'Ibuprofen + Paracetamol', '200 mg/325 mg', 10.5, 0),
    (4, 'Neozep Forte', 'Phenylephrine + Chlorphenamine + Paracetamol', '10 mg/2 mg/500 mg', 8.0, 0),
    (5, 'Solmux', 'Carbocisteine', '500 mg', 14.0, 0),
    (6, 'Imodium', 'Loperamide', '2 mg', 12.0, 0),
    (7, 'Allerta', 'Cetirizine', '10 mg', 11.0, 0),
    (8, 'Claritin', 'Loratadine', '10 mg', 28.0, 0),
    (9, 'Kremil-S', 'Aluminum Hydroxide + Magnesium Hydroxide + Simethicone', '178 mg/233 mg/30 mg', 9.5, 0),
    (10, 'Omepron', 'Omeprazole', '20 mg', 18.0, 1),
    (11, 'Amoxil', 'Amoxicillin', '500 mg', 14.0, 1),
    (12, 'Augmentin', 'Amoxicillin + Clavulanic Acid', '625 mg', 62.0, 1),
    (13, 'Zithromax', 'Azithromycin', '500 mg', 95.0, 1),
    (14, 'Keflex', 'Cefalexin', '500 mg', 22.0, 1),
    (15, 'Ciprobay', 'Ciprofloxacin', '500 mg', 30.0, 1),
    (16, 'Glucophage', 'Metformin', '500 mg', 6.5, 1),
    (17, 'Diamicron MR', 'Gliclazide', '60 mg', 24.0, 1),
    (18, 'Cozaar', 'Losartan', '50 mg', 16.0, 1),
    (19, 'Norvasc', 'Amlodipine', '5 mg', 13.0, 1),
    (20, 'Lipitor', 'Atorvastatin', '20 mg', 38.0, 1),
    (21, 'Zocor', 'Simvastatin', '20 mg', 20.0, 1),
    (22, 'Ventolin', 'Salbutamol', '2 mg', 5.0, 1),
    (23, 'Singulair', 'Montelukast', '10 mg', 42.0, 1),
    (24, 'Ponstan', 'Mefenamic Acid', '500 mg', 11.0, 0),
    (25, 'Cecon', 'Ascorbic Acid', '500 mg', 6.0, 0),
    (26, 'Neurobion', 'Vitamin B1 + B6 + B12', '100 mg/200 mg/200 mcg', 16.0, 0),
    (27, 'Enervon', 'Multivitamins + Minerals', '1 tablet', 7.5, 0),
    (28, 'Hydrite', 'Oral Rehydration Salts', '4.1 g sachet', 13.0, 0),
    (29, 'Ultram', 'Tramadol', '50 mg', 28.0, 1),
    (30, 'Deltasone', 'Prednisone', '20 mg', 8.0, 1);
    
--
-- Table structure for table `InventoryBatch`
--

DROP TABLE IF EXISTS InventoryBatch;
CREATE TABLE InventoryBatch (
    batchId INT AUTO_INCREMENT PRIMARY KEY,
    orderItemId INT NOT NULL,
    medicineId INT NOT NULL,
    batchNumber VARCHAR(30) NOT NULL,
    dateReceived DATE NOT NULL,
    quantityReceived INT NOT NULL,
    quantityRemaining INT NOT NULL,
    unitCost DECIMAL(10,2) NOT NULL,
    expirationDate DATE NOT NULL,
    CONSTRAINT chkBatchQtyReceived CHECK (quantityReceived > 0),
    CONSTRAINT chkBatchQtyRemaining CHECK (quantityRemaining >= 0 AND quantityRemaining <= quantityReceived),
    CONSTRAINT chkBatchCost CHECK (unitCost >= 0),
    CONSTRAINT chkBatchExpiry CHECK (expirationDate > dateReceived),
    CONSTRAINT uqBatchOrderItem UNIQUE (orderItemId),
    CONSTRAINT uqBatchNumber UNIQUE (batchNumber),
    CONSTRAINT uqBatchMedicine UNIQUE (batchId, medicineId),
    CONSTRAINT fkBatchOrderItem FOREIGN KEY (orderItemId, medicineId) REFERENCES PurchaseOrderItem(orderItemId, medicineId),
    CONSTRAINT fkBatchMedicine FOREIGN KEY (medicineId) REFERENCES Medicine(medicineId)
);

--
-- Dumping data for table `InventoryBatch`
--

INSERT INTO InventoryBatch (batchId, orderItemId, medicineId, batchNumber, dateReceived, quantityReceived, quantityRemaining, unitCost, expirationDate) VALUES
    (1, 1, 30, 'LOT-2025-0001', '2025-01-22', 250, 218, 5.5, '2026-02-20'),
    (2, 2, 3, 'LOT-2025-0002', '2025-01-22', 150, 107, 7.18, '2027-10-06'),
    (3, 3, 25, 'LOT-2025-0003', '2025-01-22', 300, 255, 4.48, '2025-12-22'),
    (4, 4, 24, 'LOT-2025-0004', '2025-01-22', 250, 70, 6.71, '2027-03-12'),
    (5, 5, 29, 'LOT-2025-0005', '2025-01-22', 48, 0, 16.05, '2027-08-24'),
    (6, 6, 9, 'LOT-2025-0006', '2025-01-22', 200, 60, 6.23, '2026-10-29'),
    (7, 7, 15, 'LOT-2025-0007', '2025-02-06', 250, 114, 18.33, '2027-05-26'),
    (8, 8, 10, 'LOT-2025-0008', '2025-02-06', 96, 0, 12.92, '2026-05-09'),
    (9, 9, 7, 'LOT-2025-0009', '2025-02-06', 120, 119, 7.19, '2027-05-23'),
    (10, 10, 5, 'LOT-2025-0010', '2025-02-06', 200, 73, 8.74, '2027-04-18'),
    (11, 11, 18, 'LOT-2025-0011', '2025-02-06', 96, 66, 11.39, '2027-04-18'),
    (12, 12, 11, 'LOT-2025-0012', '2025-02-06', 200, 126, 10.0, '2025-12-31'),
    (13, 13, 4, 'LOT-2025-0013', '2025-02-14', 250, 180, 4.79, '2026-08-19'),
    (14, 14, 28, 'LOT-2025-0014', '2025-02-14', 96, 0, 7.57, '2027-04-12'),
    (15, 15, 12, 'LOT-2025-0015', '2025-02-14', 250, 244, 35.46, '2027-06-27'),
    (16, 16, 16, 'LOT-2025-0016', '2025-02-14', 72, 0, 4.14, '2027-03-13'),
    (17, 17, 14, 'LOT-2025-0017', '2025-02-14', 300, 292, 16.72, '2026-01-18'),
    (18, 18, 6, 'LOT-2025-0018', '2025-02-14', 120, 0, 8.94, '2027-11-03'),
    (19, 19, 1, 'LOT-2025-0019', '2025-03-20', 250, 40, 2.64, '2027-04-07'),
    (20, 20, 26, 'LOT-2025-0020', '2025-03-20', 96, 11, 10.87, '2026-05-09'),
    (21, 21, 27, 'LOT-2025-0021', '2025-03-20', 200, 83, 4.26, '2026-05-13'),
    (22, 22, 23, 'LOT-2025-0022', '2025-03-20', 250, 249, 32.42, '2027-05-10'),
    (23, 23, 2, 'LOT-2025-0023', '2025-03-20', 72, 0, 5.41, '2027-01-28'),
    (24, 24, 20, 'LOT-2025-0024', '2025-03-20', 72, 59, 21.94, '2027-02-24'),
    (25, 25, 23, 'LOT-2025-0025', '2025-04-29', 96, 96, 29.29, '2027-08-28'),
    (26, 26, 12, 'LOT-2025-0026', '2025-04-29', 250, 162, 47.34, '2026-11-04'),
    (27, 27, 30, 'LOT-2025-0027', '2025-06-03', 250, 139, 5.59, '2027-10-08'),
    (28, 28, 22, 'LOT-2025-0028', '2025-06-03', 150, 0, 2.77, '2028-02-15'),
    (29, 29, 3, 'LOT-2025-0029', '2025-06-03', 120, 39, 6.57, '2026-06-29'),
    (30, 30, 18, 'LOT-2025-0030', '2025-07-05', 120, 120, 11.85, '2027-03-06'),
    (31, 31, 14, 'LOT-2025-0031', '2025-07-05', 250, 211, 17.08, '2026-06-16'),
    (32, 34, 4, 'LOT-2025-0032', '2025-08-09', 150, 92, 4.41, '2026-06-09'),
    (33, 35, 2, 'LOT-2025-0033', '2025-08-09', 150, 136, 5.93, '2027-03-24'),
    (34, 36, 7, 'LOT-2025-0034', '2025-08-09', 120, 120, 6.06, '2027-05-10'),
    (35, 37, 12, 'LOT-2025-0035', '2025-09-28', 300, 290, 39.61, '2027-02-10'),
    (36, 38, 28, 'LOT-2025-0036', '2025-09-28', 48, 22, 9.49, '2027-09-02'),
    (37, 39, 21, 'LOT-2025-0037', '2025-09-28', 300, 294, 12.34, '2027-07-28'),
    (38, 40, 1, 'LOT-2025-0038', '2025-09-28', 300, 300, 3.46, '2028-04-13'),
    (39, 41, 18, 'LOT-2025-0039', '2025-11-04', 120, 55, 12.34, '2026-11-05'),
    (40, 42, 25, 'LOT-2025-0040', '2025-11-04', 250, 163, 4.14, '2027-02-04'),
    (41, 43, 27, 'LOT-2025-0041', '2025-11-04', 300, 71, 4.71, '2027-12-31'),
    (42, 44, 7, 'LOT-2025-0042', '2025-12-07', 150, 28, 7.75, '2027-02-04'),
    (43, 45, 23, 'LOT-2025-0043', '2025-12-07', 200, 93, 29.53, '2027-04-06'),
    (44, 46, 21, 'LOT-2025-0044', '2025-12-07', 200, 102, 14.66, '2026-10-12'),
    (45, 47, 4, 'LOT-2025-0045', '2025-12-07', 300, 266, 4.93, '2026-12-29'),
    (46, 48, 20, 'LOT-2026-0046', '2026-02-01', 300, 147, 21.86, '2026-12-21'),
    (47, 49, 17, 'LOT-2026-0047', '2026-02-01', 72, 68, 13.26, '2027-10-04'),
    (48, 50, 9, 'LOT-2026-0048', '2026-02-01', 250, 247, 6.78, '2028-02-28'),
    (49, 53, 17, 'LOT-2026-0049', '2026-03-03', 72, 0, 18.58, '2027-07-11'),
    (50, 54, 21, 'LOT-2026-0050', '2026-03-03', 300, 265, 13.98, '2027-02-04'),
    (51, 55, 9, 'LOT-2026-0051', '2026-03-03', 48, 48, 5.47, '2028-06-15'),
    (52, 56, 1, 'LOT-2026-0052', '2026-03-03', 72, 72, 2.73, '2028-09-16'),
    (53, 57, 29, 'LOT-2026-0053', '2026-04-03', 150, 148, 18.29, '2027-09-23'),
    (54, 58, 19, 'LOT-2026-0054', '2026-04-03', 96, 40, 8.02, '2027-06-28'),
    (55, 59, 16, 'LOT-2026-0055', '2026-04-03', 120, 9, 3.61, '2027-07-25'),
    (56, 60, 1, 'LOT-2026-0056', '2026-05-15', 120, 120, 2.49, '2028-11-22'),
    (57, 61, 17, 'LOT-2026-0057', '2026-05-15', 96, 90, 13.94, '2027-07-24'),
    (58, 62, 29, 'LOT-2026-0058', '2026-05-15', 250, 210, 20.03, '2027-07-03'),
    (59, 63, 23, 'LOT-2026-0059', '2026-06-30', 300, 300, 23.55, '2027-07-03'),
    (60, 64, 21, 'LOT-2026-0060', '2026-06-30', 120, 120, 11.57, '2027-11-21'),
    (61, 65, 1, 'LOT-2026-0061', '2026-06-30', 300, 300, 2.8, '2027-10-13'),
    (62, 66, 7, 'LOT-2026-0062', '2026-08-07', 120, 120, 6.19, '2028-07-11'),
    (63, 67, 16, 'LOT-2026-0063', '2026-08-07', 200, 200, 3.58, '2027-12-05'),
    (64, 68, 15, 'LOT-2026-0064', '2026-08-07', 200, 200, 20.23, '2028-02-21'),
    (65, 69, 21, 'LOT-2026-0065', '2026-08-07', 150, 150, 11.65, '2028-03-09'),
    (66, 74, 20, 'LOT-2026-0066', '2026-09-18', 72, 72, 23.33, '2028-11-20'),
    (67, 75, 22, 'LOT-2026-0067', '2026-09-18', 96, 33, 3.86, '2028-02-22'),
    (68, 76, 6, 'LOT-2026-0068', '2026-09-18', 72, 70, 7.97, '2027-09-04'),
    (69, 77, 29, 'LOT-2026-0069', '2026-10-22', 72, 72, 16.26, '2027-10-27'),
    (70, 78, 3, 'LOT-2026-0070', '2026-10-22', 300, 300, 8.19, '2028-11-10');

--
-- Table structure for table `Supplier`
--

DROP TABLE IF EXISTS Supplier;
CREATE TABLE Supplier (
    supplierId INT AUTO_INCREMENT PRIMARY KEY,
    supplierName VARCHAR(100) NOT NULL,
    contactPerson VARCHAR(100) NOT NULL,
    contactNumber VARCHAR(20) NOT NULL,
    streetAddress VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL
);

--
-- Dumping data for table `Supplier`
--

INSERT INTO Supplier (supplierId, supplierName, contactPerson, contactNumber, streetAddress, city) VALUES
    (1, 'MetroMed Distributors Inc.', 'Ramon Dela Cruz', '0917-555-0101', '214 Kalayaan Ave', 'Quezon City'),
    (2, 'Pacific Pharma Supply', 'Maricel Santos', '0918-555-0102', '58 Ayala Ave', 'Makati'),
    (3, 'Luzon Health Wholesale', 'Jerome Aquino', '0919-555-0103', '17 Rizal Ave', 'Manila'),
    (4, 'Unity Drug Trading', 'Carla Mendoza', '0920-555-0104', '902 Ortigas Ave', 'Pasig'),
    (5, 'Bayanihan Medical Goods', 'Paolo Reyes', '0927-555-0105', '33 Shaw Blvd', 'Mandaluyong'),
    (6, 'Fortuna Pharma Corp.', 'Liza Navarro', '0928-555-0106', '12 5th Ave', 'Taguig'),
    (7, 'Visayas Medi-Source', 'Dennis Ocampo', '0932-555-0107', '77 Osmena Blvd', 'Cebu City'),
    (8, 'Mindanao Care Distributors', 'Ana Villanueva', '0935-555-0108', '41 J.P. Laurel Ave', 'Davao City'),
    (9, 'Calamba Pharma Hub', 'Rico Bautista', '0945-555-0109', '8 National Hwy', 'Calamba'),
    (10, 'Southern Rx Traders', 'Joy Castillo', '0956-555-0110', '25 Aguinaldo Hwy', 'Imus');
    
--
-- Table structure for table `SalesTransaction`
--

DROP TABLE IF EXISTS SalesTransaction;
CREATE TABLE SalesTransaction (
    transactionId INT AUTO_INCREMENT PRIMARY KEY,
    transactionDatetime DATETIME NOT NULL,
    paymentMethod ENUM('Cash', 'GCash', 'Maya', 'Credit Card', 'Debit Card') NOT NULL
);

--
-- Dumping data for table `SalesTransaction`
--

INSERT INTO SalesTransaction (transactionId, transactionDatetime, paymentMethod) VALUES
    (1, '2025-02-17 20:45:00', 'GCash'),
    (2, '2025-02-19 09:19:00', 'GCash'),
    (3, '2025-02-21 08:59:00', 'Cash'),
    (4, '2025-03-16 20:04:00', 'GCash'),
    (5, '2025-04-14 10:52:00', 'Cash'),
    (6, '2025-04-18 17:14:00', 'GCash'),
    (7, '2025-04-24 19:55:00', 'GCash'),
    (8, '2025-05-01 16:15:00', 'Debit Card'),
    (9, '2025-05-04 15:55:00', 'GCash'),
    (10, '2025-05-14 16:35:00', 'Cash'),
    (11, '2025-05-15 15:12:00', 'Cash'),
    (12, '2025-05-18 16:01:00', 'GCash'),
    (13, '2025-06-19 08:05:00', 'GCash'),
    (14, '2025-06-20 20:54:00', 'Maya'),
    (15, '2025-06-28 15:08:00', 'GCash'),
    (16, '2025-07-05 16:15:00', 'Credit Card'),
    (17, '2025-07-10 17:50:00', 'Maya'),
    (18, '2025-07-11 12:30:00', 'Cash'),
    (19, '2025-07-11 17:09:00', 'Cash'),
    (20, '2025-07-21 09:03:00', 'Cash'),
    (21, '2025-07-21 16:13:00', 'Maya'),
    (22, '2025-07-28 13:47:00', 'Credit Card'),
    (23, '2025-08-06 13:51:00', 'Cash'),
    (24, '2025-08-13 12:41:00', 'Cash'),
    (25, '2025-08-13 15:23:00', 'Cash'),
    (26, '2025-08-21 15:21:00', 'Debit Card'),
    (27, '2025-08-29 20:59:00', 'Cash'),
    (28, '2025-09-08 19:52:00', 'GCash'),
    (29, '2025-10-03 12:42:00', 'Cash'),
    (30, '2025-10-09 10:40:00', 'GCash'),
    (31, '2025-10-29 16:11:00', 'GCash'),
    (32, '2025-11-12 17:35:00', 'Cash'),
    (33, '2025-11-17 15:18:00', 'GCash'),
    (34, '2025-11-27 08:42:00', 'Cash'),
    (35, '2025-12-08 14:56:00', 'GCash'),
    (36, '2025-12-10 20:05:00', 'GCash'),
    (37, '2025-12-12 15:59:00', 'GCash'),
    (38, '2025-12-27 12:10:00', 'Cash'),
    (39, '2025-12-28 20:15:00', 'Cash'),
    (40, '2025-12-31 20:53:00', 'GCash'),
    (41, '2026-01-02 13:33:00', 'Cash'),
    (42, '2026-01-04 09:44:00', 'Cash'),
    (43, '2026-01-09 13:38:00', 'Cash'),
    (44, '2026-01-23 15:20:00', 'GCash'),
    (45, '2026-01-23 18:04:00', 'GCash'),
    (46, '2026-01-23 19:51:00', 'Cash'),
    (47, '2026-01-28 17:43:00', 'Cash'),
    (48, '2026-01-29 10:07:00', 'GCash'),
    (49, '2026-01-31 09:47:00', 'GCash'),
    (50, '2026-02-05 20:34:00', 'GCash'),
    (51, '2026-02-10 12:07:00', 'GCash'),
    (52, '2026-02-12 13:54:00', 'Cash'),
    (53, '2026-02-17 19:43:00', 'Debit Card'),
    (54, '2026-02-22 09:15:00', 'Cash'),
    (55, '2026-02-26 13:47:00', 'Debit Card'),
    (56, '2026-03-01 19:35:00', 'GCash'),
    (57, '2026-03-12 09:36:00', 'GCash'),
    (58, '2026-03-13 11:59:00', 'Cash'),
    (59, '2026-03-14 11:34:00', 'Credit Card'),
    (60, '2026-03-16 12:00:00', 'Cash'),
    (61, '2026-03-25 14:15:00', 'Maya'),
    (62, '2026-03-29 10:23:00', 'Cash'),
    (63, '2026-03-30 15:33:00', 'Debit Card'),
    (64, '2026-03-30 19:10:00', 'GCash'),
    (65, '2026-04-04 19:42:00', 'Cash'),
    (66, '2026-04-09 15:42:00', 'GCash'),
    (67, '2026-04-13 17:10:00', 'GCash'),
    (68, '2026-04-14 10:17:00', 'Cash'),
    (69, '2026-04-18 08:32:00', 'Credit Card'),
    (70, '2026-04-18 20:09:00', 'Cash'),
    (71, '2026-04-22 19:10:00', 'GCash'),
    (72, '2026-05-02 12:40:00', 'Maya'),
    (73, '2026-05-02 19:49:00', 'Maya'),
    (74, '2026-05-03 09:50:00', 'Credit Card'),
    (75, '2026-05-06 10:05:00', 'Cash'),
    (76, '2026-05-08 12:00:00', 'Debit Card'),
    (77, '2026-05-08 12:57:00', 'GCash'),
    (78, '2026-05-09 09:32:00', 'Maya'),
    (79, '2026-05-17 11:34:00', 'Cash'),
    (80, '2026-05-19 11:10:00', 'Debit Card'),
    (81, '2026-05-29 20:47:00', 'Maya'),
    (82, '2026-05-30 16:58:00', 'Debit Card'),
    (83, '2026-05-30 18:33:00', 'Cash'),
    (84, '2026-05-31 18:43:00', 'GCash'),
    (85, '2026-06-01 20:35:00', 'Cash'),
    (86, '2026-06-09 20:45:00', 'Credit Card'),
    (87, '2026-06-17 12:12:00', 'Maya'),
    (88, '2026-06-20 08:23:00', 'Cash'),
    (89, '2026-06-26 17:04:00', 'Credit Card'),
    (90, '2026-07-01 11:37:00', 'Maya'),
    (91, '2026-07-01 13:57:00', 'Cash'),
    (92, '2026-07-05 17:50:00', 'Cash'),
    (93, '2026-07-08 09:01:00', 'GCash'),
    (94, '2026-07-09 16:32:00', 'Cash'),
    (95, '2026-07-19 08:08:00', 'GCash'),
    (96, '2026-07-19 16:22:00', 'GCash'),
    (97, '2026-07-21 12:25:00', 'Credit Card'),
    (98, '2026-07-26 09:39:00', 'GCash'),
    (99, '2026-08-11 18:21:00', 'GCash'),
    (100, '2026-08-20 15:06:00', 'Cash'),
    (101, '2026-08-22 18:56:00', 'Cash'),
    (102, '2026-08-24 15:02:00', 'GCash'),
    (103, '2026-08-26 13:39:00', 'Maya'),
    (104, '2026-08-29 19:54:00', 'Cash'),
    (105, '2026-08-30 17:56:00', 'Maya'),
    (106, '2026-08-31 15:46:00', 'GCash'),
    (107, '2026-08-31 19:05:00', 'Cash'),
    (108, '2026-09-03 10:25:00', 'Credit Card'),
    (109, '2026-09-06 08:20:00', 'Credit Card'),
    (110, '2026-09-12 12:14:00', 'Maya'),
    (111, '2026-09-14 10:47:00', 'Cash'),
    (112, '2026-09-18 13:27:00', 'GCash'),
    (113, '2026-09-19 16:59:00', 'Cash'),
    (114, '2026-09-22 14:09:00', 'Cash'),
    (115, '2026-09-26 10:09:00', 'Cash'),
    (116, '2026-09-28 18:39:00', 'GCash'),
    (117, '2026-10-03 18:31:00', 'GCash'),
    (118, '2026-10-25 10:34:00', 'Cash'),
    (119, '2026-10-28 11:57:00', 'Cash'),
    (120, '2026-10-30 20:08:00', 'Maya'),
    (121, '2026-11-02 09:19:00', 'Credit Card'),
    (122, '2026-11-04 18:18:00', 'Cash'),
    (123, '2026-11-06 10:07:00', 'Cash'),
    (124, '2026-11-16 17:13:00', 'GCash'),
    (125, '2026-11-21 15:19:00', 'Credit Card');
    
--
-- Table structure for table `SalesTransactionItem`
--

DROP TABLE IF EXISTS SalesTransactionItem;
CREATE TABLE SalesTransactionItem (
    transactionItemId INT AUTO_INCREMENT PRIMARY KEY,
    transactionId INT NOT NULL,
    medicineId INT NOT NULL,
    batchId INT NOT NULL,
    quantitySold INT NOT NULL,
    unitPrice DECIMAL(10,2) NOT NULL,
    CONSTRAINT chkStiQty   CHECK (quantitySold > 0),
    CONSTRAINT chkStiPrice CHECK (unitPrice > 0),
    CONSTRAINT uqStiTxnBatch UNIQUE (transactionId, batchId),
    CONSTRAINT fkStiTransaction FOREIGN KEY (transactionId) REFERENCES SalesTransaction(transactionId) ON DELETE CASCADE,
    CONSTRAINT fkStiBatch FOREIGN KEY (batchId, medicineId) REFERENCES InventoryBatch(batchId, medicineId),
    CONSTRAINT fkStiMedicine FOREIGN KEY (medicineId) REFERENCES Medicine(medicineId)
);

--
-- Dumping data for table `SalesTransactionItem`
--

INSERT INTO SalesTransactionItem (transactionItemId, transactionId, medicineId, batchId, quantitySold, unitPrice) VALUES
    (1, 1, 10, 8, 8, 18.0),
    (2, 1, 16, 16, 30, 6.5),
    (3, 1, 24, 4, 10, 11.0),
    (4, 2, 6, 18, 15, 12.0),
    (5, 2, 25, 3, 12, 6.0),
    (6, 2, 10, 8, 30, 18.0),
    (7, 2, 12, 15, 6, 62.0),
    (8, 3, 28, 14, 2, 13.0),
    (9, 3, 10, 8, 1, 18.0),
    (10, 3, 29, 5, 15, 28.0),
    (11, 4, 29, 5, 3, 28.0),
    (12, 5, 29, 5, 3, 28.0),
    (13, 6, 28, 14, 30, 13.0),
    (14, 6, 25, 3, 12, 6.0),
    (15, 7, 27, 21, 10, 7.5),
    (16, 7, 6, 18, 24, 12.0),
    (17, 7, 2, 23, 15, 9.0),
    (18, 8, 24, 4, 5, 11.0),
    (19, 8, 6, 18, 8, 12.0),
    (20, 8, 18, 11, 30, 16.0),
    (21, 9, 1, 19, 30, 4.5),
    (22, 9, 3, 2, 24, 10.5),
    (23, 9, 28, 14, 4, 13.0),
    (24, 9, 9, 6, 15, 9.5),
    (25, 10, 4, 13, 10, 8.0),
    (26, 11, 12, 26, 15, 62.0),
    (27, 11, 30, 1, 30, 8.0),
    (28, 11, 10, 8, 30, 18.0),
    (29, 11, 20, 24, 4, 38.0),
    (30, 12, 11, 12, 5, 14.0),
    (31, 12, 24, 4, 12, 11.0),
    (32, 13, 26, 20, 24, 16.0),
    (33, 13, 24, 4, 1, 11.0),
    (34, 14, 5, 10, 5, 14.0),
    (35, 14, 26, 20, 2, 16.0),
    (36, 15, 26, 20, 2, 16.0),
    (37, 15, 9, 6, 30, 9.5),
    (38, 15, 24, 4, 24, 11.0),
    (39, 15, 14, 17, 8, 22.0),
    (40, 16, 22, 28, 3, 5.0),
    (41, 16, 30, 1, 2, 8.0),
    (42, 17, 10, 8, 4, 18.0),
    (43, 17, 20, 24, 6, 38.0),
    (44, 17, 9, 6, 5, 9.5),
    (45, 17, 2, 23, 15, 9.0),
    (46, 18, 2, 23, 4, 9.0),
    (47, 18, 1, 19, 24, 4.5),
    (48, 18, 7, 9, 1, 11.0),
    (49, 18, 5, 10, 24, 14.0),
    (50, 19, 4, 13, 30, 8.0),
    (51, 19, 22, 28, 30, 5.0),
    (52, 19, 3, 29, 10, 10.5),
    (53, 20, 10, 8, 4, 18.0),
    (54, 20, 11, 12, 8, 14.0),
    (55, 21, 29, 5, 15, 28.0),
    (56, 21, 9, 6, 2, 9.5),
    (57, 21, 3, 29, 4, 10.5),
    (58, 21, 28, 14, 20, 13.0),
    (59, 22, 11, 12, 4, 14.0),
    (60, 22, 10, 8, 12, 18.0),
    (61, 22, 2, 23, 1, 9.0),
    (62, 22, 3, 29, 3, 10.5),
    (63, 23, 25, 3, 15, 6.0),
    (64, 24, 11, 12, 15, 14.0),
    (65, 25, 24, 4, 24, 11.0),
    (66, 26, 1, 19, 15, 4.5),
    (67, 26, 6, 18, 24, 12.0),
    (68, 26, 22, 28, 2, 5.0),
    (69, 27, 28, 14, 4, 13.0),
    (70, 27, 24, 4, 8, 11.0),
    (71, 27, 27, 21, 24, 7.5),
    (72, 27, 1, 19, 24, 4.5),
    (73, 28, 23, 22, 1, 42.0),
    (74, 29, 10, 8, 1, 18.0),
    (75, 29, 29, 5, 12, 28.0),
    (76, 30, 10, 8, 6, 18.0),
    (77, 30, 6, 18, 3, 12.0),
    (78, 31, 5, 10, 6, 14.0),
    (79, 32, 21, 37, 6, 20.0),
    (80, 32, 2, 23, 6, 9.0),
    (81, 32, 25, 3, 6, 6.0),
    (82, 33, 22, 28, 30, 5.0),
    (83, 33, 16, 16, 10, 6.5),
    (84, 33, 11, 12, 24, 14.0),
    (85, 34, 4, 32, 10, 8.0),
    (86, 34, 22, 28, 12, 5.0),
    (87, 34, 15, 7, 20, 30.0),
    (88, 34, 18, 39, 15, 16.0),
    (89, 35, 21, 44, 10, 20.0),
    (90, 35, 3, 29, 20, 10.5),
    (91, 35, 16, 16, 12, 6.5),
    (92, 36, 11, 12, 2, 14.0),
    (93, 36, 22, 28, 12, 5.0),
    (94, 37, 3, 29, 4, 10.5),
    (95, 37, 15, 7, 5, 30.0),
    (96, 37, 11, 12, 6, 14.0),
    (97, 37, 6, 18, 8, 12.0),
    (98, 38, 11, 12, 10, 14.0),
    (99, 39, 16, 16, 5, 6.5),
    (100, 40, 26, 20, 8, 16.0),
    (101, 41, 20, 24, 3, 38.0),
    (102, 42, 15, 7, 12, 30.0),
    (103, 43, 5, 10, 10, 14.0),
    (104, 44, 15, 7, 12, 30.0),
    (105, 44, 26, 20, 8, 16.0),
    (106, 44, 9, 6, 20, 9.5),
    (107, 45, 2, 23, 3, 9.0),
    (108, 45, 6, 18, 1, 12.0),
    (109, 45, 16, 16, 15, 6.5),
    (110, 45, 27, 21, 3, 7.5),
    (111, 46, 21, 44, 3, 20.0),
    (112, 46, 27, 21, 12, 7.5),
    (113, 46, 5, 10, 24, 14.0),
    (114, 46, 23, 43, 8, 42.0),
    (115, 47, 28, 14, 24, 13.0),
    (116, 47, 18, 39, 20, 16.0),
    (117, 47, 9, 6, 5, 9.5),
    (118, 47, 25, 40, 6, 6.0),
    (119, 48, 24, 4, 2, 11.0),
    (120, 48, 1, 19, 15, 4.5),
    (121, 48, 22, 28, 1, 5.0),
    (122, 49, 21, 44, 6, 20.0),
    (123, 49, 23, 43, 24, 42.0),
    (124, 50, 21, 44, 8, 20.0),
    (125, 50, 20, 46, 30, 38.0),
    (126, 51, 6, 18, 20, 12.0),
    (127, 51, 9, 6, 10, 9.5),
    (128, 51, 14, 31, 3, 22.0),
    (129, 51, 27, 21, 10, 7.5),
    (130, 52, 2, 23, 5, 9.0),
    (131, 52, 15, 7, 6, 30.0),
    (132, 52, 20, 46, 6, 38.0),
    (133, 53, 24, 4, 24, 11.0),
    (134, 54, 26, 20, 12, 16.0),
    (135, 55, 24, 4, 15, 11.0),
    (136, 55, 17, 47, 4, 24.0),
    (137, 55, 22, 28, 1, 5.0),
    (138, 55, 3, 29, 30, 10.5),
    (139, 56, 21, 44, 20, 20.0),
    (140, 56, 14, 31, 8, 22.0),
    (141, 56, 6, 18, 17, 12.0),
    (142, 56, 25, 40, 15, 6.0),
    (143, 57, 20, 46, 30, 38.0),
    (144, 57, 12, 26, 15, 62.0),
    (145, 58, 30, 27, 1, 8.0),
    (146, 59, 15, 7, 3, 30.0),
    (147, 59, 7, 42, 1, 11.0),
    (148, 60, 1, 19, 20, 4.5),
    (149, 60, 2, 23, 20, 9.0),
    (150, 60, 12, 26, 2, 62.0),
    (151, 61, 26, 20, 20, 16.0),
    (152, 62, 7, 42, 20, 11.0),
    (153, 63, 17, 49, 20, 24.0),
    (154, 63, 27, 21, 3, 7.5),
    (155, 63, 12, 26, 8, 62.0),
    (156, 63, 14, 31, 8, 22.0),
    (157, 64, 14, 31, 15, 22.0),
    (158, 64, 4, 32, 24, 8.0),
    (159, 65, 24, 4, 5, 11.0),
    (160, 65, 19, 54, 6, 13.0),
    (161, 66, 22, 28, 10, 5.0),
    (162, 66, 27, 21, 5, 7.5),
    (163, 67, 17, 49, 3, 24.0),
    (164, 67, 30, 27, 4, 8.0),
    (165, 67, 23, 43, 8, 42.0),
    (166, 67, 27, 21, 6, 7.5),
    (167, 68, 26, 20, 5, 16.0),
    (168, 68, 30, 27, 4, 8.0),
    (169, 68, 27, 21, 10, 7.5),
    (170, 68, 20, 46, 6, 38.0),
    (171, 69, 24, 4, 24, 11.0),
    (172, 69, 19, 54, 15, 13.0),
    (173, 69, 16, 55, 8, 6.5),
    (174, 70, 27, 21, 4, 7.5),
    (175, 70, 20, 46, 20, 38.0),
    (176, 71, 15, 7, 5, 30.0),
    (177, 72, 27, 21, 30, 7.5),
    (178, 72, 22, 28, 24, 5.0),
    (179, 72, 7, 42, 10, 11.0),
    (180, 72, 21, 44, 5, 20.0),
    (181, 73, 5, 10, 10, 14.0),
    (182, 73, 22, 28, 3, 5.0),
    (183, 73, 17, 49, 5, 24.0),
    (184, 74, 26, 20, 4, 16.0),
    (185, 75, 4, 32, 12, 8.0),
    (186, 76, 29, 53, 2, 28.0),
    (187, 76, 16, 55, 5, 6.5),
    (188, 76, 4, 32, 12, 8.0),
    (189, 76, 1, 19, 12, 4.5),
    (190, 77, 25, 40, 10, 6.0),
    (191, 78, 28, 14, 12, 13.0),
    (192, 78, 28, 36, 3, 13.0),
    (193, 78, 9, 6, 6, 9.5),
    (194, 78, 24, 4, 8, 11.0),
    (195, 78, 20, 46, 1, 38.0),
    (196, 79, 3, 29, 10, 10.5),
    (197, 79, 21, 44, 8, 20.0),
    (198, 79, 30, 27, 8, 8.0),
    (199, 79, 7, 42, 12, 11.0),
    (200, 80, 21, 44, 6, 20.0),
    (201, 80, 17, 49, 3, 24.0),
    (202, 81, 19, 54, 4, 13.0),
    (203, 82, 12, 26, 6, 62.0),
    (204, 83, 25, 40, 4, 6.0),
    (205, 83, 23, 43, 15, 42.0),
    (206, 84, 21, 44, 2, 20.0),
    (207, 84, 17, 49, 15, 24.0),
    (208, 85, 19, 54, 1, 13.0),
    (209, 85, 22, 28, 8, 5.0),
    (210, 85, 23, 43, 30, 42.0),
    (211, 86, 27, 41, 10, 7.5),
    (212, 86, 14, 31, 5, 22.0),
    (213, 86, 4, 13, 30, 8.0),
    (214, 87, 22, 28, 5, 5.0),
    (215, 87, 16, 55, 15, 6.5),
    (216, 87, 5, 10, 2, 14.0),
    (217, 88, 16, 55, 12, 6.5),
    (218, 88, 15, 7, 12, 30.0),
    (219, 88, 25, 40, 2, 6.0),
    (220, 88, 28, 36, 20, 13.0),
    (221, 89, 12, 26, 2, 62.0),
    (222, 89, 27, 41, 10, 7.5),
    (223, 90, 27, 41, 30, 7.5),
    (224, 90, 12, 26, 15, 62.0),
    (225, 91, 5, 10, 6, 14.0),
    (226, 91, 27, 41, 30, 7.5),
    (227, 91, 21, 44, 8, 20.0),
    (228, 91, 2, 23, 3, 9.0),
    (229, 91, 2, 33, 5, 9.0),
    (230, 92, 9, 6, 4, 9.5),
    (231, 92, 25, 40, 20, 6.0),
    (232, 92, 15, 7, 4, 30.0),
    (233, 93, 9, 6, 10, 9.5),
    (234, 93, 30, 27, 15, 8.0),
    (235, 94, 30, 27, 24, 8.0),
    (236, 94, 20, 46, 30, 38.0),
    (237, 94, 16, 55, 20, 6.5),
    (238, 94, 15, 7, 1, 30.0),
    (239, 95, 7, 42, 5, 11.0),
    (240, 95, 27, 41, 24, 7.5),
    (241, 96, 21, 44, 1, 20.0),
    (242, 96, 16, 55, 15, 6.5),
    (243, 96, 3, 2, 2, 10.5),
    (244, 97, 1, 19, 20, 4.5),
    (245, 97, 22, 28, 9, 5.0),
    (246, 97, 9, 6, 24, 9.5),
    (247, 98, 5, 10, 8, 14.0),
    (248, 98, 30, 27, 1, 8.0),
    (249, 98, 17, 49, 1, 24.0),
    (250, 99, 12, 26, 1, 62.0),
    (251, 99, 29, 58, 10, 28.0),
    (252, 99, 7, 42, 30, 11.0),
    (253, 99, 27, 41, 20, 7.5),
    (254, 100, 2, 33, 3, 9.0),
    (255, 100, 1, 19, 24, 4.5),
    (256, 101, 5, 10, 12, 14.0),
    (257, 102, 17, 49, 6, 24.0),
    (258, 102, 21, 44, 15, 20.0),
    (259, 103, 9, 6, 6, 9.5),
    (260, 103, 16, 55, 30, 6.5),
    (261, 103, 20, 46, 12, 38.0),
    (262, 104, 20, 46, 10, 38.0),
    (263, 104, 9, 6, 3, 9.5),
    (264, 104, 30, 27, 20, 8.0),
    (265, 105, 12, 26, 24, 62.0),
    (266, 105, 27, 41, 2, 7.5),
    (267, 105, 3, 2, 3, 10.5),
    (268, 105, 18, 39, 2, 16.0),
    (269, 106, 30, 27, 10, 8.0),
    (270, 106, 24, 4, 1, 11.0),
    (271, 107, 30, 27, 24, 8.0),
    (272, 107, 19, 54, 30, 13.0),
    (273, 107, 2, 33, 5, 9.0),
    (274, 107, 1, 19, 2, 4.5),
    (275, 108, 24, 4, 8, 11.0),
    (276, 108, 5, 10, 20, 14.0),
    (277, 108, 21, 44, 6, 20.0),
    (278, 108, 23, 43, 12, 42.0),
    (279, 109, 28, 36, 3, 13.0),
    (280, 109, 7, 42, 24, 11.0),
    (281, 110, 15, 7, 20, 30.0),
    (282, 110, 24, 4, 6, 11.0),
    (283, 111, 17, 49, 4, 24.0),
    (284, 112, 3, 2, 4, 10.5),
    (285, 112, 18, 39, 8, 16.0),
    (286, 112, 6, 68, 2, 12.0),
    (287, 113, 29, 58, 30, 28.0),
    (288, 113, 27, 41, 20, 7.5),
    (289, 113, 15, 7, 6, 30.0),
    (290, 113, 2, 33, 1, 9.0),
    (291, 114, 22, 67, 15, 5.0),
    (292, 115, 27, 41, 30, 7.5),
    (293, 115, 22, 67, 12, 5.0),
    (294, 116, 27, 41, 3, 7.5),
    (295, 116, 22, 67, 20, 5.0),
    (296, 117, 15, 7, 30, 30.0),
    (297, 118, 17, 49, 15, 24.0),
    (298, 118, 17, 57, 5, 24.0),
    (299, 119, 22, 67, 12, 5.0),
    (300, 119, 24, 4, 3, 11.0),
    (301, 119, 27, 41, 20, 7.5),
    (302, 119, 25, 40, 30, 6.0),
    (303, 120, 21, 50, 3, 20.0),
    (304, 120, 20, 46, 8, 38.0),
    (305, 120, 23, 43, 10, 42.0),
    (306, 121, 4, 45, 4, 8.0),
    (307, 121, 27, 41, 30, 7.5),
    (308, 121, 21, 50, 24, 20.0),
    (309, 121, 7, 42, 20, 11.0),
    (310, 122, 12, 35, 10, 62.0),
    (311, 122, 18, 39, 20, 16.0),
    (312, 122, 21, 50, 8, 20.0),
    (313, 123, 4, 45, 30, 8.0),
    (314, 123, 17, 57, 1, 24.0),
    (315, 124, 3, 2, 10, 10.5),
    (316, 124, 9, 48, 3, 9.5),
    (317, 125, 22, 67, 4, 5.0),
    (318, 125, 1, 19, 24, 4.5),
    (319, 125, 16, 55, 6, 6.5);
    
--
-- Table structure for table `PurchaseOrder`
--

DROP TABLE IF EXISTS PurchaseOrder;
CREATE TABLE PurchaseOrder (
    orderId INT AUTO_INCREMENT PRIMARY KEY,
    supplierId INT NOT NULL,
    orderDate DATE NOT NULL,
    expectedDeliveryDate DATE NOT NULL,
    dateReceived DATE NULL,
    status ENUM('Pending', 'Received', 'Cancelled') NOT NULL DEFAULT 'Pending',
    CONSTRAINT chkExpectedAfterOrder CHECK (expectedDeliveryDate >= orderDate),
    CONSTRAINT chkReceivedAfterOrder CHECK (dateReceived IS NULL OR dateReceived >= orderDate),
    CONSTRAINT chkStatusReceived CHECK (
        (status = 'Received' AND dateReceived IS NOT NULL)
        OR (status <> 'Received' AND dateReceived IS NULL)
    ),
    CONSTRAINT fkPoSupplier FOREIGN KEY (supplierId) REFERENCES Supplier(supplierId)
);

--
-- Dumping data for table `PurchaseOrder`
--

INSERT INTO PurchaseOrder (orderId, supplierId, orderDate, expectedDeliveryDate, dateReceived, status) VALUES
    (1, 3, '2025-01-08', '2025-01-19', '2025-01-22', 'Received'),
    (2, 3, '2025-01-22', '2025-02-04', '2025-02-06', 'Received'),
    (3, 6, '2025-02-05', '2025-02-16', '2025-02-14', 'Received'),
    (4, 8, '2025-03-12', '2025-03-20', '2025-03-20', 'Received'),
    (5, 4, '2025-04-16', '2025-04-24', '2025-04-29', 'Received'),
    (6, 1, '2025-05-21', '2025-05-29', '2025-06-03', 'Received'),
    (7, 4, '2025-06-25', '2025-07-07', '2025-07-05', 'Received'),
    (8, 10, '2025-07-14', '2025-07-28', NULL, 'Cancelled'),
    (9, 5, '2025-08-06', '2025-08-11', '2025-08-09', 'Received'),
    (10, 4, '2025-09-10', '2025-09-23', '2025-09-28', 'Received'),
    (11, 1, '2025-10-22', '2025-11-03', '2025-11-04', 'Received'),
    (12, 4, '2025-12-03', '2025-12-09', '2025-12-07', 'Received'),
    (13, 6, '2026-01-14', '2026-01-28', '2026-02-01', 'Received'),
    (14, 4, '2026-02-02', '2026-02-15', NULL, 'Cancelled'),
    (15, 9, '2026-02-18', '2026-02-26', '2026-03-03', 'Received'),
    (16, 1, '2026-03-25', '2026-04-02', '2026-04-03', 'Received'),
    (17, 7, '2026-05-06', '2026-05-12', '2026-05-15', 'Received'),
    (18, 10, '2026-06-17', '2026-06-26', '2026-06-30', 'Received'),
    (19, 10, '2026-07-29', '2026-08-07', '2026-08-07', 'Received'),
    (20, 3, '2026-08-19', '2026-08-27', NULL, 'Cancelled'),
    (21, 4, '2026-09-02', '2026-09-15', '2026-09-18', 'Received'),
    (22, 8, '2026-10-07', '2026-10-18', '2026-10-22', 'Received'),
    (23, 8, '2026-10-28', '2026-11-07', NULL, 'Pending'),
    (24, 8, '2026-11-10', '2026-11-24', NULL, 'Pending'),
    (25, 1, '2026-11-18', '2026-12-02', NULL, 'Pending');

--
-- Table structure for table `PurchaseOrderItem`
--

DROP TABLE IF EXISTS PurchaseOrderItem;
CREATE TABLE PurchaseOrderItem (
    orderItemId INT AUTO_INCREMENT PRIMARY KEY,
    orderId INT NOT NULL,
    medicineId INT NOT NULL,
    quantityOrdered INT NOT NULL,
    unitCost DECIMAL(10,2) NOT NULL,
    totalCost DECIMAL(12,2) GENERATED ALWAYS AS (quantityOrdered * unitCost) STORED,
    CONSTRAINT chkQtyPositive CHECK (quantityOrdered > 0),
    CONSTRAINT chkCostNonneg  CHECK (unitCost >= 0),
    CONSTRAINT uqOrderMedicine UNIQUE (orderId, medicineId),
    CONSTRAINT uqPoiItemMedicine UNIQUE (orderItemId, medicineId),
    CONSTRAINT fkPoiOrder FOREIGN KEY (orderId) REFERENCES PurchaseOrder(orderId) ON DELETE CASCADE,
    CONSTRAINT fkPoiMedicine FOREIGN KEY (medicineId) REFERENCES Medicine(medicineId)
);

--
-- Dumping data for table `PurchaseOrderItem`
--

INSERT INTO PurchaseOrderItem (orderItemId, orderId, medicineId, quantityOrdered, unitCost) VALUES
    (1, 1, 30, 250, 5.5),
    (2, 1, 3, 150, 7.18),
    (3, 1, 25, 300, 4.48),
    (4, 1, 24, 250, 6.71),
    (5, 1, 29, 48, 16.05),
    (6, 1, 9, 200, 6.23),
    (7, 2, 15, 250, 18.33),
    (8, 2, 10, 96, 12.92),
    (9, 2, 7, 120, 7.19),
    (10, 2, 5, 200, 8.74),
    (11, 2, 18, 96, 11.39),
    (12, 2, 11, 200, 10.0),
    (13, 3, 4, 250, 4.79),
    (14, 3, 28, 96, 7.57),
    (15, 3, 12, 250, 35.46),
    (16, 3, 16, 72, 4.14),
    (17, 3, 14, 300, 16.72),
    (18, 3, 6, 120, 8.94),
    (19, 4, 1, 250, 2.64),
    (20, 4, 26, 96, 10.87),
    (21, 4, 27, 200, 4.26),
    (22, 4, 23, 250, 32.42),
    (23, 4, 2, 72, 5.41),
    (24, 4, 20, 72, 21.94),
    (25, 5, 23, 96, 29.29),
    (26, 5, 12, 250, 47.34),
    (27, 6, 30, 250, 5.59),
    (28, 6, 22, 150, 2.77),
    (29, 6, 3, 120, 6.57),
    (30, 7, 18, 120, 11.85),
    (31, 7, 14, 250, 17.08),
    (32, 8, 13, 96, 72.44),
    (33, 8, 19, 48, 7.23),
    (34, 9, 4, 150, 4.41),
    (35, 9, 2, 150, 5.93),
    (36, 9, 7, 120, 6.06),
    (37, 10, 12, 300, 39.61),
    (38, 10, 28, 48, 9.49),
    (39, 10, 21, 300, 12.34),
    (40, 10, 1, 300, 3.46),
    (41, 11, 18, 120, 12.34),
    (42, 11, 25, 250, 4.14),
    (43, 11, 27, 300, 4.71),
    (44, 12, 7, 150, 7.75),
    (45, 12, 23, 200, 29.53),
    (46, 12, 21, 200, 14.66),
    (47, 12, 4, 300, 4.93),
    (48, 13, 20, 300, 21.86),
    (49, 13, 17, 72, 13.26),
    (50, 13, 9, 250, 6.78),
    (51, 14, 18, 72, 10.98),
    (52, 14, 19, 250, 9.61),
    (53, 15, 17, 72, 18.58),
    (54, 15, 21, 300, 13.98),
    (55, 15, 9, 48, 5.47),
    (56, 15, 1, 72, 2.73),
    (57, 16, 29, 150, 18.29),
    (58, 16, 19, 96, 8.02),
    (59, 16, 16, 120, 3.61),
    (60, 17, 1, 120, 2.49),
    (61, 17, 17, 96, 13.94),
    (62, 17, 29, 250, 20.03),
    (63, 18, 23, 300, 23.55),
    (64, 18, 21, 120, 11.57),
    (65, 18, 1, 300, 2.8),
    (66, 19, 7, 120, 6.19),
    (67, 19, 16, 200, 3.58),
    (68, 19, 15, 200, 20.23),
    (69, 19, 21, 150, 11.65),
    (70, 20, 5, 250, 9.19),
    (71, 20, 24, 150, 7.33),
    (72, 20, 29, 300, 21.17),
    (73, 20, 8, 150, 15.42),
    (74, 21, 20, 72, 23.33),
    (75, 21, 22, 96, 3.86),
    (76, 21, 6, 72, 7.97),
    (77, 22, 29, 72, 16.26),
    (78, 22, 3, 300, 8.19),
    (79, 23, 12, 96, 47.59),
    (80, 23, 22, 120, 3.54),
    (81, 23, 14, 96, 16.92),
    (82, 23, 3, 250, 7.0),
    (83, 24, 3, 150, 6.31),
    (84, 24, 14, 150, 14.87),
    (85, 24, 10, 72, 13.87),
    (86, 25, 15, 48, 16.57),
    (87, 25, 19, 72, 9.48);

SET FOREIGN_KEY_CHECKS = 1;

-- Run this AFTER pharmacyDb.sql. It adds the views, triggers, and procedure the app uses.
-- Safe to re-run: it drops and recreates its own objects (your tables and data are not touched).
USE pharmacyDb;

DROP VIEW IF EXISTS vwLowStock;
DROP VIEW IF EXISTS vwMedicineStock;
DROP VIEW IF EXISTS vwExpiringBatches;
DROP VIEW IF EXISTS vwSaleTotals;
DROP TRIGGER IF EXISTS trgSaleItemBeforeInsert;
DROP TRIGGER IF EXISTS trgSaleItemAfterInsert;
DROP PROCEDURE IF EXISTS recordSale;

-- Stock per medicine, counting only batches that haven't expired
CREATE VIEW vwMedicineStock AS
SELECT m.medicineId, m.medicineName, m.genericName, m.dosage, m.unitPrice, m.prescriptionRequired,
       COALESCE(SUM(CASE WHEN b.expirationDate > CURDATE() THEN b.quantityRemaining END), 0) AS stock
FROM Medicine m
LEFT JOIN InventoryBatch b ON b.medicineId = m.medicineId
GROUP BY m.medicineId, m.medicineName, m.genericName, m.dosage, m.unitPrice, m.prescriptionRequired;

-- Low stock = 50 units or fewer. (A reorderLevel column on Medicine would be a better design.)
CREATE VIEW vwLowStock AS
SELECT medicineId, medicineName, stock
FROM vwMedicineStock
WHERE stock <= 50;

-- Batches that still have stock but are expired or expire within 90 days
CREATE VIEW vwExpiringBatches AS
SELECT b.batchId, m.medicineName, b.batchNumber, b.expirationDate, b.quantityRemaining,
       CASE WHEN b.expirationDate <= CURDATE() THEN 'Expired' ELSE 'Expiring soon' END AS status
FROM InventoryBatch b
JOIN Medicine m ON m.medicineId = b.medicineId
WHERE b.quantityRemaining > 0
  AND b.expirationDate <= DATE_ADD(CURDATE(), INTERVAL 90 DAY);

-- One row per sale, with item count and total
CREATE VIEW vwSaleTotals AS
SELECT t.transactionId, t.transactionDatetime, t.paymentMethod,
       COUNT(i.transactionItemId) AS itemCount,
       COALESCE(SUM(i.quantitySold * i.unitPrice), 0) AS total
FROM SalesTransaction t
LEFT JOIN SalesTransactionItem i ON i.transactionId = t.transactionId
GROUP BY t.transactionId, t.transactionDatetime, t.paymentMethod;

DELIMITER //

-- Trigger: refuse to sell from an expired batch or one without enough stock
CREATE TRIGGER trgSaleItemBeforeInsert BEFORE INSERT ON SalesTransactionItem
FOR EACH ROW
BEGIN
  DECLARE vExpiry DATE;
  DECLARE vRemaining INT;
  SELECT expirationDate, quantityRemaining INTO vExpiry, vRemaining
    FROM InventoryBatch WHERE batchId = NEW.batchId;
  IF vExpiry <= CURDATE() THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot sell an expired batch.';
  ELSEIF vRemaining < NEW.quantitySold THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not enough stock left in that batch.';
  END IF;
END //

-- Trigger: deduct the sold quantity from the batch
CREATE TRIGGER trgSaleItemAfterInsert AFTER INSERT ON SalesTransactionItem
FOR EACH ROW
BEGIN
  UPDATE InventoryBatch
     SET quantityRemaining = quantityRemaining - NEW.quantitySold
   WHERE batchId = NEW.batchId;
END //

-- Procedure: record a one-item sale from the earliest-expiring valid batch (FEFO)
CREATE PROCEDURE recordSale(
  IN pMedicineId INT, IN pQuantity INT, IN pPaymentMethod VARCHAR(20), OUT pTransactionId INT)
BEGIN
  DECLARE vBatchId INT;
  DECLARE vPrice DECIMAL(10,2);
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  IF pQuantity < 1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Quantity must be at least 1.';
  END IF;

  SELECT unitPrice INTO vPrice FROM Medicine WHERE medicineId = pMedicineId;

  SELECT batchId INTO vBatchId FROM InventoryBatch
   WHERE medicineId = pMedicineId
     AND quantityRemaining >= pQuantity
     AND expirationDate > CURDATE()
   ORDER BY expirationDate
   LIMIT 1;

  IF vBatchId IS NULL THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'No unexpired batch has enough stock for that quantity.';
  END IF;

  START TRANSACTION;
  INSERT INTO SalesTransaction (transactionDatetime, paymentMethod)
  VALUES (NOW(), pPaymentMethod);
  SET pTransactionId = LAST_INSERT_ID();
  INSERT INTO SalesTransactionItem (transactionId, medicineId, batchId, quantitySold, unitPrice)
  VALUES (pTransactionId, pMedicineId, vBatchId, pQuantity, vPrice);
  COMMIT;
END //

DELIMITER ;