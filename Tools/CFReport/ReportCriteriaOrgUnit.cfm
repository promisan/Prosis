<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<CF_DropTable dbName="AppsQuery" tblName="#answerOrg#"> 

<cfquery name="Temptable" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  	SELECT  Mission, 
	        MandateNo, 
			HierarchyCode, 
			OrgUnitCode,
			0 as OrgUnit  
	INTO    userQuery.dbo.#answerOrg#
	FROM    Organization 
	WHERE   1=0 	
</cfquery>

<cftry>

		<!--- define the basis for selection/subset --->
		<!--- filter base list in the interface --->
		
		<cfset selectedorg = Evaluate("FORM.#CriteriaName#_list")>
  	
	<cfcatch>
	
		<cfset mission = replace(mission,"'","","ALL")>
								
	    <cf_SelectOrgUnitBase 
		    controlid="#controlid#" 
			criterianame="#criteriaName#"
			mission="#mission#">
						
	</cfcatch>	
	
</cftry>	

<!--- provision to remove comma's upfromt 20/3/2009 --->

<cfif left(val,1) eq ",">
 <cfset val = replace(val,",","")>
</cfif>

<cfset selectedorg = replaceNoCase(selectedorg," ","","ALL")>

<cfquery name="Org" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT  *  
  FROM    Organization 
  
  <cfif val neq "all">  
   
  	  WHERE   OrgUnit IN (#val#) 
	  
  <cfelse>  
  
	  <cfif selectedorg neq "">	 
	  	WHERE  OrgUnit IN ('',#preserveSingleQuotes(selectedorg)#) 
	  <cfelse>	  
	  	WHERE  1=0
	  </cfif>
	  
	  AND      DateEffective  < getdate()
	  AND      DateExpiration > getDate()
	  
  </cfif>
  
</cfquery>

<cfif Org.Recordcount neq "0">

    <cfif Org.Recordcount gte 500>
	
			<cfquery name="Insert" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO userQuery.dbo.#answerOrg#
				            (Mission, MandateNo, HierarchyCode, OrgUnitCode,OrgUnit)
				    SELECT   Mission, MandateNo, HierarchyCode, OrgUnitCode,OrgUnit
					 FROM    Organization 
					  <cfif val neq "all">   
					  	  WHERE   OrgUnit IN (#val#) 
					  <cfelse>  
						  <cfif selectedorg neq "">	 
						  WHERE   OrgUnit IN (#preservesinglequotes(selectedorg)#) 
						  <cfelse>	  
						  WHERE 1=0
						  </cfif>
					  </cfif>
					AND      DateEffective  < getdate()
					AND      DateExpiration > getDate()
					AND      SourceGroup is NULL								
					ORDER BY HierarchyCode 
			</cfquery>
		
	<cfelse>
	
		
		<cfloop query="Org">
				
			<cfif HierarchyCode neq "">
		
				<cfquery name="Insert" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">					
					INSERT INTO userQuery.dbo.#answerOrg#
				            (Mission, MandateNo, HierarchyCode, OrgUnitCode,OrgUnit)
				    SELECT   Mission, MandateNo, HierarchyCode, OrgUnitCode,OrgUnit
					FROM     Organization
					WHERE    HierarchyCode LIKE '#Org.HierarchyCode#%' 
					AND      Mission        = '#Org.Mission#' 
					AND      MandateNo      = '#Org.MandateNo#' 					
					AND      SourceGroup is NULL								
					ORDER BY HierarchyCode 					
				</cfquery>
			
			<cfelse>
			
				<cfquery name="Insert" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					INSERT INTO userQuery.dbo.#answerOrg#
				           (Mission, MandateNo, HierarchyCode, OrgUnitCode,OrgUnit)
				    SELECT  Mission, MandateNo, HierarchyCode, OrgUnitCode,OrgUnit
					FROM    Organization
					WHERE   OrgUnit = '#OrgUnit#' 		
				</cfquery>
				
			</cfif>
			
		</cfloop>
		
	</cfif>	

</cfif>

<cfquery name="Init" 
   datasource="AppsSystem">
   SELECT     * 
   FROM       Parameter
</cfquery>	

<cfif UserReport.TemplateUserQuery eq "">
	
	 <!--- Get "factory" --->
	 <CFOBJECT ACTION="CREATE"
		TYPE="JAVA"
		CLASS="coldfusion.server.ServiceFactory"
		NAME="factory">
		
		<CFSET dsService=factory.getDataSourceService()>

		<CFSET dsNames=dsService.getNames()>
		<cfset ArraySort(dsnames, "textnocase")> 
		
		<CFLOOP INDEX="i"
			FROM="1"
			TO="#ArrayLen(dsNames)#">
			
			<cftry>
				
					<cfset nm = dsNames[i]>
					
					<cfif findNoCase("appsQuery","#dsNames[i]#")>
	
						<cftry>
						
						<cfif nm neq "appsQuery">
							
							<cfif dsService.verifyDatasource("#nm#")>		
								
								<!--- move temp file to another database server so it is present --->
											    
								<cfquery name="DSN" 
								   datasource="#dsNames[i]#">
									SELECT *
									INTO #answerOrg#
									FROM [#Init.DatabaseServer#].userQuery.dbo.#AnswerOrg# 
							    </cfquery>
																					
							</cfif> 
						
						</cfif>
						
						<cfcatch>
				
							<cfoutput>
							<script>alert('Database object: [#Init.DatabaseServer#].userQuery.dbo.#AnswerOrg# could not be moved to #nm#. Contact your administrator.')</script>
							</cfoutput>
												
						</cfcatch>
						
						</cftry>
						
					</cfif>
					
			<cfcatch>
				
				<!--- Not verified, skip removal  --->
			
			</cfcatch>	
		
			</cftry>		
		
		</cfloop>	

</cfif>	
		
<!--- put the correct set --->

<cfset val = "">

<cfset tmp = "Field:OrgUnitCode available under: answerOrg">
