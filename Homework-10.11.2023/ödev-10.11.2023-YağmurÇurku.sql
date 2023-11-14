-- 26. -- Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
SELECT p.product_id, p.product_name, p.units_in_stock, s.company_name, s.phone FROM products p 
INNER JOIN suppliers s ON p.supplier_id=s.supplier_id
WHERE units_in_stock=0;

-- 27. -- 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
SELECT o.order_date, o.ship_address, e.first_name || ' ' || e.last_name AS "Employee fullname" FROM orders o 
INNER JOIN employees e ON o.employee_id=e.employee_id
WHERE DATE_PART('year', order_date)=1998 AND DATE_PART('month', order_date)=03;

-- 28. -- 1997 yılı şubat ayında kaç siparişim var?
SELECT COUNT(*) AS "Şubat ayı sipariş sayısı" FROM orders
WHERE DATE_PART('year', order_date)=1997 AND DATE_PART('month', order_date)=02;

-- 29 -- London şehrinden 1998 yılında kaç siparişim var?
SELECT COUNT(*) AS "1998 yılı London toplam sipariş" FROM orders
WHERE LOWER(ship_city) IN ('london') AND DATE_PART('year', order_date)=1998;

-- 30. -- 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
SELECT o.order_date, c.contact_name, c.phone FROM orders o 
INNER JOIN customers c ON o.customer_id=c.customer_id
WHERE DATE_PART('year', order_date)=1997;

-- 31. -- Taşıma ücreti 40 üzeri olan siparişlerim
SELECT * FROM orders
WHERE freight >= 40
ORDER BY freight ASC;

-- 32. -- Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
SELECT o.ship_country, c.company_name, freight FROM orders o
INNER JOIN customers c ON o.customer_id=c.customer_id
WHERE freight >= 40
ORDER BY freight ASC;

-- 33. -- 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
SELECT o.order_date, o.ship_city, UPPER(e.first_name) || ' ' || UPPER(e.last_name) AS "Employee fullname" 
FROM orders o INNER JOIN employees e ON o.employee_id=e.employee_id
WHERE DATE_PART('year', order_date)=1997;

-- 34. -- 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
SELECT o.order_date, c.contact_name, REPLACE(REPLACE(REPLACE(REPLACE(
	REPLACE(c.phone, ' ', ''), '(', ''), ')', ''), '-', ''), '.', '') FROM orders o 
INNER JOIN customers c ON o.customer_id=c.customer_id
WHERE DATE_PART('year', order_date)=1997
ORDER BY order_date;

-- 35. -- Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
SELECT o.order_date, c.contact_name, e.first_name || ' ' || e.last_name AS "Employee fullname" 
FROM orders o INNER JOIN customers c ON o.customer_id=c.customer_id
INNER JOIN employees e ON o.employee_id=e.employee_id;

-- 36. -- Geciken siparişlerim?
SELECT p.product_name, o.order_date - o.required_date AS "Sipariş gecikme süresi"
FROM orders o INNER JOIN order_details od ON o.order_id=od.order_id
INNER JOIN products p ON od.product_id=p.product_id 
WHERE required_date < shipped_date;

-- 37. -- Geciken siparişlerimin tarihi, müşterisinin adı
SELECT p.product_name, c.company_name, o.order_date, o.required_date, o.order_date - o.required_date AS "Sipariş gecikme süresi"
FROM orders o INNER JOIN order_details od ON o.order_id=od.order_id
INNER JOIN products p ON od.product_id=p.product_id
INNER JOIN customers c ON c.customer_id=o.customer_id
WHERE required_date < shipped_date;

-- 38. -- 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
SELECT o.order_id, p.product_name, c.category_name, od.quantity FROM orders o 
INNER JOIN order_details od ON o.order_id=od.order_id
INNER JOIN products p ON od.product_id=p.product_id
INNER JOIN categories c ON p.category_id=c.category_id
WHERE o.order_id=10248;

