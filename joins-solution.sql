-- 1. Get all customers and their addresses.
Select * FROM "customers"
JOIN "addresses" ON "customers".id = "addresses".customer_id;

-- 2. Get all orders and their line items (orders, quantity and product).
SELECT * FROM "orders"
JOIN "line_items" ON "orders".id = "line_items".order_id
JOIN "products" ON "line_items".product_id = "products".id;

-- 3. Which warehouses have cheetos?
SELECT * FROM "products"
JOIN "warehouse_product" ON "products".id = "warehouse_product".product_id
JOIN "warehouse" ON "warehouse_product".warehouse_id = "warehouse".id
WHERE "products".description = 'cheetos';

	-- to narrow down the specific rows we want
SELECT "products".description as "product_name", "warehouse".warehouse
FROM "products"
JOIN "warehouse_product" ON "products".id = "warehouse_product".product_id
JOIN "warehouse" ON "warehouse_product".warehouse_id = "warehouse".id
WHERE "products".description = 'cheetos';


-- 4. Which warehouses have diet pepsi?
SELECT "products".description as "product_name", "warehouse".warehouse
FROM "products"
JOIN "warehouse_product" ON "products".id = "warehouse_product".product_id
JOIN "warehouse" ON "warehouse_product".warehouse_id = "warehouse".id
WHERE "products".description = 'diet pepsi';

-- 5. Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT "customers".first_name, "customers".last_name, count (*) as "order_count"
FROM "orders"
JOIN "addresses" ON "orders".address_id = "addresses".id
JOIN "customers" ON "addresses".customer_id = "customers".id
GROUP BY "customers".id;

-- 6. How many customers do we have?
SELECT count(*) as "customer_count"
FROM "customers";

-- 7. How many products do we carry?
SELECT count(*) as "product_count"
FROM "products";

-- 8. What is the total available on-hand quantity of diet pepsi?
SELECT "products".description as "product_description", SUM("warehouse_product".on_hand) as "total_on_hand"
FROM "products"
JOIN "warehouse_product" ON "products".id = "warehouse_product".product_id
WHERE "products".description = 'diet pepsi'
GROUP BY "products".description;
