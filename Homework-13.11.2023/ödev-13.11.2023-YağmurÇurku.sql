-- 86. -- a.Bu ülkeler hangileri..?
SELECT DISTINCT(ship_country) AS "İhraç yapılan ülkeler" FROM orders 
ORDER BY ship_country;

-- 87. -- En Pahalı 5 ürün
SELECT product_name, unit_price FROM products 
ORDER BY unit_price DESC LIMIT 5;

-- 88. -- ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
SELECT COUNT(*) AS "Toplam sipariş" FROM customers c 
INNER JOIN orders o ON c.customer_id=o.customer_id
WHERE c.customer_id='ALFKI';

-- 89. -- Ürünlerimin toplam maliyeti
SELECT SUM(unit_price*(units_in_stock+units_on_order)) AS toplam_maliyet FROM products;

-- 90. -- Şirketim, şimdiye kadar ne kadar ciro yapmış..?
SELECT SUM(quantity*(unit_price-(unit_price*discount))) AS toplam_ciro FROM order_details;

-- 91. -- Ortalama Ürün Fiyatım
SELECT AVG(unit_price) FROM products;

-- 92. -- En Pahalı Ürünün Adı
SELECT product_name, unit_price FROM products 
ORDER BY unit_price DESC LIMIT 1;

-- 93. -- En az kazandıran sipariş
SELECT order_id, SUM(quantity*unit_price-(unit_price*discount)) FROM order_details 
GROUP BY order_id
ORDER BY SUM LIMIT 1;

-- 94. -- Müşterilerimin içinde en uzun isimli müşteri
SELECT company_name FROM customers
ORDER BY LENGTH(company_name) DESC LIMIT 1;

-- 95. -- Çalışanlarımın Ad, Soyad ve Yaşları
SELECT first_name, last_name, age(CURRENT_DATE,birth_date) FROM employees;

-- 96. -- Hangi üründen toplam kaç adet alınmış..?
SELECT p.product_name, SUM(od.quantity) FROM order_details od
INNER JOIN orders o ON od.order_id=o.order_id
INNER JOIN products p ON od.product_id=p.product_id
GROUP BY p.product_id
ORDER BY SUM DESC;

-- 97. -- Hangi siparişte toplam ne kadar kazanmışım..?
SELECT order_id ,SUM(quantity*(unit_price-(unit_price*discount))) FROM order_details
GROUP BY order_id
ORDER BY order_id;

-- 98. -- Hangi kategoride toplam kaç adet ürün bulunuyor..?
SELECT category_id, COUNT(product_id) FROM products
GROUP BY category_id
ORDER BY category_id;

-- 99. -- 1000 Adetten fazla satılan ürünler?
SELECT p.product_name, SUM(od.quantity) FROM order_details od
INNER JOIN products p ON od.product_id=p.product_id
GROUP BY p.product_name
HAVING SUM(od.quantity)>1000
ORDER BY SUM;

-- 100. -- Hangi Müşterilerim hiç sipariş vermemiş..?
 --LEFT JOIN ile çözüm:
SELECT c.company_name, o.order_id FROM customers c
LEFT JOIN orders o ON c.customer_id=o.customer_id
WHERE o.order_id IS NULL;
 -- NOT EXISTS ile çözüm:
SELECT * FROM customers
WHERE NOT EXISTS(SELECT * FROM orders
				WHERE customers.customer_id=orders.customer_id);

-- 101. -- Hangi tedarikçi hangi ürünü sağlıyor ?
SELECT s.company_name AS "Tedarikçi", p.product_name AS "Ürün" FROM suppliers s
INNER JOIN products p ON s.supplier_id=p.supplier_id;

-- 102. -- Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?
SELECT o.order_id, s.company_name, o.shipped_date FROM orders o
INNER JOIN shippers s ON o.ship_via=s.shipper_id;

-- 103. -- Hangi siparişi hangi müşteri verir..?
SELECT o.order_id, order_date, c.company_name FROM orders o 
INNER JOIN customers c ON o.customer_id=c.customer_id;

-- 104. -- Hangi çalışan, toplam kaç sipariş almış..?
SELECT e.first_name || ' ' || e.last_name AS calisan, COUNT(*) AS siparis_sayisi FROM orders o
INNER JOIN employees e ON o.employee_id=e.employee_id
GROUP BY e.employee_id
ORDER BY siparis_sayisi DESC;

-- 105. -- En fazla siparişi kim almış..?
SELECT e.first_name || ' ' || e.last_name AS calisan, COUNT(*) AS siparis_sayisi FROM orders o
INNER JOIN employees e ON o.employee_id=e.employee_id
GROUP BY e.employee_id
ORDER BY siparis_sayisi DESC LIMIT 1;

-- 106. -- Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?
SELECT o.order_id, e.first_name || ' ' || e.last_name AS calisan, c.company_name FROM orders o
INNER JOIN employees e ON o.employee_id=e.employee_id
INNER JOIN customers c ON o.customer_id=c.customer_id;

