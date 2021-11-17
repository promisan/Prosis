<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM  Organization
	WHERE Mission   = '#URL.Mission#'
	AND   MandateNo = '#URL.Mandate#'
	AND  (HierarchyCode = '' or HierarchyCode is NULL)
	
</cfquery>

<cfif Check.recordcount gt "5">   
   <cfinclude template="../../../../System/Organization/Application/OrganizationHierarchy.cfm">
</cfif>

<cf_tl id="Progress" var="1">
<cfset tProgress = "#Lt_text#">

<cf_tl id="of" var="1">
<cfset tof = "#Lt_text#">

<cfoutput>

<script>

function reloadForm(page,view,layout,global) {
   try {
   lv = document.getElementById("find").value
   } catch(e) { lv = '' } 
   ptoken.location('ProgramViewGeneral.cfm?find='+lv+'&ProgramClass=#URL.ProgramClass#&ProgramGroup=#URL.ProgramGroup#&ReviewCycleId=#URL.ReviewCycleId#&Period=#URL.Period#&ID=#URL.ID#&ID1=#URL.ID1#&Global=' + global + '&Page=' + page + '&View=' + view + '&Lay=' + layout + '&Mandate=#URL.Mandate#&Mission=#URL.Mission#&Mode=#URL.Mode#')
}

</script>	

</cfoutput>

