
<cfparam name="url.mission" default="">

<script>
 document.getElementById('filtercontent').className = "hide"
</script>

<cfquery name="Param" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT * 
	  FROM   Ref_ParameterMission
	  WHERE  Mission = '#URL.Mission#'
</cfquery>


<cfparam name="url.mandate" default="">
<cfparam name="man" default="#url.mandate#">

<cfinvoke component="Service.AccessGlobal"  
      method="global" 
	  role="AdminProgram" 
	  returnvariable="GlobalAccess">
		
<cfinvoke component="Service.Access"
	   Method="Organization"
	   Mission="#URL.Mission#"
	   Role="ContributionOfficer','ContributionManager"
	   ReturnVariable="MissionAccess">		   
					   			
<cfset CLIENT.ShowReports = "YES">

<cfform>

<cf_tl id="Contributions" var="vContributions">

<table width="100%">

<tr><td>

<cfquery name="PeriodList" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
   	  SELECT    R.*, M.MandateNo, M.DefaultPeriod
	  FROM      Ref_Period R, Organization.dbo.Ref_MissionPeriod M	 
	  WHERE     IncludeListing = 1
	  AND       (R.isPlanningPeriod = 1 OR M.isPlanPeriod = 1)
	  AND       M.Mission = '#URL.Mission#' 
	  AND       R.Period = M.Period
	  ORDER BY  DateEffective 
</cfquery>

<cfset per = "">

<table>
<tr>
	<td class="labelit" style="padding-left:3px"><cf_tl id="Enabled for">:</td>
	<td style="padding-left:4px">
		<select id="period" name="period" class="regularxl">
			<option value=""><cf_tl id="Any"></option>
			<cfoutput query="PeriodList">
				<option value="#Period#" <cfif defaultPeriod eq "1">selected</cfif>>#Period#</option>
				
				<cfif defaultPeriod eq "1">
				    <cfset per = period>
				</cfif>
			</cfoutput>
		</select>
	</td>
</tr>
</table>

</td></tr>

<tr><td class="linedotted" style="padding-top:4px">
 	
<cfif GlobalAccess neq "NONE" 
     OR MissionAccess eq "READ" OR MissionAccess eq "EDIT" or MissionAccess eq "ALL">
	 		
 	   <cf_UItree name="idtree" format="html" required="No">
	  	  	   
		   <cf_UItreeitem 
			  bind="cfc:service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#url.mission#','P001','../Donor/Listing/DonorViewListing.cfm','DON','#vContributions#','#Param.TreeDonor#','P001',{period},'Full','0','&systemfunctionid!#url.systemfunctionid#')">  		 
	    </cf_UItree>		

<cfelse>
	
	    <cftree name="idtree" format="html" required="No">
			  <cftreeitem 
				  bind="cfc:service.Tree.OrganizationTree.getNodes({cftreeitempath},{cftreeitemvalue},'#url.mission#','P001','../Donor/Listing/DonorViewListing.cfm','DON','#vContributions#','#Param.TreeDonor#','P001',{period},'role','0','&systemfunctionid!#url.systemfunctionid#')">  		 
        </cftree>		
    
</cfif> 

</td></tr>

</table>

</cfform>