<!--
    Copyright © 2025 Promisan B.V.

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
<cfoutput>

<cfparam name="URL.Context" default="Default">

	<cfform name="selection" onsubmit="return false" autocomplete="off">
	   	    
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	 
	 	  
	  	<cfquery name="Layout" 
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT  TOP 1 *
		 FROM    Ref_ReportControlLayOut R
		 WHERE   ControlId = '#ControlId#'
		</cfquery>
		
		<cfoutput>
		   <input type="hidden" name="LayoutId" id="LayoutId" value="#Layout.LayoutId#">
		</cfoutput>
		  
	  <tr><td height="4"></td></tr>
	                 
	  <tr><td colspan="2" align="left" class="labelmedium line" style="color:##808080; padding-left:27px; font-weight:200">
	    <cf_tl id="Add"> * (<cf_tl id="asterix">) <cf_tl id="as the last value"> <cf_tl id="to allow for selection"> <cf_tl id="of all other values">
	  </td></tr>	
	  
	  <tr id="criteria" class="regular"><td colspan="2" class="regular">
	    <table width="100%" border="0" align="center">
			  <tr><td width="2%"></td>
			  <td width="98%">
			  <cfset class = "'Selection'">
			  <cfinclude template="FormHTMLCriteria.cfm"></td></tr>
		 </table>
	  </td></tr>
	  
	   <tr><td>
		  <table width="100%">
		  
		  <tr>
		  	     		    			
		      <td align="center" height="30">
			  
			   <cfoutput>
				
				<cf_button2
					id="global"
					text="Save"
					type="button"
					onclick     = "ptoken.navigate('#SESSION.root#/tools/CFreport/SelectReportSave.cfm?global=1&mode=Form&controlId=#ControlId#&reportId=#ReportId#&GUI=HTML','result','','','POST','selection')">
					
				</cfoutput>
			
			  </td>
		      <td align="right" width="20" id="result"></td>	
			 
		  </tr>
		  </table>
	  </td></tr>
	  
	  <tr><td height="10"></td></tr>
	        
	 </table>  
	
	</cfform>

 </cfoutput>

