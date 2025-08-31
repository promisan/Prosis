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
<cfquery name="Report" 
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT 	*
	  FROM  	Ref_ReportControl
	  WHERE 	ControlId    = '#URL.ControlId#'
 </cfquery>	
 
 <cfquery name="PK" 
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT * 
  FROM   Ref_ReportControlCriteria
  WHERE  ControlId = '#URL.ControlId#'
  AND    CriteriaName = '#URL.CriteriaName#'
 </cfquery>
  
<cfquery name="Init" 
   datasource="AppsSystem">
	   SELECT     * 
	   FROM       Parameter
</cfquery>

<cfquery name="Field" 
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT 	TOP 1 *
	  FROM  	Ref_ReportControlCriteriaField 
	  WHERE 	ControlId    = '#URL.ControlId#'
	  AND   	CriteriaName = '#URL.CriteriaName#'
	  AND       Operational  = '1' 
	  ORDER BY  FieldOrder
 </cfquery>	
 
 <cfparam name="#field.fieldName#" default="">
 
 <cfset filter = "">
 <cfloop index="itm" list="#evaluate(field.fieldName)#" delimiters=",">
     <cfif filter eq "">
	     <cfset filter = "'#itm#'">
	 <cfelse>
		 <cfset filter = "#filter#,'#itm#'">
	 </cfif>	 
 </cfloop> 
 
<cfquery name="Fields" 
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT 	*
  FROM  	Ref_ReportControlCriteriaField 
  WHERE 	ControlId    = '#URL.ControlId#'
  AND   	CriteriaName = '#URL.CriteriaName#'
  AND   	FieldName    = '#URL.FieldName#' 
 </cfquery>
 
<table width="100%" align="center" cellspacing="0" cellpadding="0">

