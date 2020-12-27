
<script language="JavaScript">

function loadurl(url) {
   window.open(url)
}
</script>

<cfparam name="URL.Scope" default="Mission">
<cfparam name="cnt" default="0">

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
  
	<tr><td>
	
	<cfquery name="Mission" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT M.* 
		FROM Ref_Mission M 
		WHERE   M.Mission   = '#URL.Mission#'
	</cfquery>
	
	<cfquery name="MissionGroup" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  R.Description as GroupName, 
		        L.Description as GroupValue
		FROM Ref_MissionGroup G, 
			 Ref_GroupMission R,
			 Ref_GroupMissionList L
		WHERE   G.Mission   = '#URL.Mission#'
		AND G.GroupCode = L.GroupCode
		AND G.GroupListCode = L.GroupListCode
		AND R.Code = G.GroupCode 
	</cfquery>
	
	<cfquery name="Mandate" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_Mandate
		WHERE   Mission   = '#URL.Mission#'
		AND 	MandateNo = '#URL.Mandate#'
	</cfquery>
	  
	<cfquery name="Document" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_MandateDocument
		WHERE   Mission   = '#URL.Mission#'
		AND 	MandateNo = '#URL.Mandate#'
	</cfquery>
	
	<table width="100%" class="formspacing formpadding line'">
	
	    <tr class="line labelmedium2">
		<td style="padding-left:6px">Name:</td>
		<td><cfoutput><b>#Mission.MissionName# (#DateFormat(Mission.DateEffective, CLIENT.DateFormatShow)#)</cfoutput></td>
		</tr>
		
		<tr class="line labelmedium2">
		<td style="padding-left:6px">Management:</td>
		<td><cfoutput><b>#Mission.MissionOwner#</cfoutput></td>
		</tr>
		
		<tr class="labelmedium2 line">
		<td style="padding-left:6px"><cf_tl id="Staffing Mode">:</td>
		<td><cfoutput><b><cfif Mandate.MandateStatus eq "1">Locked<cfelse>Draft</cfif></cfoutput></td>
		</tr>
		<cfset cnt = cnt+30>
		
		<cfoutput query="MissionGroup">
		<cfset cnt = cnt+15>
		
		<tr class="line labelmedium2">
			<td style="padding-left:6px">#GroupName#</td>
			<td>#GroupValue#</td>
		</tr>
		</cfoutput>	
		
		  
	   <cfoutput query="Document">
	   <tr class="line labelmedium">
	   <td colspan="2" align="center">
	   <a href="#URL#" target="_blank">#CurrentRow#.<b> #Description#</b></a>
	   <img src="#SESSION.root#/Images/contract.GIF" 
	   alt="Open document" 
	   align="absmiddle"
	   border="0" style="cursor: pointer;" onClick="loadurl('#URL#')">
	   &nbsp;&nbsp;&nbsp;
	    </td>
		</tr>
	   </cfoutput>
		
	</table>
		
	</td></tr>
						
	<tr><td>
	
	  <table width="100%">
		   <tr>
		   <td>
		  		  	   
		    <cfinvoke component="Service.Access"  
	          method="org" 
			  mission="#URL.Mission#"
			  mandateNo="#URL.Mandate#"
			  returnvariable="accessOrg">
			  
			  <cfset url.accessorg = accessorg>
			  
			  <cfinclude template="MandateDocumentContent.cfm">
		 
		 <!---
		   <cf_securediv bind="url:#SESSION.root#/Staffing/Reporting/Postview/Staffing/MandateDocumentContent.cfm?mission=#url.mission#&mandate=#url.mandate#&accessorg=#accessorg#">
		   --->
		 					 
	      </td>
		  </tr>
	  </table>
	</td>
	
  </tr> 
	 	 
</table>		