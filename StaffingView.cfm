
<!--- obtain positions by orgunit --->

<cf_screentop jquery="Yes" html="No" scroll="Yes">

<cfajaximport tags="cfform,cfdiv">

<cfoutput>

    <cf_dialogStaffing>
	
	<script language="JavaScript">
	
		function personevent(personno, mission) {
		    
			if ($('##row'+personno).is(':visible')) {
				$('##content'+personno).html('');
				$('##row'+personno).hide();
			} else {
			    ptoken.navigate('StaffingViewEvents.cfm?personno='+personno+'&mission='+mission,'content'+personno, function(){$('##row'+personno).show()})
			}
		}
		
	</script>	
</cfoutput>

<style>html { font-size: 16px; font-family: Arial, Helvetica, sans-serif; }</style>	

<cfparam name="url.mission"    default="STL">
<cfparam name="url.selection"  default="01/01/2020">

<!--- clean the field to pass only the needed ones --->

<cfquery name="Position" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT      TOP 100 Mission, MandateNo, MissionOwner, OrgunitOperational, OrgunitName, OrgunitNameShort, 
		            OrgUnitClass, HierarchyCode, OrgUnitCode, PositionNo, 
                    FunctionNo, FunctionDescription, OccGroupOrder, OccGroupAcronym, OccupationalGroup, OccGroupDescription, 
					PostType, PostClass, PostClassGroup, 
                    PostInBudget, 
					VacancyActionClass, ShowVacancy, PostAuthorised, PositionParentId, SourcePostNumber, 
					DateEffective, DateExpiration, PostGrade, PostOrder, 
                    ApprovalPostGrade, LocationCode, PostGradeBudget, PostOrderBudget, PostGradeParent
					
		FROM        vwPosition
		WHERE       Mission = '#URL.Mission#' 
		AND         DateEffective  < '#url.selection#' 
		AND         DateExpiration > '#url.selection#'
		<!--- limit access to positions for which this person is HRA 
		AND         OrgUnit = '#orgUnit#'
		--->
		ORDER BY    HierarchyCode, PostOrder
		
</cfquery>		

<!--- clean the field to pass only the needed ones --->

<cfquery name="Assignment" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT     Mission, MandateNo, MissionOperational, PersonNo, IndexNo, FullName, LastName, MiddleName, FirstName, Nationality, Gender, BirthDate, 
                   eMailAddress, ParentOffice, ParentOfficeLocation, PersonReference, Operational, OrgUnit, OrgUnitName, OrgUnitNameShort, OrgUnitHierarchyCode, OrgUnitClass, 
                   ParentOrgUnit, OrgUnitClassOrder, OrgUnitClassName, DateEffective, DateExpiration, FunctionDescriptionActual, FunctionNo, FunctionDescription, PositionNo, 
                   PositionParentId, OrgUnitOperational, OrgUnitAdministrative, OrgUnitFunctional, PostType, PostClass, LocationCode, VacancyActionClass, PostGrade, PostOrder, 
                   SourcePostNumber, PostOrderBudget, PostGradeBudget, PostGradeParent, OccGroup, OccGroupName, OccGroupOrder, PostGradeParentDescription, ViewOrder, 
                   ContractId, AssignmentNo, AssignmentStatus, AssignmentClass, AssignmentType, Incumbency, Remarks, ExpirationCode, ExpirationListCode, AssignmentLocation
		FROM       vwAssignment
		WHERE      Mission = '#URL.Mission#' 
		AND        DateEffective  < '#url.selection#' 
		AND        DateExpiration > '#url.selection#'
		AND        AssignmentStatus IN ('0','1') 
		
</cfquery>
    
