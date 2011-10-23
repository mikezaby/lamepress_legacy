module ApplicationHelper

	include ActionView::Helpers::SanitizeHelper

	def javascript(*files)
  	content_for(:head) { javascript_include_tag(*files) }
	end

	def stylesheet(*files)
 		content_for(:head) { stylesheet_link_tag(*files) }
	end

  def keywords(string)
    content_for(:head) { raw "\n<meta name=\"keywords\" content=\""+string+"\" />"}
  end


  def menu(placement)
  	#return Navigator.find_all_by_nav_name(name, :include => "navigatable")
    menu_list=""
  	menu=Menu.where('placement = ?',placement)

    menu.each do |menu1|
      menu_list=mode(menu1)
    end
    return menu_list
  end

  def mode(menu)
    nav_list=""
    nav= Navigator.where('menu_id = ?', menu.id)
    if menu.mode="red_header"
      nav.each do |navigator|
        nav_list+="<li>"+(link_to navigator.name, "/"+(raw @iss)+"/"+navigator.navigatable.permalink)+"<li>"
      end
    end
    return nav_list
  end


	def issue_menu(nav)

		menu=""
		nav.each do |navigator|
			menu+="<li>"+(link_to navigator.menu_name, "/"+(raw @iss)+"/"+navigator.navigatable.permalink)+"<li>"
		end
		return menu
	end

	def summarize(html)

		html = html.gsub(/\<!--(.+?)--\>/m,"").gsub(/<\/?[^>]*>/, "")
		return html[0..300]
		#html = truncate(html, :length => 300, :omission => '...')
		#return strip_tags(html)

	end

	def cat_link(article)
		linkzor = "/"
		linkzor += article.issue_number.to_s+"/" unless article.issue_id.nil?
		linkzor += article.category_permalink
	end

end