-- 39. -- 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
SELECT o.order_id, p.product_name, s.company_name AS supplier_name FROM orders o 
INNER JOIN order_details od ON o.order_id=od.order_id
INNER JOIN products p ON od.product_id=p.product_id
INNER JOIN suppliers s ON s.supplier_id=p.supplier_id
WHERE o.order_id=10248;

-- 40. -- 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT e.first_name || ' ' || e.last_name AS "Employee fullname", 
o.order_date, p.product_name, od.quantity FROM orders o
INNER JOIN employees e ON o.employee_id=e.employee_id
INNER JOIN order_details od ON o.order_id=od.order_id
INNER JOIN products p ON od.product_id=p.product_id
WHERE e.employee_id=3 AND DATE_PART('year', order_date)=1997;

-- 41. -- 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
SELECT o.order_id, e.employee_id, e.first_name || ' ' || e.last_name AS "Employee fullname", 
SUM(od.quantity) AS toplam_satis, o.order_date FROM orders o 
INNER JOIN order_details od ON o.order_id=od.order_id
INNER JOIN employees e ON o.employee_id=e.employee_id
WHERE DATE_PART('year', order_date)=1997
GROUP BY o.order_id, e.employee_id
ORDER BY toplam_satis DESC
LIMIT 1;

-- 42. -- 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS "Employee fullname", 
SUM(od.quantity) AS toplam_satis FROM orders o 
INNER JOIN order_details od ON o.order_id=od.order_id
INNER JOIN employees e ON o.employee_id=e.employee_id
WHERE DATE_PART('year', order_date)=1997
GROUP BY e.employee_id
ORDER BY toplam_satis DESC
LIMIT 1;

-- 43. -- En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
SELECT p.product_name, p.unit_price, c.category_name FROM products p 
INNER JOIN categories c ON p.category_id=c.category_id
ORDER BY p.unit_price DESC
LIMIT 1;

-- 44. -- Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
SELECT e.first_name || ' ' || e.last_name AS "Employee fullname", o.order_date, o.order_id 
FROM orders o INNER JOIN employees e ON o.employee_id=e.employee_id
ORDER BY o.order_date DESC;

-- 45. -- SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT o.order_id, o.order_date, AVG(od.unit_price*od.quantity) AS ortalama_fiyat FROM orders o
INNER JOIN order_details od ON o.order_id=od.order_id
GROUP BY o.order_id
ORDER BY order_id DESC LIMIT 5;

-- 46. -- Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT p.product_name, c.category_name, SUM(od.quantity) FROM orders o
INNER JOIN order_details od ON o.order_id=od.order_id
INNER JOIN products p ON od.product_id=p.product_id
INNER JOIN categories c ON p.category_id=c.category_id
WHERE DATE_PART('month', order_date)=01
GROUP BY p.product_name, c.category_name;

-- 47. -- Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT o.order_id, o.order_date, SUM(od.quantity) FROM orders o
INNER JOIN order_details od ON o.order_id=od.order_id
GROUP BY o.order_id, od.order_id
HAVING SUM(od.quantity)>(SELECT AVG(quantity) FROM order_details)
ORDER BY SUM DESC;

-- 48. -- En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
SELECT SUM(od.quantity) AS toplam_satis, p.product_name, c. category_name, s.company_name FROM orders o
INNER JOIN order_details od ON o.order_id=od.order_id
INNER JOIN products p ON od.product_id=p.product_id
INNER JOIN categories c ON p.category_id=c.category_id
INNER JOIN suppliers s ON p.supplier_id=s.supplier_id
GROUP BY od.product_id, p.product_name, c. category_name, s.company_name
ORDER BY toplam_satis DESC LIMIT 1;

-- 49. -- Kaç ülkeden müşterim var
SELECT COUNT(DISTINCT(country)) AS "Toplam Ülke Sayısı" FROM customers;

-- 50. -- 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
SELECT SUM(od.unit_price*od.quantity) AS "Toplam Satış" FROM orders o 
INNER JOIN order_details od ON o.order_id=od.order_id
WHERE o.order_date BETWEEN '1998-01-01' AND CURRENT_DATE;