<style>
    .btn-sm {
    background:#3498DB;
    border-radius: 5px;
    color: #ffffff;
    width: 20px;
    height: 20px;
    padding: 7px 6px 2px 8px;
    margin: 3px;
    display: block;
}
    .btn-sm:hover { 
    background: #033F5D;
        color: #ffffff;
</style>

<table width="98%" align="center" style="padding:10px;min-width:700px">

<tr><td style="padding:10px">


<table width="100%" border="0" align="center" class="navigation_table">

<cfoutput query="Position" group="HierarchyCode">

<tr class="labelmedium"><td colspan="9" style="padding-top:10px;height:67px;font-size:29px">#OrgUnitName#</td></tr>

<cfoutput>


<tr class="labelmedium2 line navigation_row" style="border-top:1px solid silver">
  <td style="padding-left:3px; font-weight:bold">#SourcePostNumber#</td>
  <td colspan="2" style="padding-left:3px;padding-right:3px;font-weight:bold;font-size:17px">#PostGrade# #FunctionDescription#</td>  
  <td colspan="3" align="right">
	  <table>
	  <tr>
	  <td style="min-width:30px"><a href="##" class="btn-sm"><i class="fas fa-users-class"></i></a></td>
	  <td style="min-width:30px"><a href="##" class="btn-sm" style="padding:7px 4px 2px 12px;"><i class="fas fa-plus"></i></a></td>
	  </tr>
	  </table>
  </td>
   
	  <cfquery name="AssignDetail" dbtype="query">
			SELECT     *
			FROM       Assignment
			WHERE      PositionNo = '#PositionNo#' 		
	  </cfquery>	
  </tr>
  
  <tr class="labelmedium2 <cfif currentrow lt recordcount>class=line</cfif>" style="height:20px">  
  
  	  	  
	  <cfif assigndetail.recordcount eq "0">
	  
	  <td colspan="6" align="center" style="padding:3px;background-color:yellow"><cf_tl id="Vacant"></td>
	  
	  <cfelse>
	    
  <!---
	  <div class="row">	  
	  --->
	  		  
		  <!--- show assignments --->
		  	  
		  <cfloop query="assignDetail">
		  		     
			  <td style="padding-left:25px;padding-right:4px;cursor:pointer" onclick="javascript:personevent('#personno#','#url.mission#')">[X]</td>		     
			  <td style="width:100%">
			  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-female.png">
			  <img src='#vPhoto#' class="img-circle clsRoundedPicture" style="height:45px; width:45px;">
			  #FullName#</td>
			 
			  <td style="min-width:80">
		  		<cf_UITooltip
					id         = "#assignDetail.AssignmentNo#"
					ContentURL = "StaffingViewDetail.cfm?assignmentNo=#assignDetail.AssignmentNo#&personNo=#assignDetail.PersonNo#"
					CallOut    = "false"
					Position   = "left"
					Width      = "400"
					Height     = "200"
					Duration   = "300">#IndexNo#</cf_UItooltip>
			  </td>
			  
			  <cfquery name="getContract" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT     *
					FROM       PersonContract
					WHERE      PersonNo = '#PersonNo#' 	
					AND        Mission IN ('UNDEF','#url.mission#')	
					AND        ActionStatus IN ('0','1')
					AND        DateEffective <= '#url.selection#'
					ORDER BY DateEffective DESC					
			  </cfquery>	
			  			  			  
			  <td style="min-width:80">#getContract.ContractLevel#</td>
			  <td style="min-width:40"><cfif Incumbency eq "0">LI</cfif></td>
			  <td style="min-width:90">#dateformat(DateExpiration,client.dateformatshow)#</td>
			  
	  </tr>
		  
	  <tr id="row#personno#" class="hide">
	      <td></td>
	  	  <td colspan="5" style="padding-left:10px;border-top:1px solid gray;background-color:##f3f3f380" id="content#personno#"></td>
	  </tr>  
		  </cfloop>
	  
	  <!---
	  </div>
	  --->
	  
	  </td>
	  
	  </cfif>  
  
</tr>
 
<tr id="box#positionno#" class="hide"><td colspan="5" id="content#positionno#">
  
</cfoutput>

</cfoutput>

</table>
</td>
</tr>
</table>

<cfset ajaxOnLoad("doHighlight")>