
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
	
	<table width="98%" cellspacing="0" cellpadding="0" align="center">
	
	  <tr><td height="5"></td></tr>
	  <tr><td class="labelit">
	  <table><tr><td class="labelmedium" style="padding:10px">
	  	<cf_tl id="Search">:
	  </td>
	  <td>
	  <input type="text" onKeyUp="check()" name="condition" id="condition" size="15" maxlength="20" class="regularxl">
	  </td>
	  <td>
	  <button name="search" id="search" class="button10g" style="height:25;width:35" onclick="search( $('##condition').val())">
		  <img height="15" width="15" src="../../../../Images/locate3.gif" border="0">
	  </button>
	  </td></tr></table>
	  
	  </td></tr>
	     
	  <tr><td class="linedotted"></td></tr>
	  
	  <tr>
	  	<td style="padding:10px">
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
