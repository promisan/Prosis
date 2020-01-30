
<cfparam name="url.execution" default="">

<cfset FileNo = round(Rand()*100)>

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Object_#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Allotment_#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Allotment1_#FileNo#">
<cfparam name="LanPrefix" default="#LanPrefix#">

<!--- disabled for now 
<cfinclude template="../AllotmentView/MigrateYTD.cfm"> 
--->

<!--- identify object of expenditure structure based on the 
defined object class for the tree --->

<cfquery name="Mis" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Mission 
	WHERE  Mission = '#Mission.Mission#' 
</cfquery>

<cfquery name="Parameter" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission 
	WHERE  Mission = '#Mission.Mission#' 
</cfquery>

<cfquery name="EditionFund" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   EditionId, 
	         ltrim(rtrim(Fund)) as Fund,
			  <!--- edition is defined as executor for this period --->
			 (SELECT TOP 1 EditionId 
			  FROM   Organization.dbo.Ref_MissionPeriod P
			  WHERE  Mission        = '#Mission.Mission#' 
			  AND    PlanningPeriod = '#url.period#' 
			  AND    EditionId      = R.EditionId
			   <!--- edition is not disabled for this --->
			  AND    EditionId IN (SELECT EditionId 
			                       FROM   Ref_AllotmentEdition 
								   WHERE  ControlExecution = 1
								   AND    EditionId = P.EditionId)
			  ) as Execution  
			  <!--- edition is defined as executor for this period --->
	FROM     Ref_AllotmentEditionFund R
	WHERE    R.EditionId IN (#editionlist#)	
	<cfif url.fund neq "">
	AND      R.Fund = '#URL.Fund#'
	</cfif>
	ORDER BY R.EditionId,R.Fund  
</cfquery>

<cfif EditionFund.recordcount eq "0">

	<cf_message message="Problem, this edition has no funds associated. Please contact your administrator.">
	<cfabort>

</cfif>

<cfoutput query="EditionFund" group="EditionId">

	<cfset list = "">
	<cfoutput>
		<cfif list eq "">
			<cfset list = "#fund#"> 
		<cfelse>
		    <cfset list = "#list#,#fund#"> 
		</cfif>		
	</cfoutput>	
	<cfparam name="list_#editionid#" default="#list#">

</cfoutput>

<cfset exec = "">

<cfquery name="Object" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     R.Code as Resource,
	           R.Description as Category, 
	           R.ListingOrder as CategoryOrder, 
			   O.Code, 
			   O.RequirementEnable,
			   ParentCode, 
			   O.Description AS Description, 
			   O.CodeDisplay,
			   O.ListingOrder,
			   O.HierarchyCode,
			   (SELECT count(*) FROM Ref_Object WHERE ParentCode = O.Code) as isParent
	INTO       UserQuery.dbo.#SESSION.acc#Object_#FileNo#
	FROM       #LanPrefix#Ref_Object O INNER JOIN
	           #LanPrefix#Ref_Resource R ON O.Resource = R.Code
	WHERE	   ObjectUsage = '#Version.ObjectUsage#' 	
	ORDER BY O.ListingOrder
	
	<!--- disabled for OICT temp only 
	<cfif ObjectFilter eq "1">
	AND  (
		      O.Code IN (SELECT ObjectCode FROM Purchase.dbo.ItemMaster WHERE Operational = 1)	
		      OR
	    	  O.Code IN (SELECT ObjectCode FROM ProgramAllotmentDetail WHERE EditionId IN (#editionlist#))
		  )
	</cfif>
	--->
	   
</cfquery>

<!--- create a container for the budget amounts --->

<cfquery name="Create"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	CREATE TABLE dbo.#SESSION.acc#Allotment_#FileNo# (
    [ObjectCode] [varchar] (10) NULL,		
    <cfloop query="editionfund">	
	 [Blocked_#EditionId#_#fund#] [integer] DEFAULT (0), 
     [Edition_#EditionId#_#fund#] [float] NULL DEFAULT (0),
    </cfloop>
	<cfloop query="edition">	 
     [Edition_#EditionId#_total] [float] NULL DEFAULT (0), 
    </cfloop>
	[Total] [float] NULL DEFAULT (0))
</cfquery>

<cfloop query="editionfund">
	
	<!--- insert entry table per edition from the source tables--->
	      
    <cfset planperiod = evaluate("e#editionid#planperiod")>	  
	  	  
	<cfquery name="Allotment" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		INSERT INTO userQuery.dbo.#SESSION.acc#Allotment_#FileNo#
				(ObjectCode,
				 Blocked_#EditionId#_#fund#,
				 Edition_#EditionId#_#fund#)
		SELECT   ObjectCode, 
		        
				 
		         (SELECT count(*) 
				  FROM   ProgramAllotmentRequest 
				  WHERE    ProgramCode = '#URL.Program#'
				  AND      Period      = '#planperiod#'
				  AND      EditionId   = '#EditionId#'
			  	  AND      Fund        = '#Fund#'
				  AND      ObjectCode  = P.ObjectCode				  
				  AND      ActionStatus = '0') as Blocked,
				  
				  SUM(Amount) as Amount
				 
				 
		FROM     ProgramAllotmentDetail P
		WHERE    ProgramCode = '#URL.Program#' 
		AND      Period      = '#planperiod#'
		AND      Fund        = '#Fund#'		
		AND      EditionId   = '#EditionId#'
		AND      Status IN ('0','1','P')	<!--- we take the adjustment amount here 6/4/2015 Status IN ('P','0','1') --->
		GROUP BY ObjectCode, Fund
		
	</cfquery>			
	
	<!---
<cfoutput>#cfquery.executiontime#</cfoutput>
--->
	
</cfloop>

<!--- now create compressed table key object --->

<cfquery name="AllotmentObject" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT  ObjectCode, 	
	        
	        <cfloop query="editionfund">
			    SUM(Blocked_#EditionId#_#fund#) as Blocked_#EditionId#_#fund#,
		        SUM(Edition_#EditionId#_#fund#) as Edition_#EditionId#_#fund#,
				<cfif execution neq "">				
					cast(0.00 as float) as Requisition_#EditionId#_#fund#,
					cast(0.00 as float) as Obligation_#EditionId#_#fund#,					
					cast(0.00 as float) as Disbursement_#EditionId#_#fund#,							
					<cfif not find(execution,exec)>
						<cfif exec eq "">
						    <cfset exec = execution>		
						<cfelse>
							<cfset exec = "#exec#,#execution#">							
						</cfif>	
					</cfif>
				</cfif>					
	        </cfloop>
			
			<cfloop query="edition">
				Sum(Edition_#EditionId#_total) as Edition_#EditionId#_total,	
				<cfif find(editionid,exec)>
				cast(0.00 as float) as Requisition_#EditionId#_total,
				cast(0.00 as float) as Obligation_#EditionId#_total,				
				cast(0.00 as float) as Disbursement_#EditionId#_total,			
				</cfif>													
			</cfloop>
			
			cast(0.00 as float) as Total 							 
			
	INTO    dbo.#SESSION.acc#Allotment1_#FileNo#	
	FROM    #SESSION.acc#Allotment_#FileNo#	 
	GROUP BY ObjectCode
		
</cfquery>

<cfquery name="Subtotals" 
   datasource="AppsQuery" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
       UPDATE #SESSION.acc#Allotment1_#FileNo#	
	   SET 
	   <cfloop query="Edition"> 
	   	
			<cfquery name="Fund"  dbtype="query">
				SELECT  Fund FROM EditionFund WHERE EditionId = #Edition.editionid#
		    </cfquery>	
			
   		Edition_#EditionId#_Total = 0 <cfloop query="fund">+ Edition_#Edition.EditionId#_#fund#</cfloop>
		<cfif currentrow neq recordcount>,</cfif>
	   </cfloop>	
</cfquery>	

<cfquery name="Total" 
   datasource="AppsQuery" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   UPDATE #SESSION.acc#Allotment1_#FileNo#	
	   SET    Total = Total <cfloop query="edition">+ Edition_#EditionId#_Total </cfloop> 	   
</cfquery>

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Allotment_#fileNo#"> 

<!--- now merge with object structure for the interface --->
 
<cfquery name="SearchResult" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	INTO     dbo.#SESSION.acc#Allotment_#FileNo#
	FROM     #SESSION.acc#Object_#fileNo# LEFT OUTER JOIN
	         #SESSION.acc#Allotment1_#fileNo# ON #SESSION.acc#Object_#fileNo#.Code = #SESSION.acc#Allotment1_#fileNo#.ObjectCode
	ORDER BY CategoryOrder, ListingOrder, Code 		   
</cfquery>

<cfif url.execution eq "hide">
	<cfset exec = "">
</cfif>

<cfloop index="itm" list="#exec#" delimiters=",">

	<!--- for each edition which is determined an executer for the planning period we define the 
	related periods that contain execution data for all populate requisition, 
	obligation, disbursement --->
	<!--- ---------------------------------------------- --->
	
	<cfquery name="Expenditure" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 
	SELECT    DISTINCT Period, AccountPeriod
	FROM      Ref_MissionPeriod
	WHERE     Mission = '#Mission.Mission#'
	AND       EditionId = '#itm#'	
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
	
	<cfinvoke component = "Service.Process.Program.Execution"  
			   method           = "Requisition" 
			   mission          = "#mission.mission#"
			   programCode      = "#url.program#"
			   currency         = "#parameter.budgetcurrency#"
			   period           = "#persel#" 
			   mode             = "table"
			   table            = "#SESSION.acc#Requisition_#fileNo#">	
			   
	<cfif Mis.ProcurementMode eq "0">
		
		<cfinvoke component = "Service.Process.Program.Execution"  
			   method            = "Disbursement" 
			   mission           = "#mission.mission#"
			   programCode       = "#url.program#"
			   currency         = "#parameter.budgetcurrency#"
			   period            = "#persel#" 
			   accountperiod     = "#peraccsel#"	  
			   TransactionSource = "'Obligation'"
			   mode              = "table"
			   table             = "#SESSION.acc#Obligation_#fileNo#">	
			
	
	<cfelse>		   	 
			   
		<cfinvoke component = "Service.Process.Program.Execution"  
				   method           = "Obligation" 
				   mission          = "#mission.mission#"
				   currency         = "#parameter.budgetcurrency#"
				   programCode      = "#url.program#"
				   period           = "#persel#" 
				   mode             = "table"
				   table            = "#SESSION.acc#Obligation_#fileNo#">		   	
			   
	</cfif>		   
			   
	<cfinvoke component = "Service.Process.Program.Execution"  
			   method           = "Disbursement" 
			   mission          = "#mission.mission#"
			   currency         = "#parameter.budgetcurrency#"
			   programCode      = "#url.program#"
			   period           = "#persel#" 
			   accountperiod    = "#peraccsel#"	  
			   mode             = "table"
			   table            = "#SESSION.acc#Invoice_#fileNo#">	
			
			   
			   	
	<cfquery name="FundExec" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   EditionId, 
		         ltrim(rtrim(Fund)) as Fund
		FROM     Ref_AllotmentEditionFund R
		WHERE    R.EditionId = #itm#		
	</cfquery>		   
			   	
	<cfquery name="SetExecution" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 UPDATE #SESSION.acc#Allotment_#FileNo#	
		 SET    
	 		<cfloop query="fundexec">		   		
	 			Requisition_#EditionId#_#fund#     = (SELECT SUM(ReservationAmount)   FROM #SESSION.acc#Requisition_#fileNo# WHERE ObjectCode = F.Code and Fund = '#Fund#'),
				Obligation_#EditionId#_#fund#      = (SELECT SUM(ObligationAmount)    FROM #SESSION.acc#Obligation_#fileNo#  WHERE ObjectCode = F.Code and Fund = '#Fund#'),							
				Disbursement_#EditionId#_#fund#    = (SELECT SUM(InvoiceAmount)       FROM #SESSION.acc#Invoice_#fileNo#     WHERE ObjectCode = F.Code and Fund = '#Fund#'),																	
			</cfloop>	
			Requisition_#itm#_total     = (SELECT SUM(ReservationAmount) 
			                               FROM   #SESSION.acc#Requisition_#fileNo# 
										   WHERE  ObjectCode = F.Code),
			Obligation_#itm#_total      = (SELECT SUM(ObligationAmount) 
			                               FROM   #SESSION.acc#Obligation_#fileNo# 
										   WHERE  ObjectCode = F.Code),							
			Disbursement_#itm#_total    = (SELECT SUM(InvoiceAmount) 
			                               FROM   #SESSION.acc#Invoice_#fileNo# 
										   WHERE  ObjectCode = F.Code)				
			  		   	  
		 FROM #SESSION.acc#Allotment_#FileNo# F	
		      	  		   
	 </cfquery>
	 
		 	 
	 <CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Requisition_#fileNo#">
	 <CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Obligation_#fileNo#">
	 <CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Invoice_#fileNo#">
	 
</cfloop> 
 
<cfif url.view eq "hidenull">

	<cfquery name="Allotment" 
	   datasource="AppsQuery" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   DELETE FROM #SESSION.acc#Allotment_#FileNo#		  
	   WHERE  Total is NULL or Total = 0
     </cfquery>
 
<cfelseif url.view eq "Parent">

    <!---
	<cfquery name="Allotment" 
	   datasource="AppsQuery" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   DELETE FROM #SESSION.acc#Allotment_#FileNo#		  
	   WHERE  ParentCode != ''
	</cfquery>
	--->

</cfif>

<cfquery name="Allotment" 
	   datasource="AppsQuery" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   UPDATE #SESSION.acc#Allotment_#FileNo#	
	   SET    Total = 0
	   WHERE  Total is NULL
 </cfquery> 
     
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Object_#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Allotment1_#FileNo#"> 
