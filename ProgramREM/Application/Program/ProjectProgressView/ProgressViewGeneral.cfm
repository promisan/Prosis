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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Progress report</proDes>
	<proCom>This file displays the details of progress report for a certain unit</proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cf_screentop height="100" scroll="Yes" html="No">

<cfset root = "#SESSION.root#">

<cfoutput>

<script>

var root = "#root#";

function AuditProject(Code,period) {
        w = #CLIENT.width# - 80;
		wd = w-30
        h = #CLIENT.height# - 120;
		window.open(root + "/ProgramREM/Application/Activity/Progress/ActivityView.cfm?html=1&width="+wd+"&Output=1&ProgramCode=" + Code + "&Period=" + period, "_blank", "left=40, top=40, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
}

function edit(id) {
     
      w = #CLIENT.width# - 180;
      h = #CLIENT.height# - 180;
	  ret = window.showModalDialog("#SESSION.root#/programrem/application/program/ActivityProject/ActivityView.cfm?ActivityId=" + id + "&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:yes; dialogHeight:"+h+"px; dialogWidth:"+w+"px; help:no; scroll:no; center:yes; resizable:yes");
	  if (ret == 0) {
		history.go()
	  }
	  
	  if (ret == 1) {
	    edit(id)
		history.go()
	  }
}

</script>

</cfoutput>




<cfparam name="CLIENT.Sort" default="OrgUnit">
<cfparam name="URL.Sort" default="ListingOrder">
<cfparam name="URL.View" default="All">
<cfparam name="URL.ID2" default="Template">
<cfparam name="URL.ID3" default="0000">
<cfparam name="URL.Mission" default="#URL.ID2#">
<cfparam name="URL.Mandate" default="#URL.ID3#">
<cfparam name="URL.page" default="1">

<!--- define orgunit --->

<cfquery name="Org" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT OrgUnit, HierarchyRootUnit, HierarchyCode
   FROM Organization
   WHERE OrgUnit     = '#URL.ID1#'
   	AND MandateNo    = '#URL.Mandate#'
	AND Mission      = '#URL.Mission#' 
   </cfquery>
   
<cfquery name="Root" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM #CLIENT.LanPrefix#Organization
   WHERE OrgUnitCode = '#Org.HierarchyRootUnit#'
     AND MandateNo   = '#URL.Mandate#'
     AND Mission     = '#URL.Mission#' 
</cfquery>

<cfinvoke component="Service.Access"
	Method   = "organization"
	OrgUnit  = "#Org.OrgUnit#"
	Period   = "#URL.Period#"
	Role     = "ProgressOfficer', 'ProgramManager', 'ProgramAuditor"
	ReturnVariable="ListingAccess">	
	
<CFIF ListingAccess NEQ "NONE">	

	<cfset FileNo = round(Rand()*100)>
	<cfset ProgramFilter = "ProgramCode IN (SELECT ProgramCode FROM ProgramPeriod WHERE Period = '#URL.Period#')">		
	<cfset UnitFilter    = "PA.OrgUnit IN (SELECT OrgUnit FROM Organization.dbo.Organization WHERE HierarchyCode LIKE '#Org.HierarchyCode#%' AND MandateNo = '#URL.Mandate#' AND Mission = '#URL.Mission#')">	

	<cfinclude template="../../Tools/ProgramActivityPendingPrepare.cfm">

	<!--- select activity ONLY for processing in case the Parent is not pending as well --->
	
	<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#ActivityPendingA#FileNo#">	
		
	<cfquery name="Pending" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM userQuery.dbo.#SESSION.acc#ActivityPending#FileNo# PA
    </cfquery>
	   
   <cfloop query="Pending">
   
     <!--- dependency correction ---> 
   
     <cfquery name="Check" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	  SELECT  P.ActivityParent
	  FROM    ProgramActivity A,
	          ProgramActivityParent P,
              userQuery.dbo.#SESSION.acc#ActivityPending#FileNo# Pending  
	  WHERE   A.ActivityId = '#Pending.ActivityId#'			 
	  AND     A.ProgramCode = P.ProgramCode 
	  AND     A.ActivityPeriod = P.ActivityPeriod 
	  AND     A.ActivityId = P.ActivityId 
	  AND     P.ProgramCode = Pending.ProgramCode 
	  AND     P.ActivityPeriod = Pending.ActivityPeriod 
	  AND     P.ActivityParent = Pending.ActivityId
	 </cfquery>		
	 
	 <cfif #Check.RecordCount# gte "1">
	 
	   <cfquery name="Delete" 
	   datasource="AppsQuery" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   DELETE FROM userQuery.dbo.#SESSION.acc#ActivityPending#FileNo# 
	   WHERE       ActivityId = '#Pending.ActivityId#'
	   </cfquery>
	 	 
	 </cfif>
      
   </cfloop>
   
    <cfquery name="SummaryPending"
	datasource="appsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     ProgramCode, SUM(ActivityWeight) AS WeightPending 
	INTO dbo.#SESSION.acc#ActivityPendingA#FileNo#
	FROM       #SESSION.acc#ActivityPending#FileNo# 
	GROUP BY ProgramCode
	</cfquery>
     
  	<cfquery name="SummaryActivityUnit"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    ProgramCode, SUM(ActivityWeight) AS WeightActivity
	INTO      userQuery.dbo.#SESSION.acc#Activity#FileNo#
	FROM      ProgramActivity PA
	WHERE     PA.OrgUnit IN (SELECT OrgUnit 
	                         FROM Organization.dbo.Organization 
							 WHERE HierarchyCode LIKE '#Org.HierarchyCode#%' 
							 AND MandateNo = '#URL.Mandate#' 
							 AND Mission = '#URL.Mission#')	
	AND       RecordStatus != '9'						 
	GROUP BY  ProgramCode  
  </cfquery>
   
   <cfquery name="Pending" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT   P.*, Pen.*, Act.WeightActivity, PA.WeightPending
   FROM     userQuery.dbo.#SESSION.acc#ActivityPendingA#FileNo# PA, 
  			userQuery.dbo.#SESSION.acc#Activity#FileNo# Act,
			userQuery.dbo.#SESSION.acc#ActivityPending#FileNo# Pen, 
            Program P
   WHERE    P.ProgramCode = PA.ProgramCode
   AND      P.ProgramCode = Act.ProgramCode
   AND      P.ProgramCode = Pen.ProgramCode 
   AND      P.ProgramClass = 'Project'    
   ORDER BY P.ProgramCode
   </cfquery>
   
   <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Activity#FileNo#">	
   <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#ActivityPending#FileNo#">	
   <CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#ActivityPendingA#FileNo#">	
   
   <cfif Pending.recordCount lt "1">
					
	  <cf_message message = "No pending progress reports found for this unit.  Please select another." return="No">
	  <cfabort>
		
   </cfif>
   
     
   <table width="99%" align="right" height="100%" border="0" bordercolor="silver"><tr><td valign="top">
         
   <table width="100%">
   
   <TR>
	   <td height="25" colspan="8">&nbsp;<b><font face="Verdana" size="2"><cf_tl id="PendingActivitiesInProjects"></td>
   </TR>
   
   <tr><td height="1" colspan="8" bgcolor="C0C0C0"></td></tr>
   
   <TR>
	   <td width="3%"></td>
	   <TD width="10%"><cf_tl id="Code"></TD>
	   <td width="57%" colspan="3"><cf_tl id="Name"></td>
	   <TD width="20%"colspan="3"><cf_tl id="ProgressForThisUnit"></TD>
	   
   </TR>
   
   <cfoutput query="Pending" group="ProgramCode">
    
   <tr>
      <td width="6%" height="24" align="center">
	   <img src="#SESSION.root#/Images/contract.gif" alt="Project activities" name="img0_#currentrow#" 
				  onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
				  onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/contract.gif'"
				  height="14" width="13"
				  style="cursor: pointer;" border="0" align="absmiddle" 
				  onClick="javascript:AuditProject('#ProgramCode#','#URL.Period#')">
	  </td> 
      <td><a href="javascript:AuditProject('#ProgramCode#','#URL.Period#')">#ProgramCode#</a></td>
      <td><a href="javascript:AuditProject('#ProgramCode#','#URL.Period#')">
	  		  <cfquery name="Parent" 
					 datasource="AppsProgram" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 SELECT     *
					 FROM       Program
					 WHERE      ProgramCode = '#ParentCode#'
					 AND        ProgramScope = 'Unit'
				  </cfquery>
				  <cfif #Parent.Recordcount# eq "1">
				  			<b>#Parent.ProgramName#:</b>
				  </cfif>
	  	  		  #ProgramName#
				  </a>
			  </td>
			  <td></td>
			  <td></td>
			 			  
		 <cfif #WeightActivity# gt "0">
				 <cfif #WeightPending# eq "">
				   <cfset pen = "0">
				   <cfset color = "red">
				 <cfelse>
				   <cfset pen = "#WeightPending#">
				 </cfif>
			
				 <cfset wgt = 100-((#pen#)*100/#WeightActivity#)>
				 <cfif wgt lt "30">
				   <cfset color = "red">
				 <cfelseif wgt lt "50">
				   <cfset color = "orange"> 
				 <cfelseif wgt lt "70">
				   <cfset color = "silver">
				 <cfelseif wgt lt "100">
				   <cfset color = "yellow">
				 <cfelse>
				   <cfset color = "lightgreen">  
				 </cfif>
				 
				 
				 <td colspan="2" align="center" bgcolor="#color#">
				  #numberFormat(wgt,"_._")#%
				 </td>
								 
			 </cfif>	  
			 
			 <tr><td colspan="7" bgcolor="e4e4e4"></td></tr>
   
   <cfoutput>
     
   
   <tr>
      <td colspan="7">
	  <table width="100%" cellspacing="0" cellpadding="0">
	  <tr>
	    <td align="center"><img src="#SESSION.root#/Images/join.gif" alt="" width="19" height="16" border="0"></td>
	    <td width="70%" colspan="2"><a href="javascript:edit('#activityid#')">#ActivityDescription#</a></td>
		<td width="90">#DateFormat(ActivityDateStart, CLIENT.DateFormatShow)#</td>
		<td width="90">&nbsp;#DateFormat(ActivityDate, CLIENT.DateFormatShow)#</td>
	  </tr>
	  </table>
	  </td>
   </tr>
   
   <tr><td></td><td height="1" colspan="6" bgcolor="E8E8E8"></td></tr>
     
   </cfoutput>
      
   </cfoutput>
   
   </table>
   
   </td></tr></table>
   
<cfelse>
	
	     <cf_message message = "You have no access to this organization level. Operation not allowed."
	      return = "No">
	
	</cfif> 
	
