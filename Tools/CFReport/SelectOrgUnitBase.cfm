
<cfparam name="attributes.controlId"    default="">   
<cfparam name="attributes.criterianame" default=""> 
<cfparam name="attributes.mission"      default=""> 

<cfquery name="Base" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT     TOP 1 *
	 FROM  		Ref_ReportControlCriteria R
	 WHERE  	ControlId     = '#attributes.ControlId#' 
	  AND    	CriteriaName  = '#attributes.CriteriaName#'  
</cfquery>
    
   <!--- this query template filters the orgunit lookup table
   to show only units to which the user has access through the
   usergroup or roles defined for the report table --->   
   
   <cfquery name="Mandate" 
	 datasource="AppsOrganization">
	   SELECT   MandateNo
	   FROM     Ref_Mandate
	   WHERE    Mission = '#attributes.mission#'
	   ORDER BY MandateDefault DESC
   </cfquery>
	
   <cfquery name="Role" 
	 datasource="AppsSystem">
	   SELECT Role 
	   FROM   Ref_ReportControlRole 
	   WHERE  ControlId = '#Base.ControlId#'
   </cfquery>
	
   <cfquery name="Group" 
	 datasource="AppsSystem">
	   SELECT *
	   FROM   Ref_ReportControlUserGroup
	   WHERE  ControlId = '#Base.ControlId#'
   </cfquery>
   
   <!--- check if granted for the full try already --->
					
	<cfquery name="Check" 
	 datasource="AppsOrganization">
	   SELECT  TOP 1 *
	   FROM    OrganizationAuthorization
	   WHERE   Mission     = '#attributes.mission#'
	   AND     OrgUnit is NULL 
	   AND     UserAccount = '#SESSION.acc#'
	   <cfif role.recordcount gte "1">	 					
	   AND     Role IN (SELECT Role 
	                    FROM   System.dbo.Ref_ReportControlRole 
				        WHERE  ControlId = '#Base.ControlId#')		
	   </cfif>
	   ORDER BY OrgUnit DESC				 								  
	</cfquery>
	
	<cfquery name="Param" 
	   datasource="AppsSystem">
	    SELECT * 
		FROM   Parameter
	</cfquery>
	
	<cfsavecontent variable="orgfilter">
		<cfoutput>
				WHERE    Org.Mission   = '#attributes.mission#'
				
				<!---
				<cfif getAdministrator(attributes.mission) eq "0">
				   AND   DateEffective  < getdate()
				   AND   DateExpiration > getDate()
				</cfif>
				--->
				
				   AND   Org.MandateNo = '#Mandate.MandateNo#'	
				   AND   SourceGroup is NULL
				   <!--- disabled for laticia					  
				   AND   HierarchyCode is not NULL		
				   --->   					  
				   	
		</cfoutput>				
	</cfsavecontent>
		
	<cfif (role.recordcount eq "0" and group.recordcount eq "0") or 
	    getAdministrator(attributes.mission) eq "1" or 
		SESSION.acc eq Param.AnonymousUserid or
		Check.recordcount gte "1">
			
	 	<cfquery name="listquery" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   SELECT DISTINCT Org.OrgUnit, 
		                   Org.OrgUnitCode, 
						   Org.HierarchyCode, 
						   Org.Mission, 
						   <cfif Base.LookupFieldShow eq "0">
						   Org.OrgUnitName as OrgUnitName
						   <cfelse>
						   Org.OrgUnitCode+' '+Org.OrgUnitName as OrgUnitName
						   </cfif>
		   FROM  Organization Org
		   
		   		#preservesinglequotes(orgfilter)#			  
				
		</cfquery>
		
					
	<cfelse>
	
		<!--- limit access to relevant units if report has group if will filter
		on the recording of the orgunit --->
			
	    <cfquery name="listquery" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   SELECT DISTINCT Org.OrgUnit, 
		                   Org.OrgUnitCode, 
						   Org.HierarchyCode, 
						   Org.Mission, 
						    <cfif Base.LookupFieldShow eq "0">
						   Org.OrgUnitName as OrgUnitName
						   <cfelse>
						   Org.OrgUnitCode+' '+Org.OrgUnitName as OrgUnitName
						   </cfif>
		   FROM  OrganizationAuthorization A,
		         Organization Org
				 
		   		 #preservesinglequotes(orgfilter)#	
		  		   
		   AND   A.OrgUnit          = Org.OrgUnit
		  
		   <cfif role.recordcount gte "1" and group.recordcount eq "0">	
		   
		      AND   A.Role IN (SELECT Role 
		                    FROM   System.dbo.Ref_ReportControlRole 
						    WHERE  ControlId = '#Base.ControlId#')	
		   </cfif>						
													
		   <cfif role.recordcount eq "0" and group.recordcount gte "1">
		   
		       AND   A.Source IN (SELECT Account 
		                    FROM   System.dbo.Ref_ReportControlUserGroup 
						    WHERE  ControlId = '#Base.ControlId#')		
		   		   						  		 
		   </cfif>
		   
		   <cfif role.recordcount gte "1" and group.recordcount gte "1">
		   
		      AND   (
		   
		   			A.Role IN (SELECT Role 
		                    FROM   System.dbo.Ref_ReportControlRole 
						    WHERE  ControlId = '#Base.ControlId#')	
				 OR
				 
				  A.Source IN (SELECT Account 
		                    FROM   System.dbo.Ref_ReportControlUserGroup 
						    WHERE  ControlId = '#Base.ControlId#')		
				 
				 )	
				 
		   </cfif>		 						
		   					
		   AND   A.UserAccount = '#SESSION.acc#'		
		   			  
		</cfquery>

</cfif>			

<!--- provision to make it quicker ---> 
<cfset selected = QuotedValueList(listquery.orgunit)> 
<cfif selected eq "">
	<cfset selected = "''">
</cfif>
<cfset caller.selectedman = mandate.MandateNo>
<cfset caller.selectedorg = selected>
<!--- remove as this resulted in doubles for the selection
<cfif len(selected) gt 1000>
	<cfset caller.selectedorg = "all">	
<cfelse>
	<cfset caller.selectedorg = selected>
</cfif>
--->	