view: products {
  sql_table_name: `bigquery-public-data.thelook_ecommerce.products` ;;
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  # --- Strategic Initiative Dimensions ---

  dimension: stock_out_risk {
    type: string
    description: "Segmentation for inventory critical but faces high demand risk."
    sql: CASE
           WHEN ${rank} < 10 THEN 'High Risk'
           WHEN ${rank} < 50 THEN 'Medium Risk'
           ELSE 'Low Risk'
         END ;;
  }

  # --- Measures ---

  measure: count {
    type: count
    drill_fields: [id, item_name, inventory_items.count]
  }

  measure: total_retail_price {
    type: sum
    sql: ${retail_price} ;;
    value_format_name: usd
  }
}
