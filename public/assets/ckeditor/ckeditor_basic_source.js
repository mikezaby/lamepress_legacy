/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
// Compressed version of core/ckeditor_base.js. See original for instructions.
/*jsl:ignore*/
window.CKEDITOR||(window.CKEDITOR=function(){var a={timestamp:"",version:"3.6.2",revision:"7275",_:{},status:"unloaded",basePath:function(){var a=window.CKEDITOR_BASEPATH||"";if(!a){var b=document.getElementsByTagName("script");for(var c=0;c<b.length;c++){var d=b[c].src.match(/(^|.*[\\\/])ckeditor(?:_basic)?(?:_source)?.js(?:\?.*)?$/i);if(d){a=d[1];break}}}return a.indexOf(":/")==-1&&(a.indexOf("/")===0?a=location.href.match(/^.*?:\/\/[^\/]*/)[0]+a:a=location.href.match(/^[^\?]*\/(?:)/)[0]+a),a}(),getUrl:function(a){return a.indexOf(":/")==-1&&a.indexOf("/")!==0&&(a=this.basePath+a),this.timestamp&&a.charAt(a.length-1)!="/"&&(a+=(a.indexOf("?")>=0?"&":"?")+"t="+this.timestamp),a}},b=window.CKEDITOR_GETURL;if(b){var c=a.getUrl;a.getUrl=function(d){return b.call(a,d)||c.call(a,d)}}return a}()),CKEDITOR._autoLoad="core/ckeditor_basic",document.write('<script type="text/javascript" src="'+CKEDITOR.getUrl("_source/core/loader.js")+'"></script>');