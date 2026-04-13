-- ============================================
-- INVENTORY DATABASE (Schema + Large Dataset)
-- ============================================

DROP DATABASE IF EXISTS invetory;
CREATE DATABASE invetory;
USE invetory;

-- ----------------------------
-- TABLES
-- ----------------------------

CREATE TABLE categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(255)
);

CREATE TABLE suppliers (
  supplier_id INT AUTO_INCREMENT PRIMARY KEY,
  supplier_name VARCHAR(255),
  contact_person VARCHAR(255),
  phone_number VARCHAR(50)
);

CREATE TABLE customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_name VARCHAR(255),
  email VARCHAR(255) UNIQUE,
  phone VARCHAR(50)
);

CREATE TABLE products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  sku VARCHAR(100) UNIQUE,
  product_name VARCHAR(255),
  category_id INT,
  supplier_id INT,
  unit_price DECIMAL(10,2),
  current_stock INT,
  FOREIGN KEY (category_id) REFERENCES categories(category_id),
  FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE sales (
  sale_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  total_amount DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE sales_items (
  sale_item_id INT AUTO_INCREMENT PRIMARY KEY,
  sale_id INT,
  product_id INT,
  quantity INT,
  unit_price_at_sale DECIMAL(10,2),
  FOREIGN KEY (sale_id) REFERENCES sales(sale_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ----------------------------
-- SEED DATA (LARGE DATASET)
-- ----------------------------

-- Categories
INSERT INTO categories (category_name)
SELECT CONCAT('Category ', x)
FROM (SELECT @row:=@row+1 x FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) a,
      (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) b,
      (SELECT @row:=0) r) temp LIMIT 20;

-- Suppliers
INSERT INTO suppliers (supplier_name, contact_person, phone_number)
SELECT CONCAT('Supplier ', x),
       CONCAT('Person ', x),
       CONCAT('09', FLOOR(RAND()*1000000000))
FROM (SELECT @row:=@row+1 x FROM (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) a,
      (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) b,
      (SELECT @row:=0) r) temp LIMIT 50;

-- Customers (10k)
INSERT INTO customers (customer_name, email, phone)
SELECT CONCAT('Customer ', x),
       CONCAT('customer', x, '@mail.com'),
       CONCAT('09', FLOOR(RAND()*1000000000))
FROM (SELECT @row:=@row+1 x FROM 
      (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) a,
      (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) b,
      (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) c,
      (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) d,
      (SELECT @row:=0) r) temp LIMIT 10000;

-- Products (5k)
INSERT INTO products (sku, product_name, category_id, supplier_id, unit_price, current_stock)
SELECT CONCAT('SKU', x),
       CONCAT('Product ', x),
       FLOOR(1 + RAND()*20),
       FLOOR(1 + RAND()*50),
       ROUND(RAND()*1000, 2),
       FLOOR(RAND()*100)
FROM (SELECT @row:=@row+1 x FROM 
      (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) a,
      (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) b,
      (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) c,
      (SELECT @row:=0) r) temp LIMIT 5000;

-- Sales (20k)
INSERT INTO sales (customer_id, total_amount)
SELECT FLOOR(1 + RAND()*10000),
       ROUND(RAND()*5000, 2)
FROM (SELECT @row:=@row+1 x FROM 
      (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) a,
      (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) b,
      (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) c,
      (SELECT @row:=0) r) temp LIMIT 20000;

-- Sales Items (100k)
INSERT INTO sales_items (sale_id, product_id, quantity, unit_price_at_sale)
SELECT FLOOR(1 + RAND()*20000),
       FLOOR(1 + RAND()*5000),
       FLOOR(1 + RAND()*10),
       ROUND(RAND()*1000, 2)
FROM (SELECT @row:=@row+1 x FROM 
      (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) a,
      (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) b,
      (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) c,
      (SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) d,
      (SELECT @row:=0) r) temp LIMIT 100000;

-- Verify
SELECT COUNT(*) AS total_sales_items FROM sales_items;
