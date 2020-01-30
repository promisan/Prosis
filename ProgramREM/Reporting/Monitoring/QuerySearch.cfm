<!--- Create Criteria string for query from data entered thru search form --->

<cfset LastFrom = "">
<cfset LastWhere = "">

<cfoutput>

<cfquery name="General" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass IN ('ProgramCode','ProgramName','ProgramGoal')
       </cfquery>
	   
<cfset #Personal# = "">
	   
<cfloop query="General">

    <cfset #Personal# = "AND P."&#General.SearchClass#&" LIKE '%"&#General.SelectId#&"%'">
   
</cfloop>	 

<!--- Mission --->
<cfquery name="SelectMission" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Mission'
</cfquery>

<cfif #SelectMission.recordCount# eq 0>
   <cfset nat = "">
<cfelse>
   <cfset nat = "AND O.Mission IN (SELECT SelectId FROM ProgramSearchLine WHERE SearchId = '#URL.ID#' AND SearchClass = 'Mission')">
</cfif>   
  
<!--- Activity Subperiod --->
<cfquery name="SelectSubPeriod" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'SubPeriod'
</cfquery>

<cfif #SelectSubPeriod.recordCount# eq 0>
	<cfset ProgressWhere = "">
	<cfset OtherTables = "">
<cfelse>
	<cfset OtherTables = ", ProgramActivityOutput O">
   <cfset ProgressWhere = "AND O.ProgramCode = Pe.ProgramCode AND O.ActivityPeriodSub = '#SelectSubPeriod.SelectId#' AND (O.RecordStatus != 9 or O.RecordStatus IS NULL)">
</cfif>   

<!--- progress status --->
<cfquery name="SelectStatus" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Status'
</cfquery>

<cfif #SelectStatus.recordCount# neq 0>
	<cfif #ProgressWhere# eq "">
		<cfset OtherTables = ", ProgramActivityProgress Pa">
		<cfset ProgressWhere = "AND Pa.ProgramCode = Pe.ProgramCode AND Pa.ProgressStatus = '#SelectStatus.SelectId#' AND (Pa.RecordStatus != 9  or Pa.RecordStatus IS NULL)">
	<cfelse>
		<cfset OtherTables = #OtherTables# & ", ProgramActivityProgress Pa">
		<cfset ProgressWhere = #ProgressWhere# & " AND O.OutputID = Pa.OutputID AND Pa.ProgressStatus = '#SelectStatus.SelectId#' AND (Pa.RecordStatus != 9 or Pa.RecordStatus IS NULL)">	
	</cfif>
</cfif>   


<!--- set up matching program period table based on output and activites filters --->

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#ProgressAll">	

  <cfquery name="ResultProgress" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT DISTINCT Pe.ProgramId, Pe.ProgramCode, Pe.OrgUnit
    INTO  userQuery.dbo.tmp#SESSION.acc#ProgressAll
    FROM  ProgramPeriod Pe #OtherTables#
	Where Pe.RecordStatus != 9
    #PreserveSingleQuotes(ProgressWhere)# 
  </cfquery>

<!--- Set up base table --->

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#ProgramAll">
   
   <cfquery name="ResultBase" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT DISTINCT Pe.ProgramId
    INTO  userQuery.dbo.tmp#SESSION.acc#ProgramAll
    FROM  Program P, userQuery.dbo.tmp#SESSION.acc#ProgressAll Pe, Organization.dbo.Organization O
    WHERE P.ProgramCode = Pe.ProgramCode
	AND   Pe.OrgUnit = O.OrgUnit
	#PreserveSingleQuotes(Personal)# 
	#PreserveSingleQuotes(Nat)# 
  </cfquery>
  
  
<!--- Category --->

<cfquery name="Select" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Category'
</cfquery>

<cfquery name="SelectA" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'CategoryOperator'
</cfquery>

<cfif #Select.RecordCount# gt 0>
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc#CATSelect">
   <cfset LastWhere = "WHERE tmp#SESSION.acc#CATSelect.ProgramId = tmp#SESSION.acc#ProgramAll.ProgramId">
   <!--- run queries --->
   <CF_QuerySearchCAT 
   FieldValue="#URL.ID#"
   FieldStatus="#SelectA.SelectId#"> 
</cfif>

<!--- Funding --->

<cfquery name="Select" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Funding' 
</cfquery>

<cfquery name="SelectA" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'FundingOperator'
</cfquery>

<cfset #src# = "FUN">

<cfif #Select.RecordCount# gt 0>
    <cfif #LastWhere# neq "">
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc##src#Select">
   <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc##src#Select.ProgramId = tmp#SESSION.acc#ProgramAll.ProgramId">
   <cfelse>
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc##src#Select">
   <cfset LastWhere = " WHERE tmp#SESSION.acc##src#Select.ProgramId = tmp#SESSION.acc#ProgramAll.ProgramId">
   </cfif>   
   <!-- run queries --->
   <CF_QuerySearchFUN
   FieldValue="#URL.ID#"
   FieldStatus="#SelectA.SelectId#"> 
