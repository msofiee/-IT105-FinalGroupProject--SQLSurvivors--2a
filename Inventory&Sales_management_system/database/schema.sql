Table Suppliers {
  supplier_id int [pk, increment]
  supplier_name varchar
  contact_person varchar
  phone_number varchar
}

Table Categories {
  category_id int [pk, increment]
  category_name varchar
}

Table Products {
  product_id int [pk, increment]
  sku varchar [unique]
  product_name varchar
  category_id int [ref: > Categories.category_id]
  supplier_id int [ref: > Suppliers.supplier_id]
  unit_price decimal
  current_stock int
}

Table Customers {
  customer_id int [pk, increment]
  customer_name varchar
  email varchar [unique]
  phone varchar
}

Table Sales {
  sale_id int [pk, increment]
  customer_id int [ref: > Customers.customer_id]
  sale_date timestamp
  total_amount decimal
}

Table Sales_Items {
  sale_item_id int [pk, increment]
  sale_id int [ref: > Sales.sale_id]
  product_id int [ref: > Products.product_id]
  quantity int
  unit_price_at_sale decimal
}
