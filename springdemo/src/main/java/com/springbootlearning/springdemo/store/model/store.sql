-- public.customer definition

-- Drop table

-- DROP TABLE public.customer;

CREATE TABLE public.customer (
	customer_id int4 NOT NULL,
	customer_name varchar NULL,
	CONSTRAINT customer_pk PRIMARY KEY (customer_id)
);


-- public.product definition

-- Drop table

-- DROP TABLE public.product;

CREATE TABLE public.product (
	product_id int4 NOT NULL,
	product_name varchar NULL,
	number_of_product float4 NULL,
	product_price float4 NULL,
	CONSTRAINT product_pk PRIMARY KEY (product_id)
);


-- public.product_transaction definition

-- Drop table

-- DROP TABLE public.product_transaction;

CREATE TABLE public.product_transaction (
	transaction_id int4 NOT NULL,
	transaction_date date NULL,
	customer_id int4 NULL,
	CONSTRAINT product_transaction_pk PRIMARY KEY (transaction_id),
	CONSTRAINT product_transaction_customer_fk FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id)
);


-- public.product_order definition

-- Drop table

-- DROP TABLE public.product_order;

CREATE TABLE public.product_order (
	order_id int8 NOT NULL,
	product_id int4 NULL,
	number_of_item int4 NULL,
	product_name varchar NULL,
	order_price float8 NULL,
	transaction_id int4 NULL,
	CONSTRAINT order_pk PRIMARY KEY (order_id),
	CONSTRAINT fk_product_order_product FOREIGN KEY (product_id) REFERENCES public.product(product_id),
	CONSTRAINT product_order_product_transaction_fk FOREIGN KEY (transaction_id) REFERENCES public.product_transaction(transaction_id)
);