</cfif>

<!--- Resource --->

<cfquery name="Select" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Resource'
</cfquery>

<cfquery name="SelectA" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'ResourceOperator'
</cfquery>

<cfset #src# = "RES">

<cfif #Select.RecordCount# gt 0>
    <cfif #LastWhere# neq "">
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc##src#Select">
   <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc##src#Select.ProgramId = tmp#SESSION.acc#ProgramAll.ProgramId">
   <cfelse>
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc##src#Select">
   <cfset LastWhere = " WHERE tmp#SESSION.acc##src#Select.ProgramId = tmp#SESSION.acc#ProgramAll.ProgramId">
   </cfif>   
   <!-- run queries --->
   <CF_QuerySearchRES
   FieldValue="#URL.ID#"
   FieldStatus="#SelectA.SelectId#"> 
</cfif>

<!--- Period --->

<cfquery name="Select" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Period'
</cfquery>

<cfquery name="SelectA" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'PeriodOperator'
</cfquery>

<cfset #src# = "PER">

<cfif #Select.RecordCount# gt 0>
    <cfif #LastWhere# neq "">
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc##src#Select">
   <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc##src#Select.ProgramId = tmp#SESSION.acc#ProgramAll.ProgramId">
   <cfelse>
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc##src#Select">
   <cfset LastWhere = " WHERE tmp#SESSION.acc##src#Select.ProgramId = tmp#SESSION.acc#ProgramAll.ProgramId">
   </cfif>   
   <!-- run queries --->
   <CF_QuerySearchPER
   FieldValue="#URL.ID#"
   FieldStatus="#SelectA.SelectId#"> 
</cfif>

<!--- activity class --->

<cfquery name="Select" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Class'
</cfquery>

<cfquery name="SelectA" 
        datasource="AppsProgram" 
        username="#SESSION.login#" 
        password="#SESSION.dbpw#">
        SELECT *
		FROM ProgramSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'ClassOperator'
</cfquery>

<cfset #src# = "CLS">

<cfif #Select.RecordCount# gt 0>
    <cfif #LastWhere# neq "">
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc##src#Select">
   <cfset LastWhere = #LastWhere#&" AND tmp#SESSION.acc##src#Select.ProgramId = tmp#SESSION.acc#ProgramAll.ProgramId">
   <cfelse>
   <cfset LastFrom  = #LastFrom#&", tmp#SESSION.acc##src#Select">
   <cfset LastWhere = " WHERE tmp#SESSION.acc##src#Select.ProgramId = tmp#SESSION.acc#ProgramAll.ProgramId">
   </cfif>   
   <!-- run queries --->
   <CF_QuerySearchCLS
   FieldValue="#URL.ID#"
   FieldStatus="#SelectA.SelectId#"> 
</cfif>

<!--- Combine all searches --->

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#Final">	

<cfquery name="Result" 
       datasource="AppsQuery" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
	  SELECT DISTINCT '#URL.ID#' as SearchId, tmp#SESSION.acc#ProgramAll.ProgramId
	  INTO dbo.tmp#SESSION.acc#Final
	  FROM dbo.tmp#SESSION.acc#ProgramAll 
			#LastFrom#
	    #LastWhere#
</cfquery>

<!--- disabled Hanno 22/02/22 

<!--- now we have all programs but we also need to have the parent --->
<!--- to this table to have a complete picture --->

<cfloop index="i" from="1" to="2" step="1">

<cfquery name = "Component" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   INSERT INTO userQuery.dbo.tmp#SESSION.acc#Final
      (SearchId, ProgramId)
   SELECT DISTINCT '#URL.ID#' as SearchId, Pce.ProgramId
       FROM  userQuery.dbo.tmp#SESSION.acc#Final S, ProgramPeriod Pe, Program P, ProgramPeriod Pce
	   WHERE S.ProgramId = Pe.ProgramId
	   AND  Pe.ProgramCode = P.ProgramCode 
	   AND  Pe.RecordStatus != 9
	   AND  (P.ParentCode is not NULL and P.ParentCode <> '')
	   AND  P.ParentCode = Pce.ProgramCode
  </cfquery>  

</cfloop>

--->

<!--- Final Query --->

<cfquery name="Result" 
       datasource="AppsProgram" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
	   INSERT INTO ProgramSearchResult
	   (SearchId, ProgramId)
      SELECT DISTINCT '#URL.ID#', userQuery.dbo.tmp#SESSION.acc#Final.ProgramId
	  FROM   UserQuery.dbo.tmp#SESSION.acc#Final
</cfquery>

<!--- <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#ProgramAll">	 --->
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#Final">	


<script>

window.open("ResultView.cfm?ID=#URL.ID#&Mission=#URL.Mission#&IDForm=Search3.cfm", "_top"); 

</script>

</cfoutput>

