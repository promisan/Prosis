
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
	
	    <tr class="line">
		<td class="labelmedium">&nbsp;Name:</td>
		<td class="labelmedium"><cfoutput><b>#Mission.MissionName# (#DateFormat(Mission.DateEffective, CLIENT.DateFormatShow)#)</cfoutput></td>
		</tr>
		
		<tr class="line">
		<td class="labelmedium">&nbsp;Management:</td>
		<td class="labelmedium"><cfoutput><b>#Mission.MissionOwner#</cfoutput></td>
		</tr>
		
		<tr class="line">
		<td class="labelmedium">&nbsp;Staffing Mode:</td>
		<td class="labelmedium"><cfoutput><b><cfif Mandate.MandateStatus eq "1">Locked<cfelse>Draft</cfif></cfoutput></td>
		</tr>
		<cfset cnt = cnt+30>
		
		<cfoutput query="MissionGroup">
		<cfset cnt = cnt+15>
		
		<tr class="line">
			<td class="labelmedium">&nbsp;#GroupName#</td>
			<td class="labelmedium">#GroupValue#</td>
		</tr>
		</cfoutput>
				
		<tr class="line">
		  
		   <cfoutput query="Document">
		   <td colspan="2" align="center" class="labelmedium">
		   <a href="#URL#" target="_blank">#CurrentRow#.<b> #Description#</b></a>
		   <img src="#SESSION.root#/Images/contract.GIF" 
		   alt="Open document" 
		   align="absmiddle"
		   border="0" style="cursor: pointer;" onClick="loadurl('#URL#')">
		   &nbsp;&nbsp;&nbsp;
		    </td>
		   </cfoutput>
		  
		</tr>
	
	</table>
	
	</td></tr>
						
	<tr><td>
	  <table width="100%">
		   <tr>
		   <td>

		  <cf_fileLibraryScript>
		  	   
		    <cfinvoke component="Service.Access"  
	          method="org" 
			  mission="#URL.Mission#"
			  mandateNo="#URL.Mandate#"
			  returnvariable="accessOrg">
		  
		   <cfdiv bind="url:#SESSION.root#/Staffing/Reporting/Postview/Staffing/MandateDocumentContent.cfm?mission=#url.mission#&mandate=#url.mandate#&accessorg=#accessorg#">
		 					 
	      </td>
		  </tr>
	  </table>
	</td></tr> 
	 	 
</table>		