export function buildChartDisplayData(source, viewMode) {
  const values = source.values || []
  const total = values.reduce((sum, value) => sum + value, 0)
  const percentages = values.map((value) => (total > 0 ? (value / total) * 100 : 0))

  return {
    labels: source.labels || [],
    values,
    percentages,
    displayValues: viewMode === "percentage" ? percentages : values
  }
}

export function generateLegendLabels(chart, data, primaryValueFor) {
  const dataset = chart.data.datasets[0]

  return data.labels.map((label, index) => {
    const backgroundColor = Array.isArray(dataset.backgroundColor) ? dataset.backgroundColor[index] : dataset.backgroundColor

    return {
      text: `${label}: ${primaryValueFor(data, index)}`,
      fillStyle: backgroundColor,
      strokeStyle: backgroundColor,
      lineWidth: dataset.borderWidth || 0,
      hidden: !chart.getDataVisibility(index),
      index
    }
  })
}

export function tooltipLabel(context, data, primaryValueFor, secondaryValueFor) {
  const index = context.dataIndex
  const primaryValue = primaryValueFor(data, index)
  const secondaryValue = secondaryValueFor(data, index)

  return `${context.label}: ${primaryValue} (${secondaryValue})`
}

export function primaryValueFor(viewMode, data, index, formatCurrency, formatPercentage) {
  return viewMode === "percentage" ? formatPercentage(data.percentages[index]) : formatCurrency(data.values[index])
}

export function secondaryValueFor(viewMode, data, index, formatCurrency, formatPercentage) {
  return viewMode === "percentage" ? formatCurrency(data.values[index]) : formatPercentage(data.percentages[index])
}

export function formatCurrency(locale, currency, value) {
  return new Intl.NumberFormat(locale, { style: "currency", currency }).format(value || 0)
}

export function formatPercentage(locale, value) {
  return new Intl.NumberFormat(locale, {
    style: "percent",
    minimumFractionDigits: 1,
    maximumFractionDigits: 1
  }).format((value || 0) / 100)
}
