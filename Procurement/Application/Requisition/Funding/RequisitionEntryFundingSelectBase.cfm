
<!--- <cfinclude template="RequisitionEntryFundingOrphan.cfm"> --->

<cfset fileNo = 1>

<cfparam name="URL.Period" default="FY 04/05">
<cfparam name="URL.Org"    default="0">
<cfparam name="URL.Job"    default="">
<cfparam name="URL.ID"     default="">

<input type="hidden" name="programperiod" value="<cfoutput>#url.period#</cfoutput>">

<!--- define expenditure periods --->

<cfquery name="Edition" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_AllotmentEdition
	WHERE  EditionId = (SELECT    EditionId
						FROM      Organization.dbo.Ref_MissionPeriod
						WHERE     Mission = '#URL.Mission#'
						AND       Period  = '#URL.Period#')
</cfquery>


<cfif Edition.Status eq "9">

    <cfoutput>
	<table width="100%" align="center">
		<tr>
			<td align="center"height="60" class="labelit">
			<font color="FF0000">Edition #Edition.description# has been blocked for execution.</font>
			</td>
		</tr>
	</table>
	</cfoutput>

	<cfabort>

</cfif>			

<!--- define if the edition is serving several other period for execution which have to
be included --->

<cfquery name="Expenditure" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    DISTINCT Period, AccountPeriod
	FROM      Ref_MissionPeriod
	WHERE     Mission = '#URL.Mission#'
	AND       EditionId IN (SELECT    EditionId
							FROM      Ref_MissionPeriod
							WHERE     Mission = '#URL.Mission#'
							AND       Period  = '#URL.Period#')  
</cfquery>

<cfset persel = "">
<cfset peraccsel = "">

<cfloop query="Expenditure">

	  <cfif persel eq "">
	     <cfset persel = "'#Period#'"> 
		 <cfset peraccsel = "'#AccountPeriod#'"> 
	  <cfelse>
	     <cfset persel = "#persel#,'#Period#'">
		 <cfset peraccsel = "#peraccsel#,'#AccountPeriod#'"> 
	  </cfif>
  
</cfloop>

<cfif persel eq "">

	<cf_message message="Problem : The is no allotment edition defined for period <cfoutput>#url.Period#</cfoutput>. Please contact your administrator">
	<cfabort>

</cfif>

<cfif URL.Job eq "">

    <cfif len(URL.Org) gt 20>
	
		<cfquery name="Per" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM   Ref_MissionPeriod
			WHERE  Mission = '#URL.Mission#'
			AND    Period  = '#URL.Period#'    
		</cfquery>
	
		<cfquery name="Unit" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 SELECT *
			 FROM   Organization
			 WHERE  Mission   = '#URL.Mission#'
			 AND    MandateNo = '#Per.MandateNo#'
			 AND    MissionOrgUnitId = '#URL.Org#'  
	    </cfquery>
		
		<cf_OrganizationSelect OrgUnit = "#Unit.OrgUnit#">  
		
	<cfelse>	
	
		<cf_OrganizationSelect OrgUnit = "#URL.Org#">  
	
	</cfif>
	
</cfif>	

<cfquery name="getfund" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
     SELECT Fund 
	 FROM   Purchase.dbo.RequisitionlineFunding 
	 WHERE  Requisitionno = '#url.id#'
	 AND    ProgramPeriod = '#url.period#'   
</cfquery>	 		

<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   E.*, 
	         EF.Fund, 
			 F.Description as FundDescription
	FROM     Ref_AllotmentEdition E, 
	         Ref_AllotmentEditionFund EF, 
			 Ref_Fund F
	WHERE    E.EditionId = EF.EditionId
	AND      F.Code = EF.Fund
	AND      (
	         E.EditionId IN (SELECT  EditionId
	                  	     FROM    Organization.dbo.Ref_MissionPeriod P
						     WHERE   Mission  = '#URL.Mission#' 
							 AND     Period   = '#URL.Period#'
						    )
			  <!--- added --->				
			 OR
			 E.EditionId IN (SELECT  EditionIdAlternate
	                  	     FROM    Organization.dbo.Ref_MissionPeriod P
						     WHERE   Mission  = '#URL.Mission#' 
							 AND     Period   = '#URL.Period#'
						    )			  			 
			 )
	<!--- 18/2 removed as this limited the ability to change : reported by Kristina
	
	<cfif getFund.recordcount gte "2">	 
	AND     Fund IN (SELECT Fund 
	                 FROM   Purchase.dbo.RequisitionLineFunding 
					 WHERE  Requisitionno = '#url.id#'
					 AND    ProgramPeriod = '#url.Period#')		
	</cfif>
						  
	--->
	
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#URL.Mission#'
</cfquery>

<!--- ---------------------------------------------------------------------------- --->
<!--- ------------5/10/2009 added validation triggered by payroll update --------- --->
<!--- validation if there is data in execution under a different object code class --->
<!--- ---------------------------------------------------------------------------- --->

<cfquery name="Version" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_AllotmentVersion
	WHERE     Code = '#Edition.version#'
</cfquery>	

