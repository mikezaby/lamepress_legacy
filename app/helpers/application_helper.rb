module ApplicationHelper

  include ActionView::Helpers::SanitizeHelper

  def javascript(*files)
    content_for(:scripts) { javascript_include_tag(*files) }
  end

  def stylesheet(*files)
    content_for(:head) { stylesheet_link_tag(*files) }
  end

  def keywords(string)
    raw %(<meta name="keywords" content="#{string}" />)
  end

  def cannonical_link(string)
    raw %(<link rel="canonical" href="#{string}"/>)
  end

  def description(string)
    raw %(<meta name="description" content="#{string}" />)
  end

  def head_title(string)
    raw "\n<title>#{string}</title>"
  end

  def block(name)
    partials = ""
    Block.place(name).each do |block|
      begin
        partials << (render :partial => "blocks/#{$layout}/#{block.partial}",
                            :locals => { block: block })
      rescue
        #replace this with something tha save error to database
        partial << "missing"
      end
    end
    raw partials
  end

  def render_linker(partial)
    render :partial => "article/#{$layout}/#{partial}"
  end

end

