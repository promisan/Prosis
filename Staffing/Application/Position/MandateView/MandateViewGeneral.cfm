<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfparam name="url.header" default="0">

<cfif url.header eq "1">
	
	<cf_screentop 
	    height="100%" 
		html="Yes" 
		layout="webapp"
		bannercolor="gray"
		bannerforce="Yes"
		menuaccess="context"
		jquery="Yes"	
		Scroll="no"
		busy="busy10.gif" 
		label="Staffing Table Detail">
	
<cfelse>
	
	<cf_screentop 
	    height="99%" 		 
		html="No"
		jquery="Yes"	
		scroll="no"
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
			
	<cfajaximport tags="cfdiv,cfform">
	
	<cf_dialogPosition>
	<cf_dialogOrganization>
	<cf_dialogLookup>
	<cf_dialogProcurement>
	<cf_dropdown>
	<cf_calendarscript>
			
	<cfinclude template="MandateViewGeneralScript.cfm">
	
	<!--- disabled, not clear how it is still used
		
	<cfif CGI.HTTPS eq "off">
		<cfset tpe = "http">
	<cfelse>	
		<cfset tpe = "https">
	</cfif>
	
	<cfset client.link = "#tpe#://" & CGI.HTTP_HOST & CGI.SCRIPT_NAME & "?" & CGI.QUERY_STRING>
	
	--->
		
	<cf_customLink
		FunctionClass = "Staffing"
		FunctionName  = "stPosition"
		Scroll        = "no"
		Key           = "">       
		
	    <table width="100%" height="100%" align="center">
		
		<tr><td align"center" id="list" style="height:99%;padding-left:5px">	
				
		    <cf_divscroll>
			<script>
			Prosis.busy('yes')
			_cf_loadingtexthtml='';		
			</script>								
		    <cf_securediv style="height:98.5%" bind="url:MandateViewList.cfm?#cgi.query_string#&lay=listing">	
			
			</cf_divscroll>			
		
		</td></tr>
		
		</table> 	
			
<cf_screenbottom html="No">

<cfset AjaxOnLoad("doHighlight")>	
