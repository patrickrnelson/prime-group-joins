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

-- 9. How much was the total cost for each order?
SELECT "orders".id, SUM("products".unit_price * "line_items".quantity) as total_cost
FROM "orders"
JOIN "line_items" ON "orders".id = "line_items".order_id
JOIN "products" ON "products".id = "line_items".product_id
GROUP BY "orders".id
ORDER BY "orders".id;

-- 10. How much has each customer spent in total?
SELECT "customers".first_name, SUM("products".unit_price * "line_items".quantity) as total_cost
FROM "products"
JOIN "line_items" ON "products".id = "line_items".order_id
JOIN "orders" ON "orders".id = "line_items".product_id
JOIN "addresses" ON "addresses".id = "orders".address_id
JOIN "customers" ON "customers".id = "addresses".customer_id
GROUP BY "customers".id
ORDER BY "total_cost";

-- 11. How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 		0, not NULL (research coalesce).
-- I think I got close!?
SELECT "customers".first_name, SUM(COALESCE("products".unit_price, 0) * COALESCE("line_items".quantity, 0)) as total_cost
FROM "products"
JOIN "line_items" ON "products".id = "line_items".order_id
JOIN "orders" ON "orders".id = "line_items".product_id
JOIN "addresses" ON "addresses".id = "orders".address_id
JOIN "customers" ON "customers".id = "addresses".customer_id
GROUP BY "customers".id
ORDER BY "total_cost";