-- 51. -- 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
SELECT o.order_id, p.product_name, c.category_name, od.quantity FROM orders o 
INNER JOIN order_details od ON o.order_id=od.order_id
INNER JOIN products p ON od.product_id=p.product_id
INNER JOIN categories c ON p.category_id=c.category_id
WHERE o.order_id=10248;

-- 52. -- 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
SELECT o.order_id, p.product_name, s.company_name AS supplier_name FROM orders o 
INNER JOIN order_details od ON o.order_id=od.order_id
INNER JOIN products p ON od.product_id=p.product_id
INNER JOIN suppliers s ON s.supplier_id=p.supplier_id
WHERE o.order_id=10248;

-- 53. -- 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT e.first_name || ' ' || e.last_name AS "Employee fullname", 
o.order_date, p.product_name, od.quantity FROM orders o
INNER JOIN employees e ON o.employee_id=e.employee_id
INNER JOIN order_details od ON o.order_id=od.order_id
INNER JOIN products p ON od.product_id=p.product_id
WHERE e.employee_id=3 AND DATE_PART('year', order_date)=1997;

-- 54. -- 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
SELECT o.order_id, e.employee_id, e.first_name || ' ' || e.last_name AS "Employee fullname", 
SUM(od.quantity) AS toplam_satis, o.order_date FROM orders o 
INNER JOIN order_details od ON o.order_id=od.order_id
INNER JOIN employees e ON o.employee_id=e.employee_id
WHERE DATE_PART('year', order_date)=1997
GROUP BY o.order_id, e.employee_id
ORDER BY toplam_satis DESC
LIMIT 1;

-- 55. -- 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS "Employee fullname", 
SUM(od.quantity) AS toplam_satis FROM orders o 
INNER JOIN order_details od ON o.order_id=od.order_id
INNER JOIN employees e ON o.employee_id=e.employee_id
WHERE DATE_PART('year', order_date)=1997
GROUP BY e.employee_id
ORDER BY toplam_satis DESC
LIMIT 1;

-- 56. -- En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
SELECT p.product_name, p.unit_price, c.category_name FROM products p 
INNER JOIN categories c ON p.category_id=c.category_id
ORDER BY p.unit_price DESC
LIMIT 1;

-- 57. -- Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
SELECT e.first_name || ' ' || e.last_name AS "Employee fullname", o.order_date, o.order_id 
FROM orders o INNER JOIN employees e ON o.employee_id=e.employee_id
ORDER BY o.order_date DESC;

-- 58. -- SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT o.order_id, o.order_date, AVG(od.unit_price*od.quantity) AS ortalama_fiyat FROM orders o
INNER JOIN order_details od ON o.order_id=od.order_id
GROUP BY o.order_id
ORDER BY order_id DESC LIMIT 5;

-- 59. -- Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT p.product_name, c.category_name, SUM(od.quantity) FROM orders o
INNER JOIN order_details od ON o.order_id=od.order_id
INNER JOIN products p ON od.product_id=p.product_id
INNER JOIN categories c ON p.category_id=c.category_id
WHERE DATE_PART('month', order_date)=01
GROUP BY p.product_name, c.category_name;

-- 60. -- Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT o.order_id, o.order_date, SUM(od.quantity) FROM orders o
INNER JOIN order_details od ON o.order_id=od.order_id
GROUP BY o.order_id, od.order_id
HAVING SUM(od.quantity)>(SELECT AVG(quantity) FROM order_details)
ORDER BY SUM DESC;

-- 61. -- En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
SELECT SUM(od.quantity) AS toplam_satis, p.product_name, c. category_name, s.company_name FROM orders o
INNER JOIN order_details od ON o.order_id=od.order_id
INNER JOIN products p ON od.product_id=p.product_id
INNER JOIN categories c ON p.category_id=c.category_id
INNER JOIN suppliers s ON p.supplier_id=s.supplier_id
GROUP BY od.product_id, p.product_name, c. category_name, s.company_name
ORDER BY toplam_satis DESC LIMIT 1;

