
<cfparam name="url.header" default="0">

<cfif url.header eq "1">
	
	<cf_screentop scroll="no" 
	    height="100%" 
		html="Yes" 
		layout="webapp"
		bannercolor="gray"
		bannerforce="Yes"
		menuaccess="context"
		jquery="Yes"	
		busy="busy10.gif" 
		label="Staffing Table Detail">
	
<cfelse>
	
	<cf_screentop scroll="no" 
	    height="100%" 
		html="No" 
		jquery="Yes"	
		busy="busy10.gif" 
		title="Staffing Table Detail">

</cfif>	
	
	<!--- blockevent="rightclick" --->
		
	<cfparam name="URL.ID1"               default = "">
	<cfparam name="URL.ID4"               default = "">    
	<cfparam name="URL.header"            default = "Yes">
	<cfparam name="URL.Act"               default = "0">
	<cfparam name="URL.Mission"           default = "#URL.ID2#">
	<cfparam name="URL.Mandate"           default = "#URL.ID3#">
	<cfparam name="AccessStaffing"        default = "NONE">
	<cfparam name="CLIENT.lay"            default = "Maintain">
	<cfparam name="url.selectiondate"     default = "">
	<cfparam name="url.locationcode"      default = "">
	<cfparam name="url.orgunit1"          default = "">
	<cfparam name="url.orgunitcode"       default = "">
	<cfparam name="url.occgroup"          default = "">
	<cfparam name="url.parent"            default = "">
	<cfparam name="url.sourcepostnumber"  default = "">
	<cfparam name="url.vacant"            default = "">
	<cfparam name="url.name"              default = "">
			
	<cfajaximport tags="cfdiv,cfwindow,cfform">
	
	<cf_dialogPosition>
	<cf_dialogOrganization>
	<cf_dialogLookup>
	<cf_dialogProcurement>
	<cf_dropdown>
	<cf_calendarscript>
			
	<cfinclude template="MandateViewGeneralScript.cfm">
		
	<cfif CGI.HTTPS eq "off">
		<cfset tpe = "http">
	<cfelse>	
		<cfset tpe = "https">
	</cfif>
	
	<cfset client.link = "#tpe#://" & CGI.HTTP_HOST & CGI.SCRIPT_NAME & "?" & CGI.QUERY_STRING>
		
	<cf_customLink
		FunctionClass = "Staffing"
		FunctionName  = "stPosition"
		Scroll        = "no"
		Key           = "">       
	
	    <table width="100%" height="100%" align="center">
		
		<tr><td align"center" id="list" height="100%" style="padding-left:5px">		
			
		    <cfdiv style="height:100%" bind="url:MandateViewList.cfm?#cgi.query_string#&lay=listing">			
		
		</td></tr></table> 			
			
<cf_screenbottom html="No">

<cfset AjaxOnLoad("doHighlight")>	
