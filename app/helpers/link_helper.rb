# frozen_string_literal: true

module LinkHelper
  def link_name(link)
    gist?(link.url) ? gist_hash(link.url) : link.name
  end

  private

  def gist?(url)
    URI.parse(url).host == 'gist.github.com'
  end

  def gist_hash(url)
    URI.parse(url).path.split('/').last
  end
end
