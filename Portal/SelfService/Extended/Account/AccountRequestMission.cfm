
<cfparam name="url.application" default="">

<cfparam name="url.id"        default="">

<cfquery name="getPortal" 
	datasource="appsSystem"> 
	SELECT   *
	FROM     Ref_ModuleControl
	WHERE    FunctionName  = '#URL.ID#' 
	AND      FunctionClass = 'Selfservice' 
	AND      SystemModule  = 'Selfservice'
</cfquery>


<cfquery name="GetMission" 
		 datasource="AppsOrganization">
			SELECT    DISTINCT UPPER( M.MissionType ), 
			          MM.Mission
			FROM      Ref_MissionModule MM INNER JOIN Ref_Mission M ON MM.Mission = M.Mission
			WHERE     SystemModule IN (
					  	  SELECT SystemModule
						  FROM   System.dbo.Ref_ApplicationModule
						  WHERE  Code = '#url.application#'
						)
			AND       M.MissionStatus = '0'
			AND       M.Operational = 1											
			<cfif getPortal.Functioncondition neq "">					
			AND       M.Mission = '#GetPortal.FunctionCondition#'							
			</cfif> 			
			ORDER BY  UPPER( M.MissionType) 
</cfquery>

<cfif getMission.recordcount eq "0">
	
	<cfquery name="GetMission" 
			 datasource="AppsOrganization">
				SELECT    DISTINCT UPPER( M.MissionType ), 
				          MM.Mission
				FROM      Ref_MissionModule MM INNER JOIN Ref_Mission M ON MM.Mission = M.Mission
				WHERE     SystemModule IN (
						  	  SELECT SystemModule
							  FROM   System.dbo.Ref_ApplicationModule
							  WHERE  Code = '#url.application#'
							)
				AND       M.MissionStatus = '0'
				AND       M.Operational = 1														
				ORDER BY  UPPER( M.MissionType) 
	</cfquery>

</cfif>


<cfif GetMission.recordcount eq 1> 

	<script>
	  document.getElementById('missionbox').className = "hide"
	</script>

	<select name="Mission" id="Mission" class="regularxl">		
		<cfoutput query="GetMission">
			<option value="#Mission#" selected>#Mission#</option>
		</cfoutput>
	</select>

<cfelse>

	<script>
	  document.getElementById('missionbox').className = "regular"
	</script>

	<select name="Mission" id="Mission" class="regularxl">
		<option value="">[Select]</option>
		<cfoutput query="GetMission">
			<option value="#Mission#">#Mission#</option>
		</cfoutput>
	</select>

</cfif>

