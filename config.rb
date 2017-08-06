require 'pathname'

page '/guides/*', layout: 'guides'

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true, autolink: true, with_toc_data: true

activate :syntax

configure :development do
  activate :livereload
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash, ignore: '*.jpg'
end

helpers do
  def guides
    sitemap.resources
      .select { |r| Pathname(r.path).dirname.to_s == "guides" }
      .sort_by { |r| r.data["number"] || 99 }
  end

  def table_of_contents(resource)
    content = File.read(resource.source_file)
      .gsub(/\A---(.|\n)*?---/, "")
      .gsub(/^#\s.+$/, "")

    toc_renderer = Redcarpet::Render::HTML_TOC.new(nesting_level: 2)
    markdown = Redcarpet::Markdown.new(toc_renderer)
    markdown.render(content)
  end
end

