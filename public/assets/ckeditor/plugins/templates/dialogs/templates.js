/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
(function(){var a=CKEDITOR.document;CKEDITOR.dialog.add("templates",function(a){function b(a,b){a.setHtml("");for(var d=0,e=b.length;d<e;d++){var f=CKEDITOR.getTemplates(b[d]),g=f.imagesPath,h=f.templates,i=h.length;for(var j=0;j<i;j++){var k=h[j],l=c(k,g);l.setAttribute("aria-posinset",j+1),l.setAttribute("aria-setsize",i),a.append(l)}}}function c(a,b){var c=CKEDITOR.dom.element.createFromHtml('<a href="javascript:void(0)" tabIndex="-1" role="option" ><div class="cke_tpl_item"></div></a>'),e='<table style="width:350px;" class="cke_tpl_preview" role="presentation"><tr>';return a.image&&b&&(e+='<td class="cke_tpl_preview_img"><img src="'+CKEDITOR.getUrl(b+a.image)+'"'+(CKEDITOR.env.ie6Compat?' onload="this.width=this.width"':"")+' alt="" title=""></td>'),e+='<td style="white-space:normal;"><span class="cke_tpl_title">'+a.title+"</span><br/>",a.description&&(e+="<span>"+a.description+"</span>"),e+="</td></tr></table>",c.getFirst().setHtml(e),c.on("click",function(){d(a.html)}),c}function d(b){var c=CKEDITOR.dialog.getCurrent(),d=c.getValueOf("selectTpl","chkInsertOpt");d?(a.on("contentDom",function(b){b.removeListener(),c.hide();var d=new CKEDITOR.dom.range(a.document);d.moveToElementEditStart(a.document.getBody()),d.select(1),setTimeout(function(){a.fire("saveSnapshot")},0)}),a.fire("saveSnapshot"),a.setData(b)):(a.insertHtml(b),c.hide())}function e(a){var b=a.data.getTarget(),c=f.equals(b);if(c||f.contains(b)){var d=a.data.getKeystroke(),e=f.getElementsByTag("a"),g;if(e){if(c)g=e.getItem(0);else switch(d){case 40:g=b.getNext();break;case 38:g=b.getPrevious();break;case 13:case 32:b.fire("click")}g&&(g.focus(),a.data.preventDefault())}}}CKEDITOR.skins.load(a,"templates");var f,g="cke_tpl_list_label_"+CKEDITOR.tools.getNextNumber(),h=a.lang.templates,i=a.config;return{title:a.lang.templates.title,minWidth:CKEDITOR.env.ie?440:400,minHeight:340,contents:[{id:"selectTpl",label:h.title,elements:[{type:"vbox",padding:5,children:[{id:"selectTplText",type:"html",html:"<span>"+h.selectPromptMsg+"</span>"},{id:"templatesList",type:"html",focus:!0,html:'<div class="cke_tpl_list" tabIndex="-1" role="listbox" aria-labelledby="'+g+'">'+'<div class="cke_tpl_loading"><span></span></div>'+"</div>"+'<span class="cke_voice_label" id="'+g+'">'+h.options+"</span>"},{id:"chkInsertOpt",type:"checkbox",label:h.insertOption,"default":i.templates_replaceContent}]}]}],buttons:[CKEDITOR.dialog.cancelButton],onShow:function(){var a=this.getContentElement("selectTpl","templatesList");f=a.getElement(),CKEDITOR.loadTemplates(i.templates_files,function(){var c=(i.templates||"default").split(",");c.length?(b(f,c),a.focus()):f.setHtml('<div class="cke_tpl_empty"><span>'+h.emptyListMsg+"</span>"+"</div>")}),this._.element.on("keydown",e)},onHide:function(){this._.element.removeListener("keydown",e)}}})})();