<cfparam name="attributes.title"   		default="">
<cfparam name="attributes.root"    		default="">
<cfparam name="attributes.style"   		default="">
<cfparam name="attributes.jQueryAlias"  default="$">

<cfoutput>

	<!--- check the browser version --->
	<cf_validateBrowser>
	<cfset _prosisWebPrintWindowWidth = "10">
	<cfset _prosisWebPrintWindowHeight = "10">
	<cfif clientbrowser.name eq "Chrome">
		<cfset _prosisWebPrintWindowWidth = "1000">
		<cfset _prosisWebPrintWindowHeight = "800">
	</cfif>
	
	<cfset _prosisWebPrintTitle = "#attributes.title#">
	<cfset _prosisWebPrintTitle = replace(_prosisWebPrintTitle,"'","&##39;","ALL")>	
	
	<cfset standardCSS = "standard.css">
	<cfif clientbrowser.name eq "Explorer" and clientbrowser.Release eq "7">
		<cfset standardCSS = "standardIE7.css">
	</cfif>
	
	<script type="text/javascript">
		function ___prosisWebPrint(titleSelector,contentSelector,showUserInformation,callback) {
			var vStyle = '<li'+'nk rel="style'+'sheet" type="te'+'xt/css" href="#attributes.root#/images/css/#standardCSS#"> <br> <link rel="stylesheet" type="te'+'xt/css" hr'+'ef="#attributes.root#/#attributes.style#"> <br> <li'+'nk rel="style'+'sheet" type="tex'+'t/css" href="#attributes.root#/print.css" media="print"> <br> <'+'s'+'cr'+'ipt type="text/javascript" src="#attributes.root#/Scri'+'pts/jQuery/jquery.js"><'+'/scr'+'ipt'+'>';
			var vBody = '<bo'+'dy onl'+'oad="windo'+'w.print(); wi'+'ndow.clo'+'se();">';
			//var vBody = '<bo'+'dy>';
			var vBodyClose = '</bo'+'dy>';

			var currentdate = new Date(); 
			var hours = currentdate.getHours();
			var minutes = currentdate.getMinutes();
			var seconds = currentdate.getSeconds();
			var ampm = hours >= 12 ? 'pm' : 'am';
			hours = hours % 12;
			hours = hours ? hours : 12;
			hours = hours < 10 ? '0'+hours : hours;
			minutes = minutes < 10 ? '0'+minutes : minutes;
			seconds = seconds < 10 ? '0'+seconds : seconds;
			var strTime = hours + ':' + minutes + ':' + seconds + ' ' + ampm;
			var months = currentdate.getMonth()+1;
			months = months < 10 ? '0'+months : months;
			var days = currentdate.getDate();
			days = days < 10 ? '0'+days : days;

			var strDatetime = currentdate.getFullYear() + "-"  
			                +  months + "-" 
			                + days + " @ "
			                + strTime;
			
			var vTitle = '';
			
			if (showUserInformation || #attributes.jQueryAlias#.trim(titleSelector) != '') {
				vTitle += '<table width="100%">';
				if (#attributes.jQueryAlias#.trim(titleSelector) != '') {
					vTitle += '<tr><td width="100%" class="labellarge" style="height:30px; padding-left:7px; font-weight:bold;">'+#attributes.jQueryAlias#(titleSelector).html()+'</td></tr>';
				}
				if (showUserInformation) {
					vTitle += '<tr><td width="100%" class="labelit" style="padding-left:7px; font-size:12px;">#_prosisWebPrintTitle# - ' + strDatetime.toUpperCase() + '</td></tr>';
				}
				vTitle += '</table>';
			}
			
			var vContent = '';
			#attributes.jQueryAlias#(contentSelector).each(function(){
				if (#attributes.jQueryAlias#.trim(#attributes.jQueryAlias#(this).html()) != '') {
					vContent += #attributes.jQueryAlias#(this).html() + '<br>';
				}
			});
			
			var cbFunction = '';
			if (callback) {
				if (callback != '') {
					cbFunction = 'var callbackFunction = ' + callback + '; callbackFunction();';
				}
			}
			
			var vHideNoPrint = '<'+'s'+'cr'+'ipt'+'>#attributes.jQueryAlias#(".clsNoPrint").css("display","none"); ' + cbFunction + '<'+'/s'+'cr'+'ipt'+'>';
			
			w = window.open('', 'Print_Page', 'scrollbars=yes, width=#_prosisWebPrintWindowWidth#, height=#_prosisWebPrintWindowHeight#'); 
		    w.document.write(vStyle + vBody + vTitle + vContent + vHideNoPrint + vBodyClose);
		    w.document.close();
		}
		
		function _ProsisWebPrint(){
			this.print = ___prosisWebPrint;
		}
		
		//Attaching the method to the Prosis object if exists
		if (typeof Prosis != "undefined") {
			Prosis.webPrint = new _ProsisWebPrint();
		}
	</script>

</cfoutput>