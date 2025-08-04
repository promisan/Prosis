<!--
    Copyright © 2025 Promisan

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
	
<!--- Query returning search results --->

<cfparam name="URL.Adv" default="0">
<cfparam name="URL.Page" default="1">
<cfparam name="URL.val" default="">

<cfquery name="Base" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT     TOP 1 *
	 FROM  		Ref_ReportControlCriteria R
	 WHERE  	ControlId     = '#URL.ControlId#' 
	 AND    	CriteriaName  = '#URL.par#'  
</cfquery>

<cfoutput query="Base">

	<cfif Base.LookupDataSource eq "">
		<cfset ds = "appsQuery">
	<cfelse>
		<cfset ds = "#Base.LookupDataSource#">
	</cfif> 
	
	<cfif CriteriaType eq "Unit">
				
		 <cf_selectOrgUnitBase 
		controlid="#url.controlid#" 
		criteriaName="#url.par#">
		
		<cfif url.val eq "">
			<cfset val = replace(url.cur,"'","","ALL")> 
		<cfelse>
			<cfset val = replace(url.val,"'","","ALL")> 
		</cfif>	

		<!--- search --->
		
		<cfif URL.adv eq "1">
		  <cfset str = "AND (#LookupFieldValue# LIKE '#val#%' OR OrgUnitName LIKE '%#val#%')">
		<cfelse>
		  <cfset str = "AND (#LookupFieldValue# LIKE '#val#%' OR OrgUnitName LIKE '#val#%')">
		</cfif>
			
		<cfset con = str>
		
		<cfquery name="Mandate"
		datasource="appsOrganization" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT TOP 1 *
		    FROM   Ref_Mandate		
			WHERE  Mission = '#url.fly#' 
			AND    DateEffective  <= getdate()
			ORDER BY DateExpiration DESC			
	    </cfquery>		
		
		 <cfquery name="total" 
	     datasource="appsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT count(*) as Total
			 FROM  Organization Org
			 <cfif selectedorg neq "all" and selectedorg neq "" and selectedorg neq "''">
				WHERE  OrgUnit IN (#preservesinglequotes(selectedorg)#)
			 <cfelse>
				WHERE Mission   = '#Mandate.Mission#' 
				AND   MandateNo = '#Mandate.MandateNo#'
			 </cfif>	
			  <cfif LookupUnitParent eq "1">
				AND (ParentOrgUnit = '' or ParentOrgUnit is NULL or Autonomous = 1)
			 </cfif>			
			 #preserveSingleQuotes(con)# 				  	 
		</cfquery>
				
		<cfset show = "21">
		
		<cfset No = URL.Page*show>
				
		<cfif No gt Total.Total and total.total neq "">
			  <cfset No = "#Total.Total#">
		</cfif> 	
										
		<cfquery name="Current" 
		    datasource="appsOrganization" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		     SELECT  #LookupFieldValue#,
		             OrgUnit as PK,  
					 OrgUnitCode as Code,
		             OrgUnitName as Display, *			 	
			 FROM    Organization			 
			 WHERE   #LookupFieldValue#  = '#url.cur#' 
		</cfquery> 
									
		<cfquery name="SearchResult" 
		    datasource="appsOrganization" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT DISTINCT TOP #No# 
			       #LookupFieldValue# as PK,
			       OrgUnit as OrgUnit,
				   OrgUnitCode as Code,
				   OrgUnitName as Display, *		
		    FROM   Organization Org
			<cfif selectedorg neq "all" and selectedorg neq "" and selectedorg neq "''">
			WHERE  OrgUnit IN (#preservesinglequotes(selectedorg)#)
			<cfelse>
			WHERE  Mission   = '#Mandate.Mission#' 
			AND    MandateNo = '#Mandate.MandateNo#'
			</cfif>	
			<cfif LookupUnitParent eq "1">
			AND   (ParentOrgUnit = '' or ParentOrgUnit is NULL or Autonomous = 1)
			</cfif>		
			#preserveSingleQuotes(con)#					
			ORDER BY HierarchyCode 	 
		</cfquery> 
						
	<cfelse>	
	
	    <cfset tmp = "">
	    <cfinclude template="FormHTMLComboQuery.cfm">
		
		<!--- adjustment 20/5/2010 to ensure a better filtering and subtotal of records --->
		
		<cftry>
							
		<cfquery name="LookupBase" 
		    datasource="#ds#" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT #dis# 
			       #LookupFieldValue#,
		           CONVERT(varchar, #LookupFieldValue#) as PK,  
		           #LookupFieldDisplay# as Display
				   
			<cfif not Find("FROM ", "#preserveSingleQuotes(CriteriaValues)#")>
			 FROM #LookupTable#
			</cfif>	
			#preserveSingleQuotes(con)# 	   
			
		</cfquery> 
		
		<cfcatch>
		
			<!--- added * to check if there are any conditions in the criteria --->
		
			<cfquery name="LookupBase" 
		    datasource="#ds#" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT #dis# 
			       #LookupFieldValue#,
		           CONVERT(varchar, #LookupFieldValue#) as PK,  
		           #LookupFieldDisplay# as Display, *
				
		 	<cfif not Find("FROM ", "#preserveSingleQuotes(CriteriaValues)#")>
			 FROM #LookupTable#
			</cfif>	
			#preserveSingleQuotes(con)#			
		   </cfquery> 
				
		</cfcatch>
		
		</cftry>
				
		<!--- 23/2/2012		
		
		    - If criteriarole = 1 AND name = 'mission' AND report has one or more roles defined		
		    - Define all the missions a user has access to based on the roles defined for this report and put this into a variable		
		    - use this variable to filter the dropdown/multi-select		
			
		--->	
			
		<cfif SESSION.isAdministrator eq "Yes">
		
			<cfset missionaccessfilter = "">	
		
		<cfelse>	
			
			<cfif CriteriaRole eq "1" and CriteriaName eq "mission">
			
					<cfquery name="getRoles"
						datasource="AppsSystem" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT  *
						FROM    Ref_ReportControlRole
						WHERE   ControlId = '#url.controlid#' 				
					</cfquery>
					
					<cfif getRoles.recordcount gte "1">
					
						<cfquery name="getMission"
							datasource="AppsSystem" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							  SELECT  DISTINCT Mission
							  FROM    Organization.dbo.OrganizationAuthorization
							  WHERE   Role IN
							            (SELECT  Role
							             FROM    Ref_ReportControlRole
							             WHERE   ControlId = '#url.controlid#') 
						     AND      UserAccount = '#SESSION.acc#'		
							 
							 UNION
							 
							 SELECT  DISTINCT G.AccountMission
							 FROM    Ref_ReportControlUserGroup R INNER JOIN
							         UserNames G ON R.Account = G.Account INNER JOIN
							         UserNamesGroup U ON G.Account = U.AccountGroup
							 WHERE   Account = '#SESSION.acc#'
							 AND     R.ControlId = '#url.controlid#'
							 		
						 </cfquery>
						 
						 <cfset missionaccessfilter = QuotedValueList(getMission.Mission)>	 
						 
					<cfelse>
					
					    <!--- no roles so full access --->
					
						<cfset missionaccessfilter = "">	 
					
					</cfif>		
						
			<cfelse>
			
				<cfset missionaccessfilter = "">				
			
			</cfif>	
			
		</cfif>	
		
		<cfquery name="Total" dbtype="query">
			SELECT count(*) as Total
			FROM   LookupBase
			<cfif missionaccessfilter neq "">
			WHERE  PK IN (#preserveSingleQuotes(missionaccessfilter)#)
			</cfif>	
			
		</cfquery>		
				
		<cfset show = "21">
		
		<cfset No = URL.Page*show>
		
		<cfif No gt Total.total and total.total neq "">
			  <cfset No = Total.total>
		</cfif> 			
			
		<cfquery name="Current" 
		    datasource="#ds#" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT  #dis# TOP 1 #LookupFieldValue#,
		            CONVERT(varchar, #LookupFieldValue#) as PK,  
		            #LookupFieldDisplay# as Display  <!--- , * --->
				
		 	<cfif not Find("FROM ", "#preserveSingleQuotes(CriteriaValues)#")>
			 FROM   #LookupTable#
			 </cfif>	
			 WHERE  #LookupFieldValue# = '#url.cur#'			 
		</cfquery> 
		
		<cfquery name="SearchResult"
         maxrows="#No#"
         dbtype="query">
			SELECT *
			FROM   LookupBase
			<cfif missionaccessfilter neq "">
			WHERE  PK IN (#preserveSingleQuotes(missionaccessfilter)#)
			</cfif>	
		</cfquery>		
						
	</cfif>	
	
</cfoutput>
   
<table width="100%" class="navigation_table">   

	<cfif SearchResult.recordcount eq "0">
	
	<tr><td align="center" style="padding-top:30px" class="labelmedium"><font color="FF0000"><cf_tl id ="No records found"></font></td></tr>
	
	<cfelse>
	
	<tr><td colspan="4">
	<cfinclude template="FormHTMLComboSingleNavigation.cfm">
	</td></tr>	
	
	<tr><td colspan="4" align="center" bgcolor="e4e4e4"></td></tr>
							
	<tr class="labelmedium" bgcolor="CAEEF4">
	   	
	    <td height="17" width="10%"></td>
		<cfif base.Lookupfieldshow eq "1">
	    <TD><cf_tl id ="Code"></TD>
		</cfif>		
		<TD style="padding-left:4px"><cf_tl id ="Display"></TD>
		
	</TR>
	<tr><td colspan="4" align="center" bgcolor="e4e4e4"></td></tr>
		
	<cfoutput query="Current">
	
	<cfset des = replaceNoCase("#display#",","," ","ALL")>
	<cfset des = replaceNoCase("#des#","'",'',"ALL")>
	<cfset des = replaceNoCase("#des#",'"','',"ALL")>
					
	<tr bgcolor="E2E2C7" class="navigation_row linedotted labelmedium navigation_action" onClick="comboselect('#url.par#','#url.shw#','#PK#','#des#')">
			
		<td width="50" height="20" align="center"></td>		
		
		<cfif base.Lookupfieldshow eq "1">	
		<TD><cfif Base.CriteriaType eq "Unit">#Code#<cfelse>#PK#</cfif></TD>
		</cfif>
						
		<td style="padding-left:4px;word-wrap: normal;">
		  <cfif len(display) gt "65">
		    <a href="##" title="#Display#">#left(Display,65)#...</a>
		  <cfelse>
		    #display#	
		  </cfif>	  
		</td>
		
	</TR>
		
	</cfoutput>
				
	<cfoutput query="SearchResult" startrow="#Str#">
	
		<cfset des = replaceNoCase("#display#",","," ",'ALL')>
		<cfset des = replaceNoCase("#des#","'","",'ALL')>
		<cfset des = replaceNoCase("#des#",'"',"",'ALL')>
		<cfset des = replaceNoCase("#des#",chr(10)," ",'ALL')>
		<cfset des = replaceNoCase("#des#",chr(13)," ",'ALL')>	
		
		<cfif PK neq "#Current.PK#">
				
		<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f8f8f8'))#" class="navigation_row line labelmedium">
				
			<td width="50" height="20" align="center">
			
			<cf_img icon="open" navigation="Yes" onClick="comboselect('#url.par#','#url.shw#','#PK#','#des#')">
					   
			</td>
			
			<cfif base.Lookupfieldshow eq "1">	
			<TD>		
			  <cfif Base.CriteriaType eq "Unit">#Code#<cfelse>#PK#</cfif>
			</TD>
			</cfif>
							
			<td style="padding-left:4px;word-wrap: normal;">
			  <cfif len(display) gt "65">
			    <a href="##" title="#Display#">#left(Display,65)#...</a>
			  <cfelse>
		    	#display#	
			  </cfif>
		  
			</td>
			
		</TR>
		
		</cfif>
	
	</CFOUTPUT>
	
	</cfif>
			
</table>

<cfset ajaxOnLoad("doHighlight")>

	
