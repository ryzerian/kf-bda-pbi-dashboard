create table `rakamin-kf-analytics-464103.kimia_farma.kf_tabel_analisa` as
with base as (
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
    case
      when ft.price <= 50000 then 0.10
      when ft.price <= 100000 then 0.15
      when ft.price <= 300000 then 0.20
      when ft.price <= 500000 then 0.25
      else 0.30
    end as persentase_gross_laba,
    ft.rating as rating_transaksi
  from
    `rakamin-kf-analytics-464103.kimia_farma.kf_final_transaction` ft
  join
    `rakamin-kf-analytics-464103.kimia_farma.kf_kantor_cabang` kc
    on ft.branch_id = kc.branch_id
  join
    `rakamin-kf-analytics-464103.kimia_farma.kf_product` p
    on ft.product_id = p.product_id
)

select
  *,
  actual_price * (1-discount_percentage) as nett_sales,
  (actual_price * (1-discount_percentage)) * persentase_gross_laba as nett_profit
from
  base;