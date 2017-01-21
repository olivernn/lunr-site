require 'pathname'

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

page '/guides/*', layout: 'guides'

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true, autolink: true, with_toc_data: true

activate :syntax

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

###
# Helpers
###

helpers do
  def guides
    sitemap.resources.select do |resource|
      Pathname(resource.path).dirname.to_s == "guides"
    end
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

# Build-specific configuration
configure :build do
  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end