<cfoutput query="Fields">		
 
		 <tr>
	       <td height="20" align="center" class="labelit" style="padding:5px; border-top:1px solid ##C0C0C0; border-right:1px solid ##C0C0C0; border-left:1px solid ##C0C0C0;">
		   <cfif FieldDescription neq "">#FieldDescription#<cfelse>#fieldName#</cfif>
		   </td>
		 </tr>
	
		 <tr>
		 
		   <td style="padding:2px; border:1px solid ##C0C0C0;">		 	 
		 
			 <cfif fields.fieldsorting neq "">
				 <cfset sort = fields.fieldsorting>
			 <cfelse>
				 <cfset sort = fields.fieldName>		 
			 </cfif>
			 
			 <cfif fields.fielddisplay neq "">
				 <cfset display = fields.fieldDisplay>
			 <cfelse>
				 <cfset display = fields.fieldName>		 
			 </cfif>
			 
			 <cfset Crit = replaceNoCase(PK.CriteriaValues, "@userid", SESSION.acc , "ALL")>
			 <cfset Crit = replaceNoCase(Crit,"@manager",SESSION.isAdministrator,"ALL")>
			 <cfset Crit = replaceNoCase(Crit, "WHERE", "" , "ALL")>				 	 
		 
		 <cfif LookupUnitTree eq "NONE">
				
				  <!--- global values presetted --->
		
				  <cfquery name="GlobalDefault" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					 SELECT    CriteriaValue
					 FROM      UserReportCriteria UC INNER JOIN
					           UserReport U ON UC.ReportId = U.ReportId INNER JOIN
					           Ref_ReportControlLayout RL ON U.LayoutId = RL.LayoutId INNER JOIN
					           Ref_ReportControl R ON RL.ControlId = R.ControlId
					 WHERE     U.Account       = '#SESSION.acc#' 
					 AND       R.SystemModule  = '#Report.SystemModule#' 
					 AND       UC.CriteriaName = '#FieldGlobal#'
					 AND       U.Status = '6'
				  </cfquery>
			  
			      <cfset DefaultValue = GlobalDefault.CriteriaValue>
			  
			      <cfset def = "">
				  <cfset rest = "0">
				 
				  <!--- define global defaults to be respected in the search --->
					 
				  <cfloop index="itm" list="#DefaultValue#" delimiters=",">
									 
					        <cfif itm eq "*">
								 <cfset rest = "1">
							<cfelse>	
								 <cfif def eq "">
						    	    <cfset def = "'#itm#'">
								 <cfelse>
							        <cfset def = "#def#,'#itm#'">
							     </cfif>
							</cfif>
							        	    
			     </cfloop>
													 
				 <cftry>
			 					
					 <cfquery name="Lookup#URL.CriteriaName#" 
					     datasource="#PK.LookupDataSource#">
						 
						 SELECT   DISTINCT #Fields.FieldName#, #display#
						  FROM     #PK.LookupTable#
						  WHERE    #Fields.FieldName# != ''
						  
						  <cfif Crit neq "">
						   	AND   #preserveSingleQuotes(Crit)#
						  </cfif>
						  
						  <!--- dynamic filter --->
						  
						  <cfif Filter neq "" and not findnocase("'All'",Filter)>
						   	AND   #Field.FieldName# IN (#preserveSingleQuotes(Filter)#)
						  </cfif>
						  
						  <!--- GLOBAL DEFAULTS --->
						  <cfif DefaultValue neq "" and rest eq "0">
						  	AND   #Field.FieldName# IN (#preservesinglequotes(def)#)
						  </cfif>
						  						  
						  ORDER BY #sort#
						  
						  </cfquery>
						 					   
					   <cfcatch>
					   
						   Invalid query	
						   <cfabort>
					   
					   </cfcatch>
				   								   
				   </cftry>							 		
		 
		 <cfelse>
		 
		 	<!--- lookup select is filtered by tree --->
		 
		 		<cfquery name="Mandate" 
				 datasource="AppsOrganization" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				   SELECT Mission,MandateNo
				   FROM   Ref_Mandate
				   WHERE  Mission = '#LookupUnitTree#'
				   <cfif Crit neq "">
				   AND #preserveSingleQuotes(Crit)#
				  </cfif>
				   ORDER BY MandateDefault DESC
				</cfquery>	
				
				<!--- check if user has full access --->   
				
				 <cfquery name="Check" 
				 datasource="AppsOrganization" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				   SELECT TOP 1 *
				   FROM   OrganizationAuthorization
				   WHERE  Mission = '#LookupUnitTree#'
				   AND    UserAccount = '#SESSION.acc#'
				   AND    OrgUnit is NULL 
				   AND    Role IN (SELECT Role 
				                    FROM System.dbo.Ref_ReportControlRole 
								    WHERE ControlId = '#ControlId#')				  
		 		 </cfquery>		  
				 				 		 		  		 				      
				  <cfquery name="Lookup#URL.CriteriaName#" 
				  datasource="#PK.LookupDataSource#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT DISTINCT #Fields.FieldName#, #display#
				  FROM     #PK.LookupTable#
				  WHERE    #Fields.FieldName# != ''
				  AND      #Fields.FieldName# IN (
				  
  				   <cfif check.recordcount gte "1" or SESSION.isAdministrator eq "Yes">
				   
					   SELECT DISTINCT Org.#Fields.FieldName#
					   FROM  [#Init.DatabaseServer#].Organization.dbo.Organization Org
					   WHERE Org.Mission   = '#Mandate.Mission#'
					   AND   Org.MandateNo = '#Mandate.MandateNo#'	   			  
					   AND   HierarchyCode is not NULL
				  
				   <cfelse>	
  
			  		   SELECT DISTINCT Org.#Fields.FieldName#
					   FROM [#Init.DatabaseServer#].Organization.dbo.OrganizationAuthorization A,
					        [#Init.DatabaseServer#].Organization.dbo.Organization Org
					   WHERE A.OrgUnit   = Org.OrgUnit	
					   AND   Org.Mission   = '#Mandate.Mission#'
					   AND   Org.MandateNo = '#Mandate.MandateNo#'	   			  
					   AND   HierarchyCode is not NULL
					 
					   AND   A.UserAccount = '#SESSION.acc#'
					   AND   A.Role IN (SELECT Role 
					                    FROM System.dbo.Ref_ReportControlRole 
									    WHERE ControlId = '#ControlId#')
									
				   </cfif>													  
								  				   
				  )				 
				  
				  ORDER BY #sort#
				  </cfquery>
				  
			  </cfif>			  
							  
		      <select 
			  	name	  = "#Fields.FieldName#" 
				id		  = "#Fields.FieldName#"
				multiple  = "Yes"
			    message   = "Please select #FieldDescription#" 
			   	required  = "no"
				style     = "border:1px solid silver;font-size:15px;height:190px; width:100%;"
				tooltip   = "#FieldDescription#"
				width     = "#FieldWidth#">
				    <cfif DefaultValue eq "">
					  	<option value="All" <cfif url.fldno neq "1">selected</cfif>>All<cfloop index="i" from="1" to="24">&nbsp;</cfloop></option>
						<cfloop query="Lookup#URL.CriteriaName#">
							<option value="#evaluate(Fields.FieldName)#">#evaluate(display)#</option>
						</cfloop>				
					<cfelse>
						<cfloop query="Lookup#URL.CriteriaName#">
							<option value="#evaluate(Fields.FieldName)#" <cfif currentrow eq "1">selected</cfif>>#evaluate(display)#</option>
						</cfloop>	
					</cfif>
				</select>
			  
		   </td>
		   
		   <td style="width:1px;"></td>
		 		   
		   </tr>
		   
		   </cfoutput>
		   		   
		</table>
		
		