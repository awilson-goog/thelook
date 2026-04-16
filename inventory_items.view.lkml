view: inventory_items {
  sql_table_name: `bigquery-public-data.thelook_ecommerce.inventory_items` ;;
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    sql: ${TABLE}.created_at ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension: days_in_inventory {
    type: number
    sql: date_diff(current_date(), date(${created_date}), day) ;;
  }

  dimension: margin_pct {
    type: number
    sql: 1.0 * (${products.retail_price} - ${cost}) / nullif(${products.retail_price}, 0) ;;
    value_format_name: percent_2
  }

  dimension: inventory_health_score {
    type: number
    sql: (0.5 * (1.0 - ${days_in_inventory} / 800.0)) + (0.5 * ${margin_pct}) ;;
    value_format_name: decimal_2
  }

  dimension: potential_margin_loss {
    type: number
    sql: CASE
          WHEN ${days_in_inventory} > 120 THEN ${cost} * 0.5
          WHEN ${days_in_inventory} >= 90 THEN ${cost} * 0.2
          ELSE 0
         END ;;
    value_format_name: usd
  }

  measure: total_potential_margin_loss {
    type: sum
    sql: ${potential_margin_loss} ;;
    value_format_name: usd
  }

  measure: average_inventory_health_score {
    type: average
    sql: ${inventory_health_score} ;;
    value_format_name: decimal_2
  }

  dimension_group: sold {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    sql: ${TABLE}.sold_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id, products.item_name, products.id, order_items.count]
  }
}