<cfquery name="Validate" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT Code 
	FROM   Ref_Object 
	WHERE  ObjectUsage != '#Version.ObjectUsage#' 
	 AND   Code IN
                   (SELECT DISTINCT LF.ObjectCode
				    FROM   Purchase.dbo.RequisitionLine L, Purchase.dbo.RequisitionLineFunding LF
			        WHERE  L.RequisitionNo = LF.RequisitionNo
					AND    L.ActionStatus != '9'
					AND    L.Mission          = '#URL.Mission#'										
					AND    LF.ProgramPeriod   = '#URL.Period#'		      
				   )		
	ORDER BY Code			     
</cfquery>

<!--- ----------------------------------------------------------------------- --->
<!--- ----------------------------------------------------------------------- --->
<!--- ----------------------------------------------------------------------- --->

<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">

<cfif Validate.recordcount gte "1">
    	
	<tr><td colspan="9" class="labelmedium" height="38" align="center"><font color="FF0000"><b><cf_tl id="Alert"></b>:</font> <font color="0080C0"><cf_tl id="Execution has one or more object of Expenditires recorded"> <cf_tl id="which are associated to a different object usage class">
		<cfoutput query="validate">#Code#,</cfoutput>
	</td></tr>	   
	
</cfif>

<!--- -------------- --->
<!--- overall totals --->
<!--- -------------- --->

<cfset spc = 12>	

<!--- -------------------------------------------------------------------------------------------------------- --->
<!--- Now determine which budget data to use for this edition asd the edition can be planned for in different
budget planning period which is not the same as the period of the execution --->
<!--- -------------------------------------------------------------------------------------------------------- --->

<cfquery name="MissionPeriod" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_MissionPeriod
		WHERE  Mission = '#url.Mission#'
		AND    Period = '#url.period#' 
</cfquery>	
					
<cfset per = MissionPeriod.PlanningPeriod>


<!--- ---------------------------------------------- --->
<!--- ------create table with allotment info-------- --->
<!--- ---------------------------------------------- --->

<cfif edition.editionid eq "">

	<tr>
	<td height="60" align="center" class="labelmedium">
	<font color="0080FF">Problem, edition was not determined for this execution period</font></td>
	</tr>
	
	<cfabort>

</cfif>

<cfif url.org neq "">

	<cfquery name="Org" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
 			SELECT  * 
			FROM    Organization 
			WHERE   OrgUnit = '#url.org#'
	</cfquery>	
	
	<cfset hierbase    = org.hierarchyCode>
	<cfset orgnamebase = Org.OrgUnitName>		
	
	<cfif Parameter.FundingClearRollup eq "0">
	
		<cfset hier      = hierbase>
		<cfset orgname   = orgnamebase>	
		<cfset showmode  = "standard">	
		
	<cfelseif Org.ParentOrgunit eq "" or Org.Autonomous eq "1" or Parameter.FundingClearRollup eq "1">
	
	    <!--- --------------------- --->
		<!--- this is the top level --->
		<!--- --------------------- --->
		
		<!--- find the top level --->
		
		<tr><td colspan="10" style="font-size:32px;height:60px" class="labellarge"><cf_tl id="Available Budget"></td></tr>
		
		<cfset hier     = org.hierarchyCode>
		<cfset orgname  = Org.OrgUnitName>
		<cfset showmode = "total">
				
		<cfinclude template="RequisitionEntryFundingContentTotal.cfm">		
		<cfinclude template="RequisitionEntryFundingContentData.cfm">				
			
		<cfset hier      = hierbase>
		<cfset orgname   = orgnamebase>	
		<cfset showmode  = "standard">
	
	<cfelse>
	
		<!--- find the top level --->
		
		<tr><td colspan="10" style="font-size:32px;height:60px" class="labellarge"><cf_tl id="Available Budget"></td></tr>
		
		<cfset top = 0>
				
		<cfloop condition="#top# neq 1">
		
			<cfquery name="Org" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   Organization 
				WHERE  Mission     = '#org.Mission#' 
				AND    MandateNo   = '#org.MandateNo#'
				AND    OrgUnitCode = '#org.ParentOrgUnit#'
			</cfquery>	
			
			<cfif Org.ParentOrgunit eq "" or Org.Autonomous eq "1">
			
			    <!--- this is the base --->
			
				<cfset hier     = org.hierarchyCode>
				<cfset orgname  = Org.OrgUnitName>
				<cfset showmode = "total">
				
				<cfinclude template="RequisitionEntryFundingContentTotal.cfm">
				<!--- limited showing of data --->
				<cfinclude template="RequisitionEntryFundingContentData.cfm">
				
				<!--- stop loop --->
				<cfset top = 1>
				
			</cfif>
				
		</cfloop>
		
		<cfset showmode = "standard">
		<cfset hier    = hierbase>
		<cfset orgname = orgnamebase>	
		
	</cfif>
		
<cfelse>
	
	<cfset hier     = "">	
	<cfset orgname  = "">
	<cfset showmode = "standard">
	
</cfif>

<cfinclude template="RequisitionEntryFundingContentTotal.cfm">
<cfinclude template="RequisitionEntryFundingContentData.cfm">

<script>
	Prosis.busy('no');
</script>

<cfset ajaxonload("doHighlight")>

</table>