<input type="hidden" name="mission" value="<cfoutput>#URL.Mission#</cfoutput>">

   <cfquery name="DisplayPeriod" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
    	SELECT * 
		FROM   Ref_Period 
		WHERE  Period='#URL.Period#'
   </cfquery>     
   	
   <cfquery name="Root" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT *
	   FROM #CLIENT.LanPrefix#Organization
	   WHERE 1=1
	     <cfif url.id1 neq "Tree">
	     AND OrgUnitCode = '#Org.HierarchyRootUnit#'
		 </cfif>
	     AND MandateNo   = '#URL.Mandate#'
	     AND Mission     = '#URL.Mission#'
   </cfquery>
     
   <cfquery name="Parameter" 
    datasource="AppsProgram" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
   </cfquery>
             
   <cfset n = "4">
   
   <cfif URL.ID1 neq "Tree">
	
	     <cf_OrganizationSelect  OrgUnit = "#url.id1#">
		 
   <cfelse>
   	 
		 <cfset HStart = "00">
		 <cfset HEnd   = "99">
		 <cfset OEnd   = "99">
			 	 
   </cfif> 
	 	 	 		 
   <cfif URL.View eq "Only">	
	    
		<cfset HEnd = "#HEnd#">
		<cfset OEnd = "#HStart#.">			
		
   <cfelseif URL.View eq "Prg">	
	
		<cfset HEnd = "#HEnd#">		
		<cfset OEnd = "#HStart#.">		
						
   <cfelse>
   
   		<cfset HEnd = "#HEnd#">	
	   	<cfset OEnd = "#HEnd#">		
		
   </cfif>
      
   <!--- ------------------ --->
   <!--- create a base file --->
   <!--- ------------------ --->
   
   <cfif URL.ID1 eq "Tree">
   	 <cfset OEnd   = "99">
   </cfif>	 
         
   <!--- ---------------------------------------------------------------------------------- --->     			
   <!--- determine the status of completion for projects ---------------------------------- --->
   <!--- this portion is heavy and we can limit it to run only each time when really needed --->
   <!--- ---------------------------------------------------------------------------------- --->		            

   <CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Progress#FileNo#">	     
   <cfset per = "ProgramPeriod">
            
   <cfinclude template="../../Tools/ProgramActivityStatus.cfm">		
         
   <CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#ActivityCompleted#FileNo#">	      
   
   <!--- ---------------------------------------------------------------------------------- --->
    				
   <!--- generate the final result table or view for the listing --->   
   
   <CF_DropTable dbName="AppsQuery"  tblName="tmp#SESSION.acc#Program#FileNo#">	
   <CF_DropTable dbName="AppsQuery"  tblName="tmp#SESSION.acc#Program">	
   
   <cfset filterprogramclass = "">
     
   <cfif url.id1 neq "tree">
   
	   <!--- ----------------------------------------------- --->
	   <!--- -------------- access to classes -------------- --->
	   <!--- ----------------------------------------------- --->
	   
	   <cfset filterprogramclass = "'Program'">
	  	   
	   <cfinvoke component="Service.Access"
			Method         = "organization"
			Mission        = "#URL.Mission#"
			OrgUnit        = "#url.id1#"
			Period         = "#URL.Period#"
			Role           = "ProgramOfficer"
			ClassParameter = "Component"
			ReturnVariable = "AccessComponent">			
	   
	   <cfif AccessComponent NEQ "NONE">
	   
		    <cfif filterprogramclass neq "">
			   	<cfset filterprogramclass = "#filterprogramclass#,'Component'">		 			
		   </cfif>
	   
	   </cfif>
	   
	   <cfinvoke component="Service.Access"
			Method         = "organization"
			Mission        = "#URL.Mission#"
			OrgUnit        = "#url.id1#"
			Period         = "#URL.Period#"
			Role           = "ProgramOfficer"
			ClassParameter = "Project"
			ReturnVariable = "AccessProject">			
	   
	   <cfif AccessProject NEQ "NONE">
	   
		    <cfif filterprogramclass neq "">
			   	<cfset filterprogramclass = "#filterprogramclass#,'Project'">		 			
		   </cfif>
	   
	   </cfif>
	   
   </cfif>
   
   <!--- -- check if this person has full access -- --->   
   
   <cfinvoke component="Service.Access"
			Method         = "organization"
			Mission        = "#URL.Mission#"			
			Period         = "#URL.Period#"
			Role           = "ProgramOfficer"			
			ReturnVariable = "AccessGlobal">	
			
   <!--- ------------------------------------------ --->					   								
																																							
   <cfquery name="ResultListing" 
         datasource="AppsProgram" 
         username="#SESSION.login#" 
         password="#SESSION.dbpw#">
		 
         SELECT DISTINCT P.ProgramCode, 
			        P.ProgramName, 
					Pe.PeriodHierarchy as ProgramHierarchy,  
				    Pe.OfficerLastName, 
					Pe.OfficerFirstName, 
					Pe.Created, 
					Pe.ProgramManager,
					Pe.Status as ProgramStatus,
			        Pe.PeriodParentCode as ParentCode,  <!--- was P.ParentCode --->
					P.ProgramClass, 
					P.ProgramScope, 
			        Pe.OrgUnit,
					O.OrgUnitNameShort as OrgUnitName, 
					LEFT(O.OrgUnitName,30) as OrgUnitNameLong,					
					Pe.Reference, 
					Pe.OrgUnitImplement, 
					Pe.ProgramId,  		
					Pe.RecordStatus,
					    
					(
					
		  			   SELECT   TOP 1 ClusterDescription
			           FROM     ProgramActivityCluster
					   WHERE    ProgramCode = P.ProgramCode
					   ORDER BY ListingOrder
						   
					) as ClusterDescription, 
											
					<!--- 1. determine if a project/program has one more more outputs for projects defined --->	
					
						(											
						    SELECT  count(*) as Output	
						    FROM    ProgramActivityOutput O, Program P
							WHERE   O.ProgramCode = P.ProgramCode
							AND     P.ProgramClass = 'Project'
							AND     O.ProgramCode = Pe.ProgramCode					    
							) as Output,
							
					<!--- 2. determine if a program has one more more indicators for programs defined --->	
						
						(
						
						  SELECT count(*) as Indicator
			     	      FROM   ProgramIndicator IND
						  WHERE  IND.ProgramCode = Pe.ProgramCode
						  AND    IND.Period      = Pe.Period
						
						 ) as Indicator,
									
					Act.WeightActivityTotal,
					Act.WeightActivityStarted as WeightStarted,
					Act.WeightActivity, 
					Act.WeightPending,
					
					<cfif URL.ReviewCycleId neq "">
					 (
					  SELECT TOP 1 C.ActionStatus
                        FROM   ProgramPeriodReview C
						WHERE  C.ProgramCode = Pe.ProgramCode
						AND    C.Period      = Pe.Period
						AND    C.ReviewCycleId = '#url.ReviewCycleId#'					
						) as ReviewCycleStatus,
					 
					</cfif>
					
					<!--- define if the unit is within the scope --->
					(SELECT OrgUnit 
					 FROM   Organization.dbo.Organization S
					 WHERE  OrgUnit = O.OrgUnit
					 AND    S.HierarchyCode >= '#HStart#' 
					 AND    s.HierarchyCode < '#HEnd#' 	    
					 ) AS ShowUnit,
					 
					<!--- define if the root unit is within the scope --->
					(SELECT OrgUnit 
					 FROM   Organization.dbo.Organization S
					 WHERE  S.OrgUnitCode       = O.HierarchyRootUnit
					 AND    S.MandateNo         = O.MandateNo
					 AND    S.Mission           = O.Mission
					 AND    S.HierarchyCode LIKE ('#HStart#%') 						    
					 ) AS ShowParent,  
					 	 					
					O.HierarchyCode
					
		<cfif url.mode eq "Progress">		
		  INTO      userQuery.dbo.tmp#SESSION.acc#Program#FileNo#
		<cfelseif url.lay eq "Listing">
		  INTO      userQuery.dbo.tmp#SESSION.acc#Program
		</cfif>			
						 
		 FROM   	ProgramPeriod Pe 
					INNER JOIN      Organization.dbo.Organization O ON O.OrgUnit = Pe.OrgUnit 
					INNER JOIN      #CLIENT.LanPrefix#Program P ON Pe.ProgramCode = P.ProgramCode 
					LEFT OUTER JOIN	userQuery.dbo.#SESSION.acc#BSCSummary#FileNo# Act ON P.ProgramCode = Act.ProgramCode 		 
      
	     WHERE  	Pe.OrgUnit IN (SELECT OrgUnit FROM Organization.dbo.Organization WHERE Mission = '#URL.Mission#')
		 AND        Pe.Period = '#URL.Period#' 	
		 AND        Pe.RecordStatus != 9
		 
		 <!--- general filter on orgunits added by Hanno --->
		 
		 <cfif accessGlobal eq "NONE">
		 
		 AND   (      Pe.OrgUnit IN (SELECT A.OrgUnit
						             FROM   Organization.dbo.OrganizationAuthorization A INNER JOIN Organization.dbo.Organization O ON O.OrgUnit = A.OrgUnit
						             WHERE  A.UserAccount = '#SESSION.acc#' 
						             AND    A.Mission     = '#Mission#'							  
						             AND    A.Role IN ('ProgramOfficer'))
					  OR
					  P.ProgramClass = 'Program'
			   )
			   
		 </cfif>
		
		 <!--- show only program classes to which the user has been granted access ---> 
		 <cfif filterProgramClass neq "">		
		 AND        P.ProgramClass IN (#preservesingleQuotes(filterProgramClass)#)
		 </cfif>		 		
		 		 		 
		 <cfif URL.ProgramGroup neq "All"> 
		    AND    ( Pe.ProgramCode IN (
			                          SELECT ProgramCode 
			                          FROM   ProgramGroup 
									  WHERE  ProgramGroup = '#URL.ProgramGroup#'
									  AND    ProgramCode  = Pe.ProgramCode) 
									  
					OR
				
				P.ProgramClass = 'Program'					
				)			 
									 
		 </cfif>	
		
				 
		 <cfif URL.ReviewCycleId neq "">
		 AND    ( Pe.ProgramCode IN (
                        SELECT ProgramCode
                        FROM   ProgramPeriodReview C
						WHERE  C.ProgramCode = Pe.ProgramCode
						AND    C.Period      = Pe.Period
						AND    C.ReviewCycleId = '#url.ReviewCycleId#'
						AND    C.ActionStatus NOT IN ('8','9')
						)
				OR
				
				P.ProgramClass = 'Program'					
				)
		 </cfif>
		 
		 <cfif url.find neq "">		 
		 AND     (
		           P.ProgramCode LIKE ('%#url.find#%') OR
				   Pe.Reference  LIKE ('%#url.find#%') OR 
				   P.ProgramName LIKE ('%#url.find#%')  				   
			     )		 
		 </cfif>					 
	   		 
		 <cfif URL.ProgramClass eq "Progress">
		 AND     P.ProgramClass IN ('Project')
		 <cfelseif URL.ProgramClass eq "Component">		
		 AND     P.ProgramClass IN ('Program', 'Component')
		 <cfelseif URL.ProgramClass eq "Project">
		 AND     P.ProgramClass IN ('Program', 'Project')
		 </cfif>
		 				  
		 ORDER BY Pe.PeriodHierarchy  		 
		 		 
   </cfquery>
      
   <!---	    
   <cfoutput>3.#now()#:#cfquery.executionTime#<br></cfoutput>
   --->
   