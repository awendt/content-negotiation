module ContentNegotiation

  extend ActiveSupport::Memoizable

  def client_accepted_languages
    parse_http_accept_language_header(request.env["HTTP_ACCEPT_LANGUAGE"])
  end

  def parse_http_accept_language_header(header)
    return [] unless header
    # assumes the languages are ordered by quality value
    # (see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4)
    http_accept_langs = header.split(/,/)

    # strip qvalues
    http_accept_langs.collect! { |lang| lang.split(/;/).first.split(/-/).first }

    http_accept_langs.uniq.map(&:to_sym)
  end
  memoize :parse_http_accept_language_header

end