
<!--- Query returning search results --->

<cfquery name="Org" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT *
   FROM   Organization
   WHERE  OrgUnit = '#URL.ParentUnit#' 
</cfquery>

<cfquery name="CurrentPeriod" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT   *
	 FROM     Ref_Period
	 WHERE    Period = '#URL.Period#'	
</cfquery>  

<cfquery name="GlobalNew" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT   P.ProgramCode, 
	         P.ProgramName, 
			 P.ProgramClass,
			 Pe.Reference
    FROM     Program P, ProgramPeriod Pe
	WHERE    P.ProgramCode = Pe.ProgramCode
	AND      Pe.Period = '#CurrentPeriod.period#' 
	AND      P.ProgramScope = 'Global'  <!--- need a provision to allow also to change the parent --->	
	AND      Pe.Reference > ''
	ORDER BY ListingOrder
	
</cfquery>

<cfparam name="url.prior" default="">

<cfif url.prior eq "">
	
	<cfquery name="Prior" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 SELECT    TOP 1 Pe.Period, R.Description
		 FROM      Program P INNER JOIN
	               ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode INNER JOIN
				   Organization.dbo.Organization O ON O.OrgUnit = Pe.OrgUnit  INNER JOIN
	               Ref_Period R ON Pe.Period = R.Period
		 WHERE     R.DateEffective < '#currentPeriod.DateEffective#'	
		 AND       O.Mission       = '#Org.Mission#'
		 AND       R.PeriodClass   = '#currentperiod.PeriodClass#'
		 ORDER BY  R.DateEffective DESC	 
	</cfquery>   
	
	<cfset priorperiod = prior.period>	

<cfelse>

	<cfparam name="priorperiod" default="#url.prior#">
		
</cfif>

<cfif priorperiod eq "">

	<table align="center">
	<tr><td class="labelmedium">
		<font color="FF0000">No prior period for the same class found, Please contact your administrator.</font>
	</td></tr>
	</table>
	<cfabort>

</cfif>
      
<cf_OrganizationSelect
     OrgUnit = "#URL.ParentUnit#"
	 Enforce="1">
				 		 		 
<cfinvoke component="Service.AccessGlobal"
     Method="global"
   	 Role="AdminProgram"
     ReturnVariable="ManagerAccess">	
	 
<cfinvoke component="Service.Access"
			Method="organization"
			OrgUnit="#URL.ParentUnit#"
			Period="#URL.Period#"
			ReturnVariable="OrgAccess">	
	
<cfif ManagerAccess is "EDIT" OR ManagerAccess is "ALL" or OrgAccess eq "ALL" or OrgAccess eq "EDIT">			 

	   <cfset OrgAccess = "ALL">
	   
	 	<cfquery name="SearchResult" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    DISTINCT O.*
			FROM      #CLIENT.LanPrefix#Organization O
			WHERE     O.Mission        = '#Org.Mission#'
			   AND    O.MandateNo      = '#Org.MandateNo#'
			   AND    O.HierarchyCode >= '#HStart#' 
			   AND    O.HierarchyCode < '#HEnd#'  
			ORDER BY  HierarchyCode
		</cfquery>
		
<cfelse>
	
		<table align="center">
		<tr><td class="labelit">
			<font color="FF0000"><cf_tl id="No access granted to perform task"></font>
		</td></tr>
		</table>
		<cfabort>		
		
</cfif>
		

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#ProgramPeriod"> 

<cfquery name="CheckPrior" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT   MandateNo
	 FROM     Ref_MissionPeriod
	 WHERE    Mission = '#Org.Mission#'
	 AND      Period = '#PriorPeriod#'  
</cfquery>

<cfquery name="CheckCurrent" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT   MandateNo
	 FROM     Ref_MissionPeriod
	 WHERE    Mission  = '#Org.Mission#'
	 AND      Period   = '#URL.Period#' 
</cfquery>
   
<!--- ----------------------------------------------- --->
<!--- -------------- access to classes -------------- --->
<!--- ----------------------------------------------- --->
	   
<cfset filterprogramclass = "'Program'">
	  	   
<cfinvoke component="Service.Access"
	Method         = "organization"
	Mission        = "#Org.Mission#"			
	Period         = "#URL.Period#"
	OrgUnit        = "some"
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
	Mission        = "#Org.Mission#"			
	Period         = "#URL.Period#"
	OrgUnit        = "some"
	Role           = "ProgramOfficer"
	ClassParameter = "Project"
	ReturnVariable = "AccessProject">			
  
<cfif AccessProject NEQ "NONE">
  
    <cfif filterprogramclass neq "">
	   	<cfset filterprogramclass = "#filterprogramclass#,'Project'">		 			
   </cfif>
  
</cfif>

