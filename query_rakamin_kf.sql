CREATE OR REPLACE TABLE `rakamin-kf-analytics-459407.kimia_farma.kf_tabel_analisa` AS

SELECT
  ft.transaction_id,
  ft.date,
  ft.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,
  ft.customer_name,
  ft.product_id,
  p.product_name,
  ft.price AS actual_price,
  ft.discount_percentage,
  
  -- Persentase laba
  CASE 
    WHEN ft.price <= 50000 THEN 0.10
    WHEN ft.price > 50000 AND ft.price <= 100000 THEN 0.15
    WHEN ft.price > 100000 AND ft.price <= 300000 THEN 0.20
    WHEN ft.price > 300000 AND ft.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,
  
  -- Nett sales (harga setelah diskon)
  ft.price - (ft.price * ft.discount_percentage / 100.0) AS nett_sales,
  
  -- Nett profit (nett_sales * persentase_gross_laba)
  (ft.price - (ft.price * ft.discount_percentage / 100.0)) *
  CASE 
    WHEN ft.price <= 50000 THEN 0.10
    WHEN ft.price > 50000 AND ft.price <= 100000 THEN 0.15
    WHEN ft.price > 100000 AND ft.price <= 300000 THEN 0.20
    WHEN ft.price > 300000 AND ft.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS nett_profit,
  
  ft.rating AS rating_transaksi

FROM
  `rakamin-kf-analytics-459407.kimia_farma.kf_final_transaction` ft
JOIN
  `rakamin-kf-analytics-459407.kimia_farma.kf_kantor_cabang` kc
  ON ft.branch_id = kc.branch_id
JOIN
  `rakamin-kf-analytics-459407.kimia_farma.kf_product` p
  ON ft.product_id = p.product_id;
