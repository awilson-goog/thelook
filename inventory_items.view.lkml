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

  # --- Strategic Initiative Dimensions ---

  dimension: days_in_inventory {
    type: number
    description: "Number of days the item has been in inventory. For sold items, it's the time until sale. For unsold, it's time since creation."
    sql: DATE_DIFF(COALESCE(${sold_raw}, CURRENT_TIMESTAMP()), ${created_raw}, DAY) ;;
  }

  dimension: is_aged_inventory {
    type: yesno
    description: "Inventory aged over 180 days."
    sql: ${days_in_inventory} > 180 ;;
  }

  dimension: warehouse_location {
    type: string
    description: "Mocked warehouse location for strategic initiative. Domestic vs International."
    sql: CASE WHEN MOD(${id}, 2) = 0 THEN 'Domestic' ELSE 'International' END ;;
  }

  # --- Strategic Initiative Measures ---

  measure: count {
    type: count
    drill_fields: [id, products.item_name, products.id, order_items.count]
  }

  measure: total_cost {
    type: sum
    sql: ${cost} ;;
    value_format_name: usd
  }

  measure: potential_margin_loss {
    type: sum
    description: "Projected loss based on 10% markdown potential for aged inventory relative to retail price."
    sql: ${products.retail_price} * 0.10 ;;
    filters: [is_aged_inventory: "yes"]
    value_format_name: usd
  }

  measure: average_days_in_inventory {
    type: average
    sql: ${days_in_inventory} ;;
    value_format_name: decimal_1
  }

  measure: inventory_health_score {
    type: number
    description: "A composite score based on DII, Gross Margin, and Stock-Out Risk. Higher is better."
    # Simplified formula for demo: (1 / DII) * 100
    # In a real scenario, we'd include margin and risk factors.
    sql: 100.0 / NULLIF(${average_days_in_inventory}, 0) ;;
    value_format_name: decimal_2
  }
}
