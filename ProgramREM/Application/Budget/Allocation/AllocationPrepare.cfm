

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Object">	

<!--- A. to map object code to their parent code --->

<cfquery name="ObjectParentMapping"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  Code,ParentCode,ListingOrder,Description
	INTO    userQuery.dbo.#SESSION.acc#Object
	FROM    Ref_Object
	WHERE   ParentCode IN (SELECT Code FROM Ref_Object)
	AND     ObjectUsage = '#Edition.ObjectUsage#' 
	
	UNION  
		
	<!--- get codes that are a parent itself --->
	
	SELECT  Code,Code as ParentCode,ListingOrder,Description
	FROM    Ref_Object
	
	WHERE   (ParentCode NOT IN (SELECT Code FROM Ref_Object) OR ParentCode is NULL)
	AND     ObjectUsage = '#Edition.ObjectUsage#'  
	
</cfquery>  

<!--- B. create tables with budget cleared and uncleared ------ --->	

<cfinvoke component = "Service.Process.Program.Execution"  
	method          = "Budget" 
	period          = "#url.period#" 
	mission         = "#Edition.mission#"				 
	Status          = "0" 	
	ObjectParent    = "1"     		 
	editionid       = "#url.EditionId#"
	Table           = "#SESSION.acc#_AllRequirement">
	   
<!--- table generate with expenditures --->  
 
<cfquery name="Expenditure" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  DISTINCT Period, AccountPeriod
	FROM    Ref_MissionPeriod
	WHERE   Mission   = '#Edition.Mission#'
	AND     EditionId = '#url.editionid#'			
</cfquery>

<cfset per = "">
<cfset peraccsel = "">

<cfloop query="Expenditure">

  <cfif per eq "">
     <cfset per = "'#Period#'"> 
	 <cfset peraccsel = "'#AccountPeriod#'"> 
  <cfelse>
     <cfset per = "#per#,'#Period#'">
	 <cfset peraccsel = "#peraccsel#,'#AccountPeriod#'"> 
  </cfif>
  
</cfloop>

<!--- C. precreation expenditure info on the level of the program ------ --->	
			   
<cfinvoke component = "Service.Process.Program.Execution"  
   method           = "Requisition" 
   mission          = "#edition.mission#"			   
   period           = "#per#" 			   
   Content          = "sum"
   ObjectParent     = "1"   
   status           = "formal"		 
   Table            = "#SESSION.acc#_AllReservation">	
   
<cfinvoke component = "Service.Process.Program.Execution"  
   method           = "Obligation" 
   mission          = "#edition.mission#"			  
   period           = "#per#" 	   
   Content          = "sum"
   ObjectParent     = "1"   
   Scope            = "Unliquidated"		  
   Table            = "#SESSION.acc#_AllObligation">					   

<cfinvoke component = "Service.Process.Program.Execution"  
   method           = "Disbursement" 
   mission          = "#edition.mission#"		  
   period           = "#per#" 
   ObjectParent     = "1"   
   accountperiod    = "#peraccsel#"		  	  
   Content          = "sum"		 
   Table            = "#SESSION.acc#_AllDisbursed">					   