module ApplicationHelper

	include ActionView::Helpers::SanitizeHelper

	def javascript(*files)
  	content_for(:scripts) { javascript_include_tag(*files) }
	end

	def stylesheet(*files)
 		content_for(:head) { stylesheet_link_tag(*files) }
	end

  def keywords(string)
    content_for(:head) { raw "\n<meta name=\"keywords\" content=\""+string+"\" />"}
  end

  def head_title(string)
    content_for(:title) { string+" | "}
  end

  def head_desc(string)
    content_for(:head) {  raw "\n<meta name=\"description\" content=\""+string+"\" />"}
  end

  def block(name)
    partials = ""
    Block.place(name).each do |block|
      partials += render :partial => 'blocks/'+block.mode, :locals => { block: block}
    end
    raw partials
  end


end

