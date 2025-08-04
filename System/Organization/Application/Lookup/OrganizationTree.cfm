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

<cf_screentop html="No" JQuery="yes" scroll="yes">

<cfparam name="URL.Effective" default="">
<cfparam name="URL.Mandate" default="">

<cfif URL.Effective eq "undefined" or URL.Effective eq "">

  <cfset eff = "">
  
<cfelse>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#URL.Effective#">
	<cfset eff = dateFormat(dateValue,CLIENT.DateSQL)>
	
</cfif>

<cfif url.Mandate eq "" and eff eq "">

	<cfquery name="Verify" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
	      FROM   Ref_Mandate
	   	  WHERE  Mission = '#url.Mission#'  
	 </cfquery>
	  
<cfelseif url.Mandate neq "">

	<cfquery name="Verify" 
	  datasource="AppsOrganization" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
	      FROM   Ref_Mandate
	   	  WHERE  Mission = '#url.Mission#' 
		  AND    MandateNo = '#url.Mandate#' 
	 </cfquery>
		 
<cfelse>

	<cfquery name="Verify" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		      SELECT *
		      FROM   Ref_Mandate
		   	  WHERE  Mission = '#url.Mission#' 
			  AND    DateEffective  <= '#eff#'
			  AND    DateExpiration >= '#eff#' 
			  AND    Operational = 1
	 </cfquery> 
		  
</cfif>  

<cfoutput>
		
	<script>
	
		function refreshTree() {
			window.location.reload();
		}
		
		function check() {	
			if (window.event.keyCode == "13") {
				$('##search').click();
			}	
		}
		
		function search(condition) { 
			$('##rightOrganizationView', window.parent.document).attr('src','OrganizationListingFlat.cfm?ID1='+condition+'&mission=#URL.mission#&mandate=#verify.MandateNo#');
		}
	
	</script>
	
	<table width="98%" align="center">
	
	  <tr><td height="5"></td></tr>
	  <tr><td class="labelit">
	  <table><tr><td class="labelmedium" style="padding:10px">
	  	<cf_tl id="Search">:
	  </td>
	  <td>
	  <input type="text" style="background-color:f1f1f1;border:0px;" onKeyUp="check()" name="condition" id="condition" size="20" maxlength="20" class="regularxxl">
	  </td>
	  <td>	  
	  <button name="search" id="search" class="button10g" style="background-color:f1f1f1;border:0px;height:28px;width:35" onclick="search( $('##condition').val())">
		  <img height="16" width="16" src="../../../../Images/locate3.gif" border="0">
	  </button>
	  </td></tr></table>
	  
	  </td></tr>
	     
	  <tr><td class="line"></td></tr>
	  
	  <tr>
	  	<td style="padding:10px">
		
		    <!--- needs to be replaced --->
		
			<cf_eztree
				template="TreeTemplate/OrganizationLookupTreeData.cfm"
				iconpath="#SESSION.root#/Tools/Treeview/Images" 
				target="rightOrganizationView"
				mission="#URL.Mission#"
				mandate="#URL.Mandate#"
				effective="#Eff#"
				process=""
				scriptpath=".">
				
		</td>
	  </tr>
	
	</table>
	
</cfoutput>
