
<cfset qry = replace(rowguid,"-","","ALL")>

<cfparam name="url.selectiondate" default="">

<cfif url.selectiondate neq "">
	<cfset dateValue = "">
	<CF_DateConvert Value="#url.selectiondate#">
    <cfset seldate = dateValue>
</cfif>

<cfif Attributes.Parent is "">

	<cfquery name="qry_#qry#" 
	 datasource="AppsQuery"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT    *, '1' as Operational
	 	 FROM     #SESSION.acc#_MissionOrganization
		 WHERE    (ParentOrgUnit = '' or ParentOrgUnit is NULL)
		 AND      TreeUnit = 0
		 <cfif url.selectiondate neq "">
		 AND      DateEffective <= #seldate# AND DateExpiration >= #seldate#
		 </cfif>
		 ORDER BY TreeOrder 
	</cfquery>	
				
<cfelse>

		<!--- show all children --->
		<cfquery name="qry_#qry#" 
		 datasource="AppsQuery"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
				 SELECT   *, '1' as Operational
			 	 FROM     #SESSION.acc#_MissionOrganization
				 WHERE    ParentOrgUnit = '#Attributes.Parent#' 
				 <cfif url.selectiondate neq "">
				 AND      DateEffective <= #seldate# AND DateExpiration >= #seldate#
				 </cfif>
				 AND      TreeUnit = 0
				 ORDER BY TreeOrder
		</cfquery>			
				
		<cfset total = evaluate("qry_#qry#.recordcount")>
		
		<cfif total gt "8" and Attributes.Level eq "1">
			
			<cfquery name="qry_#qry#" 
			 datasource="AppsQuery"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT  *, 1 as Operational 
			 	 FROM    #SESSION.acc#_MissionOrganization
				 WHERE   ParentOrgUnit = '#Attributes.Parent#' 
				 <cfif url.selectiondate neq "">
				 AND      DateEffective <= #seldate# AND DateExpiration >= #seldate#
				 </cfif>
				 AND     TreeUnit = 0
				 AND     OrgUnitCode IN (SELECT ParentOrgUnit 
				                         FROM #SESSION.acc#_MissionOrganization)  
			</cfquery>			
			
			<cfif evaluate("qry_#qry#.recordcount") eq "0">
			
					<!--- show all children --->
					<cfquery name="qry_#qry#" 
					 datasource="AppsQuery"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 SELECT   *, '1' as Operational
					 	 FROM     #SESSION.acc#_MissionOrganization
						 WHERE    ParentOrgUnit = '#Attributes.Parent#' 
						 <cfif url.selectiondate neq "">
						 AND      DateEffective <= #seldate# AND DateExpiration >= #seldate#
						 </cfif>
						 AND      TreeUnit = 0
						 ORDER BY TreeOrder
					</cfquery>				
											
			</cfif>
			
		</cfif>				
		
</cfif>