-- 62. -- Kaç ülkeden müşterim var
SELECT COUNT(DISTINCT(country)) AS "Toplam Ülke Sayısı" FROM customers;

-- 63. -- Hangi ülkeden kaç müşterimiz var
SELECT country, COUNT(*) AS "Müşteri Sayısı" FROM customers
GROUP BY country;

-- 64. -- 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
SELECT SUM(od.unit_price*od.quantity) AS "Toplam Satış" FROM orders o 
INNER JOIN order_details od ON o.order_id=od.order_id
WHERE o.order_date BETWEEN '1998-01-01' AND CURRENT_DATE;

-- 65. -- 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
SELECT SUM(od.quantity*(od.unit_price-(od.unit_price*od.discount))) AS "Son 3 aylık Toplam Ciro" FROM orders o 
INNER JOIN order_details od ON o.order_id=od.order_id
INNER JOIN products p ON od.product_id=p.product_id
WHERE p.product_id=10 AND o.order_date BETWEEN CURRENT_DATE-INTERVAL '3 months' AND CURRENT_DATE;

-- 66. -- Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
SELECT e.first_name || ' ' || e.last_name AS "Çalışan ad soyad", e.employee_id AS "Çalışan id",
COUNT(order_id) AS "Çalışan toplam sipariş" FROM orders o
INNER JOIN employees e ON o.employee_id=e.employee_id
GROUP BY e.employee_id;

-- 67. -- 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
SELECT c.customer_id, c.company_name, o.order_id FROM customers c 
LEFT JOIN orders o ON c.customer_id=o.customer_id
WHERE o.order_id IS NULL;


-- 68. -- Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
SELECT company_name, contact_name, country, address, city, region, postal_code FROM customers
WHERE LOWER(country)='brazil';

-- 69. -- Brezilya’da olmayan müşteriler
SELECT customer_id, company_name, country FROM customers
WHERE country<>'Brazil';

-- 70. -- Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT * FROM customers
WHERE country IN ('Spain','France','Germany');

-- 71. -- Faks numarasını bilmediğim müşteriler
SELECT customer_id, company_name, fax FROM customers
WHERE fax IS NULL;

-- 72. -- Londra’da ya da Paris’de bulunan müşterilerim
SELECT * FROM customers
WHERE LOWER(city) IN ('london','paris');

-- 73. -- Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
SELECT * FROM customers
WHERE city='México D.F.' AND contact_title='Owner';

-- 74. -- C ile başlayan ürünlerimin isimleri ve fiyatları
SELECT product_name, unit_price FROM products
WHERE LOWER(product_name) LIKE 'c%';

-- 75. -- Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
SELECT first_name || ' ' || last_name AS "Ad_Soyad", birth_date AS "Doğum Tarihi" FROM employees
WHERE first_name LIKE 'A%';

-- 76. -- İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
SELECT company_name FROM customers
WHERE UPPER(company_name) LIKE '%RESTAURANT%';

-- 77. -- 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
SELECT product_name, unit_price FROM products
WHERE unit_price BETWEEN 50 AND 100;

-- 78. -- 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
SELECT order_id, order_date FROM orders
WHERE order_date BETWEEN '1996-07-01' AND '1996-12-31';

-- 79. -- Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT * FROM customers
WHERE country IN ('Spain','France','Germany');

-- 80. -- Faks numarasını bilmediğim müşteriler
SELECT customer_id, company_name, fax FROM customers
WHERE fax IS NULL;

-- 81. -- Müşterilerimi ülkeye göre sıralıyorum:
SELECT * FROM customers
ORDER BY country ASC;

-- 82. -- Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
SELECT product_name, unit_price FROM products
ORDER BY unit_price DESC;

-- 83. -- Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
SELECT product_name, unit_price, units_in_stock FROM products
ORDER BY unit_price DESC, units_in_stock ASC;

-- 84. -- 1 Numaralı kategoride kaç ürün vardır..?
SELECT COUNT(*) FROM products
WHERE category_id=1;

-- 85. -- Kaç farklı ülkeye ihracat yapıyorum..?
SELECT COUNT(DISTINCT(ship_country)) FROM orders;