<cfif CheckPrior.MandateNo neq CheckCurrent.MandateNo>

	<!--- on the fly convert ProgramPeriod to new org unit --->

	<cfquery name="ProgramPeriod" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT   Pe.ProgramCode, 
		          Pe.OrgUnitImplement, 
				  Pe.PeriodParentCode,
				  Pe.PeriodHierarchy,
				  
				  Pe.PeriodDescription,
				  Pe.PeriodGoal,
				  Pe.PeriodObjective,	
				  			  
				  Pe.Period, 
				  Pe.Reference, 
				  Pe.RecordStatus, 
				  Pe.Status, 
				 
				  Org.Mission, 
				  Org.OrgUnitCode, 
				  Org.MandateNo AS MandateNoOLD,
				  Org.OrgUnit AS OrgUnitOLD, 		         
				  NEW.MandateNo AS Mandate,
	              NEW.OrgUnit AS OrgUnit 
				  
		 INTO     userQuery.dbo.#SESSION.acc#ProgramPeriod			
	     FROM     ProgramPeriod Pe INNER JOIN
	              Organization.dbo.Organization Org ON Pe.OrgUnit = Org.OrgUnit INNER JOIN
	              Organization.dbo.Organization NEW ON Org.Mission = NEW.Mission 
				                                     AND Org.OrgUnitCode = NEW.OrgUnitCode
	     WHERE    Pe.Period        = '#PriorPeriod#' 
		 AND      Org.MandateNo    = '#CheckPrior.MandateNo#' 
		 AND      Org.Mission      = '#Org.Mission#' 
		 AND      NEW.MandateNo    = '#CheckCurrent.MandateNo#' 
		 AND      Pe.RecordStatus  != '9' 
		 AND      Pe.ProgramCode IN (
		 							 SELECT ProgramCode 
		                             FROM   Program 
									 WHERE  ProgramClass IN (#preservesingleQuotes(filterprogramclass)#)
									 )
	</cfquery>
	
<cfelse>

    <cfquery name="ProgramPeriod" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT   Pe.ProgramCode, 
		          Pe.OrgUnitImplement, 
				  Pe.PeriodParentCode,
				  Pe.PeriodHierarchy,
				  Pe.PeriodDescription,
				  Pe.PeriodGoal,
				  Pe.PeriodObjective,	
				  Pe.Period, 
				  Pe.Reference, 
				  Pe.RecordStatus, 
				  Pe.Status, 
				  O.Mission,
				  Pe.OrgUnit
		 INTO     userQuery.dbo.#SESSION.acc#ProgramPeriod			
	     FROM     ProgramPeriod Pe INNER JOIN Organization.dbo.Organization O ON Pe.OrgUnit = O.OrgUnit
		 WHERE    Pe.Period = '#PriorPeriod#' 
		 AND      Pe.RecordStatus    != '9'  	
		 AND      Pe.ProgramCode IN (
		 							 SELECT ProgramCode 
		                             FROM   Program 
									 WHERE  ProgramClass IN (#preservesingleQuotes(filterprogramclass)#)
									 ) 	 
	</cfquery>
	

</cfif>

<cfset programlist = "">

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#Program">

<cfquery name="NotInPeriod" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT   P.ProgramCode,
		          P.ProgramName,
				  P.ListingOrder,
				  P.ProgramScope,
				  P.ProgramClass,
				  Pe.PeriodParentCode as ParentCode,
				  Pe.PeriodHierarchy  as ProgramHierarchy,
				  Pe.Reference, 
				  Pe.OrgUnit, '1' as Exist
		 INTO     userQuery.dbo.tmp#SESSION.acc#Program
	     FROM     #CLIENT.LanPrefix#Program P INNER JOIN  
		          userQuery.dbo.#SESSION.acc#ProgramPeriod Pe ON P.ProgramCode    = Pe.ProgramCode
		 WHERE    P.ProgramCode    = Pe.ProgramCode
		 AND      Pe.RecordStatus != '9' 
		 AND      Pe.Period        = '#PriorPeriod#' 
		 AND      Pe.Mission       = '#ORG.Mission#'
		 
</cfquery>

<cfquery name="NotInPeriod" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     UPDATE  userQuery.dbo.tmp#SESSION.acc#Program
		 SET     Exist = '0'
		 WHERE   ProgramCode NOT IN
	                 (SELECT  P.ProgramCode
	                  FROM    Program P INNER JOIN
	                          ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode
	                  WHERE   Pe.Period        = '#URL.Period#'
			          AND     Pe.RecordStatus != '9') 
</cfquery>

<cfform onsubmit="return false" name="programform">

	<table width="99%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
		
		<cfoutput query="SearchResult" group="TreeOrder">
		
			<cfoutput>			
							
			  
				 					
				<cfquery name="Program" 
			     datasource="AppsQuery" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				     SELECT   DISTINCT ProgramCode, ProgramName,Reference, ListingOrder, Exist, ProgramScope
				     FROM     dbo.tmp#SESSION.acc#Program P
					 WHERE    P.OrgUnit     = '#SearchResult.OrgUnit#'
					 -- AND      (P.ParentCode = '' OR P.ParentCode is NULL)
					 UNION 
					 SELECT   DISTINCT ProgramCode, ProgramName,Reference, ListingOrder, Exist, ProgramScope
				     FROM     dbo.tmp#SESSION.acc#Program P
					 WHERE    ProgramScope IN ('Global','Parent')	 
					 ORDER BY ListingOrder 
			    </cfquery>
				
				<cfif Program.recordcount gte "1">
				
				 <tr class="line">
			      <td width="30" align="center">
			         <img src="#SESSION.root#/Images/view.jpg" 
					      alt="" width="14" height="15" border="0" align="middle">
			       </td>
				   <td class="labelit">#OrgUnitCode#</b></td>
			       <td class="labelmedium" colspan="5">#OrgUnitName#</td>
			       <TD class="labelit" colspan="2"></TD>
				 </TR>
				 
				 </cfif>
									
				<cfloop query="Program">	
										   
				   <cfinclude template="ProgramCarryOverDetail.cfm"> 		   
				   
			    </cfloop>			   
			    
			</CFOUTPUT>
		
		</CFOUTPUT>
		
	</table>
	
</cfform>	