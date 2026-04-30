module ReportsHelper
  def status_badge_class(status)
    case status
    when :at_risk
      "bg-danger"
    when :on_track_low
      "bg-warning text-dark"
    when :on_track_medium
      "bg-info"
    when :on_track_high
      "bg-success"
    when :completed
      "bg-primary"
    else
      "bg-secondary"
    end
  end

  def progress_bar_class(percentage)
    case percentage
    when 0...25
      "bg-danger"
    when 25...50
      "bg-warning"
    when 50...75
      "bg-info"
    when 75...100
      "bg-success"
    else
      "bg-primary"
    end
  end
end
