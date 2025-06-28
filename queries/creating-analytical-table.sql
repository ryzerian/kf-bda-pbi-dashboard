create table `rakamin-kf-analytics-464103.kimia_farma.kf_tabel_analisa` as -- membuat tabel baru dengan CREATE TABLE bernama tabel_analisa
with base as (
  /* melakukan SELECT dengan menggunakan ALIAS pada nama kolom untuk memudahkan
  dalam membedakan kolom dengan nama yang sama pada tabel berbeda */
  select
    ft.transaction_id,
    ft.date,
    ft.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating as rating_cabang,
    ft.customer_name,
    ft.product_id,
    p.product_name,
    ft.price as actual_price,
    ft.discount_percentage,
    -- menggunakan CASE WHEN untuk melakukan pengelompokkan gross laba sesuai ketentuan
    case
      when ft.price <= 50000 then 0.10
      when ft.price <= 100000 then 0.15
      when ft.price <= 300000 then 0.20
      when ft.price <= 500000 then 0.25
      else 0.30
    end as persentase_gross_laba,
    ft.rating as rating_transaksi
  /* melakukan deklarasi ALIAS untuk tabel yang digunakan, yaitu FT = final_transaction;
  KC = kantor_cabang; dan P = product; serta dilakukan JOIN untuk kolom dengan nama yang sama
  pada tabel berbeda agar data match */  
  from
    `rakamin-kf-analytics-464103.kimia_farma.kf_final_transaction` ft
  join
    `rakamin-kf-analytics-464103.kimia_farma.kf_kantor_cabang` kc
    on ft.branch_id = kc.branch_id
  join
    `rakamin-kf-analytics-464103.kimia_farma.kf_product` p
    on ft.product_id = p.product_id
)
/* menggunakan CTE untuk melakukan kalkulasi terhadap nett_sales dan nett_profit yang membutuhkan
persentase_gross_laba terdeklarasi terlebih dahulu */
select
  *,
  actual_price * (1-discount_percentage) as nett_sales,
  (actual_price * (1-discount_percentage)) * persentase_gross_laba as nett_profit
from
  base;