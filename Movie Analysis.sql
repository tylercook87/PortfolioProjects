--Q1: What are the top movies rented from each family category given the following--categories are considered family movies: Animation, Children, Classics, Comedy, Family--and Music.
SELECT sub3.film_title, sub3.category_name, sub3.rental_count
  FROM  
       (SELECT sub.category_name, MAX(sub.rental_count) rental_count
      FROM 
            (SELECT f.title film_title,
            c.name category_name,
            COUNT(r.rental_id) rental_count
            FROM category c
            JOIN film_category fc
            ON fc.category_id = c.category_id
            JOIN film f
            ON f.film_id = fc.film_id
            JOIN inventory i
            ON i.film_id = f.film_id
            JOIN rental r
            ON r.inventory_id = i.inventory_id
            WHERE 1=1
            AND c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
            GROUP BY f.title, c.name) sub
      GROUP BY sub.category_name)sub2
JOIN
      (SELECT f.title as film_title,
      c.name category_name,
      COUNT(r.rental_id) rental_count
      FROM category c
      JOIN film_category fc
      ON fc.category_id = c.category_id
      JOIN film f
      ON f.film_id = fc.film_id
      JOIN inventory i
      ON i.film_id = f.film_id
      JOIN rental r
      ON r.inventory_id = i.inventory_id
      WHERE 1=1
      AND c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
      GROUP BY f.title, c.name) sub3
      ON sub3.category_name = sub2.category_name AND sub3.rental_count = sub2.rental_count
ORDER BY 3 DESC, 2, 1

--Q2: What quartile shows the highest count of rental duration by quartile by category for--Family movies as defined by question 1?
SELECT sub.category_name, SUM(sub.rental_duration), sub.quartile
FROM
    (SELECT c.name category_name,
    f.rental_duration rental_duration,
    NTILE(4) OVER (ORDER BY f.rental_duration) quartile
    FROM category c
    JOIN film_category fc
    ON fc.category_id = c.category_id
    JOIN film f
    ON f.film_id = fc.film_id
    WHERE 1=1
    AND c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
    ) sub
GROUP BY 1,3
ORDER BY 1,3,2

--Q3:Describe the rental trends broken down yearly/monthly for each store.
SELECT sub.Year_month, SUM(sub.rental_count_store_id_1) store_1, SUM(sub.rental_count_store_id_2) store_2
FROM  
    (SELECT DATE_PART('year',r.rental_date) || '/'|| DATE_PART('month',r.rental_date) Year_month, CASE WHEN s1.store_id = 1 THEN COUNT(rental_id) ELSE NULL END rental_count_store_id_1,
    CASE WHEN s1.store_id = 2 THEN COUNT(rental_id)  ELSE NULL END rental_count_store_id_2
    FROM store s1
    JOIN staff s2
    ON s2.store_id = s1.store_id
    JOIN rental r
    ON r.staff_id = s2.staff_id
    GROUP BY 1 ,s1.store_id) sub
GROUP BY 1
ORDER BY 1

--Q4: What are the highest and lowest yielding months for each store?
SELECT sub.month, SUM(sub.total_amt_daily_store_1)store1_daily_amt, SUM(sub.total_amt_daily_store_2)store2_daily_amt
FROM
    (SELECT DATE_TRUNC('month',r.rental_date) order_by_date, TO_CHAR(r.rental_date,'month')as month, CASE WHEN s1.store_id = 1 THEN SUM(p.Amount) ELSE NULL END total_amt_daily_store_1 , 
    CASE WHEN s1.store_id = 2 THEN SUM(p.Amount) ELSE NULL END total_amt_daily_store_2
    FROM rental r
    JOIN staff s2
    ON s2.staff_id = r.staff_id
    JOIN store s1
    ON s1.store_id = s2.store_id
    LEFT JOIN payment p
    ON p.rental_id = r.rental_id
    GROUP BY 1,2, s1.store_id
    ORDER BY 1) sub
GROUP BY 1, sub.order_by_date
ORDER BY sub.order_by_date