-- 107. -- Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?
SELECT p.product_name, c.category_name, s.company_name FROM products p
INNER JOIN categories c ON p.category_id=c.category_id
INNER JOIN suppliers s ON p.supplier_id=s.supplier_id;

-- 108. -- Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, hangi tarihte, hangi kargo şirketi tarafından gönderilmiş,
	--hangi üründen kaç adet alınmış, hangi fiyattan alınmış, ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış
SELECT o.order_id, c.company_name AS customer, e.first_name || ' ' || e.last_name as employee, 
o.shipped_date, sh.company_name AS shipping_company,p.product_name, od.quantity, od.unit_price, 
ct.category_name, s.company_name AS supplier_company FROM orders o
INNER JOIN customers c ON o.customer_id=c.customer_id
INNER JOIN employees e ON o.employee_id=e.employee_id
INNER JOIN order_details od ON od.order_id=o.order_id
INNER JOIN products p ON od.product_id=p.product_id
INNER JOIN suppliers s ON p.supplier_id=s.supplier_id
INNER JOIN categories ct ON ct.category_id=p.category_id
INNER JOIN shippers sh ON sh.shipper_id=o.ship_via;

-- 109. -- Altında ürün bulunmayan kategoriler
 --LEFT JOIN ile çözüm:
SELECT c.category_name, p.product_name FROM categories c
LEFT JOIN products p ON c.category_id=p.category_id
WHERE p.product_id IS NULL;
 -- NOT EXISTS ile çözüm:
SELECT * FROM categories
WHERE NOT EXISTS(SELECT * FROM products
				WHERE products.category_id=categories.category_id);

-- 110. -- Manager ünvanına sahip tüm müşterileri listeleyiniz.
SELECT contact_title FROM customers
WHERE LOWER(contact_title) LIKE '%manager%';

-- 111. -- FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.
SELECT * FROM customers
WHERE UPPER(company_name) LIKE 'FR%' AND LENGTH(company_name) BETWEEN 14 AND 19;  --5 karakterli müşteri olmadığı için
																				  --14 ve 19 karakter aralığı aldık.
-- 112. -- (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.
SELECT company_name, phone FROM customers
WHERE phone LIKE '(171)%';

-- 113. -- BirimdekiMiktar alanında boxes geçen tüm ürünleri listeleyiniz.
SELECT product_name, quantity_per_unit FROM products
WHERE quantity_per_unit LIKE '%boxes%';

-- 114. -- Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)
SELECT company_name, phone, contact_title, country FROM customers
WHERE LOWER(contact_title) LIKE '%manager%' AND country IN('France','Germany');

-- 115. -- En yüksek birim fiyata sahip 10 ürünü listeleyiniz.
SELECT * FROM products
ORDER BY unit_price DESC LIMIT 10;

-- 116. -- Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.
SELECT company_name, country, city FROM customers
ORDER BY country, city;

-- 117. -- Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.
SELECT first_name AS Ad, last_name AS Soyad, age(CURRENT_DATE,birth_date) AS Yaş FROM employees;

-- 118. -- 35 gün içinde sevk edilmeyen satışları listeleyiniz.
SELECT order_id, (required_date)-(shipped_date) AS "Sevk Süresi" FROM orders
WHERE (required_date)-(shipped_date)>35
ORDER BY "Sevk Süresi";

-- 119. -- Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)
SELECT c.category_name FROM products p
INNER JOIN categories c ON c.category_id=p.category_id
WHERE p.product_id = (SELECT product_id FROM products ORDER BY unit_price DESC LIMIT 1);

-- 120. -- Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)
SELECT product_name FROM products
WHERE EXISTS (SELECT * FROM categories
			 WHERE categories.category_id=products.category_id
			 AND category_name LIKE '%on%');

-- 121. -- Konbu adlı üründen kaç adet satılmıştır.
SELECT SUM(quantity) AS "Toplam Konbu Satışı" FROM products p
INNER JOIN order_details od ON p.product_id=od.product_id
WHERE LOWER(product_name)='konbu';

-- 122. -- Japonyadan kaç farklı ürün tedarik edilmektedir.
SELECT COUNT(*) FROM products p
INNER JOIN suppliers s ON s.supplier_id=p.supplier_id
WHERE country='Japan';

-- 123. -- 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?
SELECT MAX(freight) AS "En yüksek nakliye ücreti", MIN(freight) AS "En düşük nakliye ücreti", 
	AVG(freight) AS "Ortalama nakliye ücreti" FROM orders
WHERE DATE_PART('year',order_date)=1997;

-- 124. -- Faks numarası olan tüm müşterileri listeleyiniz.
SELECT customer_id, company_name, fax FROM customers
WHERE fax IS NOT NULL;

-- 125. -- 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 
SELECT order_id, customer_id, employee_id, shipped_date, ship_name FROM orders
WHERE shipped_date BETWEEN '1996-07-16' AND '1996-07-30';

