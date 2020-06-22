module ApplicationHelper
  def center(xs: 0, sm: 0, md: 0, lg: 0, xl: 0)
    klass = []
    klass.push "offset-#{(12 - xs) / 2} col-#{xs}" if xs > 0
    klass.push "offset-sm-#{(12 - sm) / 2} col-sm-#{sm}" if sm > 0
    klass.push "offset-md-#{(12 - md) / 2} col-md-#{md}" if md > 0
    klass.push "offset-lg-#{(12 - lg) / 2} col-lg-#{lg}" if lg > 0
    klass.push "offset-xl-#{(12 - xl) / 2} col-xl-#{xl}" if xl > 0
    klass.any? ? klass.join(" ") : "col-12"
  end

  def pagination_links(pager)
    links = Array.new
    links.push(link_to t("pagination.frst"), pager.frst_page, remote: pager.remote, id: "pagn_frst") if pager.after_start?
    links.push(link_to t("pagination.next"), pager.next_page, remote: pager.remote, id: "pagn_next") if pager.before_end?
    links.push(link_to t("pagination.prev"), pager.prev_page, remote: pager.remote, id: "pagn_prev") if pager.after_start?
    links.push(link_to t("pagination.last"), pager.last_page, remote: pager.remote, id: "pagn_last") if pager.before_end?
    raw "#{pager.min_and_max} #{t('pagination.of')} #{pager.count} #{links.size > 0 ? '∙' : ''} #{links.join(' ∙ ')}"
  end

  def time_ago(time)
    seconds = Time.now.to_f - time.to_f
    minutes = seconds / 60.0
    hours = minutes / 60.0
    days = hours / 24.0
    years = days / 365.0

    case
    when seconds < 10 then "just now"
    when minutes < 1  then "#{seconds.round}s ago"
    when hours   < 1  then "#{minutes.round}m ago"
    when days    < 1  then "#{hours.round}h ago"
    when days    < 7  then time.strftime('%a')
    when days    < 31 then "#{days.round}d ago"
    when years   < 1  then time.strftime('%b')
    else                   time.strftime('%Y')
    end.gsub(" ", "&nbsp;").html_safe
  end
end
