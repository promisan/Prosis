
<cftry>
 <cfdirectory action="CREATE" directory="#SESSION.rootPath#\CFRStage\EmployeePhoto\">
 <cfcatch></cfcatch>
</cftry> 

<cfquery name="getLast" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   ConditionValue
        FROM     UserModule AS U INNER JOIN
                 UserModuleCondition AS UC ON U.Account = UC.Account AND U.SystemFunctionId = UC.SystemFunctionId
		WHERE    U.SystemFunctionId  = '#url.systemfunctionid#'
		AND      U.Account           = '#session.acc#' 			
		AND      UC.ConditionClass   = 'tree'
		AND      UC.ConditionField   = 'orgunit'				
</cfquery>

<cfparam name="session.portalorgunit" default="#getLast.ConditionValue#">

<table style="height:100%;width:100%">
	
	<cfif getAdministrator("#URL.mission#")>
	
		<cfquery name="Units" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Organization AS O 
				WHERE    O.Mission = '#url.mission#' 			
				AND      O.DateEffective  < '#url.selection#' 
				AND      O.DateExpiration > '#url.selection#'
								
				AND     ( O.OrgUnit IN (SELECT  OrgUnitOperational
									   FROM    Employee.dbo.Position
									   WHERE   Mission = '#url.mission#') OR Hierarchycode LIKE '__')		
				
				ORDER BY O.HierarchyCode
				
		</cfquery>
		
		<cfset access = Units>
			
	<cfelse>
		
		<cfquery name="Access" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Organization AS O 
				WHERE    O.Mission = '#url.mission#' 			
				AND      O.DateEffective  < '#url.selection#' 
				AND      O.DateExpiration > '#url.selection#'
				
				AND      ( O.OrgUnit IN (SELECT  OrgUnitOperational
									   FROM    Employee.dbo.Position
									   WHERE   Mission = '#url.mission#') OR Hierarchycode LIKE '__')	
				
				AND   (   O.OrgUnit IN (SELECT  OA.OrgUnit
										FROM   OrganizationAuthorization AS OA 
										WHERE  OA.Mission = '#url.mission#' 
										AND    OA.Role    = 'HRAssistant' 
										AND    OA.UserAccount = '#session.acc#' 
										AND    OA.AccessLevel IN ('1', '2'))	
				      
					     <!--- access needs to be explicit 
					     OR
					  
					     O.Mission IN  (SELECT Mission
									  FROM   OrganizationAuthorization AS OA 
									  WHERE  OA.Mission = '#url.mission#' 
									  AND    OA.OrgUnit is NULL
									  AND    OA.Role    = 'HRAssistant' 
									  AND    OA.UserAccount = '#session.acc#' 
									  AND    OA.AccessLevel IN ('1', '2'))
									  
									  --->
									  
					  )							
										
							
				ORDER BY HierarchyCode		
												
		</cfquery>  <!--- we need to obtain the parent code --->
		
		<cfset i = 0>
		<cfset j = 0>
		
		<cfset accessList = "">
					
		<cfloop query="access">
					
			<cfset i = i + 1>	
			
			    <cfif accessList eq "">
					<cfset accessList = "'#OrgUnit#'">
				<cfelse>
					<cfset accessList = "#accessList#,'#OrgUnit#'">
			    </cfif>								
							    
			    <cfquery name="Check" 
			      datasource="AppsOrganization" 
			      username="#SESSION.login#" 
			      password="#SESSION.dbpw#">
			      SELECT  DISTINCT OrgUnitCode, 
				          ParentOrgUnit, 
						  Mission, 
						  MandateNo
				  FROM    Organization
			   	  WHERE   OrgUnit = '#OrgUnit#' 						  
			    </cfquery>				    
									
				<cfset Parent = Check.ParentOrgUnit>
				<cfset Miss   = Check.Mission>
				<cfset Mand   = Check.MandateNo>
				
				<cfloop condition="Parent neq ''">
				   	  
				   <cfset j = j + 1>
				      	  
				   <cfquery name="LevelUp" 
					datasource="AppsOrganization" 
					maxrows=1 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
			          SELECT OrgUnit, ParentOrgUnit 
			          FROM   Organization
			          WHERE  OrgUnitCode = '#Parent#'
					  AND    Mission     = '#Miss#'
					  AND    MandateNo   = '#Mand#' 
					  
					  <!---
					  <cfif selectiondate neq "">
					  AND DateEffective <= #sdte# AND DateExpiration >= #sdte#
				  	  </cfif>	
					  --->
					  
			  	   </cfquery>									
								
				   <cfif LevelUp.recordcount eq "1">
				   
				   	   <cfif accessList eq "">
							<cfset accessList = "'#LevelUp.OrgUnit#'">
					   <cfelse>
					        <cfset accessList = "#accessList#,'#LevelUp.OrgUnit#'">
					   </cfif>
											       		
					</cfif>
				   <cfif Parent neq LevelUp.ParentOrgUnit>
				   		<cfset Parent = LevelUp.ParentOrgUnit>
				   <cfelse>
				   		<cfset Parent = "">
				   </cfif>	
				   
				</cfloop>
						
		</cfloop>	
								
		<cfquery name="Units" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Organization AS O 
				<cfif accessList eq "">
				WHERE    1=0
				<cfelse>
				WHERE    O.OrgUnit IN (#preserveSingleQuotes(AccessList)#) 									
				</cfif>
				ORDER BY HierarchyCode										
		</cfquery>				
		
	</cfif>	
	
	<!--- we save in the session all the units --->	
	<cfset session.Accessunits = quotedValueList(Units.OrgUnit)>	
	
	<!--- short cut --->
	
	<cfoutput>	
		<tr class="labelmedium2">		
		<td style="font-size:16px" colspan="3">
			<table style="width:100%" class="formpadding">
			<!---
			<tr class="labelmedium2"><td><img src="#client.root#/images/finger.png" style="height:23px" alt="" border="0"></td>
	             <td style="padding-left:4px">
				 <button style="background-color:1A8CFF;color:white;font-size:13px;width:100%;height:25px" onclick="doFilter('vacant')" class="button10g">
				 <cf_tl id="View Vacant Posts"></button></td>
			 </tr>
			---> 
			<tr class="labelmedium2"><td><img src="#client.root#/images/finger.png" style="height:23px" alt="" border="0"></td>
	             <td style="padding-left:4px">
	         	 <button style="background-color:1A8CFF;color:white;font-size:13px;width:100%;height:25px" onclick="doFilter('contract')" class="button10g">
				 <cf_tl id="All Expiring contracts"></button></td>
			 </tr>
			</table>
		</td>
		</tr>
	</cfoutput>
	
	<tr class="labelmedium2"><td style="border-bottom:1px solid silver" colspan="3"><cf_tl id="Selected units"></td></tr>
				
	<cfif Units.recordcount lte "22">
	
	    <tr style="height:20px"><td valign="top">
	
			<table align="left" style="width:100%" class="navigation_table">
					
			<cfoutput query="Units">		
							
					<cfset cnt = "-1">
					<cfloop index="itm" list="#hierarchyCode#" delimiters="."><cfset cnt = cnt+1></cfloop>	
					<cfif cnt eq "0">
						<tr class="labelmedium linedotted" style="height:15px;background-color:f1f1f1">
						<td style="height:30px;padding-top:1px;padding-bottom:2px;padding-left:2px;font-size:16px;font-weight:bold" align="center" colspan="2">#OrgUnitNameShort#</td>
					<cfelse>		
						<tr class="labelmedium linedotted navigation_row">	
						<cfif cnt eq "1">
						   <cfset st = "background-color:6688aa;font-size:12px;">
						<cfelseif cnt gte "3">
						   <cfset st = "background-color:B0D8FF;font-size:11px;">
						<cfelse>
						   <cfset st = "background-color:1A8CFF;font-size:12px;">   
						</cfif>
																		
						<td style="padding-left:2px;height:100%;padding-right:4px">				
						<cfloop index="itm" from="1" to="#cnt#"><span style="border:0.5px solid white;border-right:0px;min-width:8px;height:100%;#st#">&nbsp;&nbsp;</span></cfloop>
					    </td>
						<cfif cnt eq "1">
						   <cfset st = "font-weight:bold;font-size:12px;">
						<cfelseif cnt gte "3">
						   <cfset st = "font-style: italic;font-size:11px;">
						<cfelse>
						   <cfset st = "font-size:12px">   
						</cfif>
						<td style="#st#;padding-top:1px;padding-right:3px">#OrgUnitName#</td>
					</cfif>
						
					<td valign="top" style="padding-top:2px;padding-left:1px;padding-right:2px">
					
					<cfset orgs = valueList(Access.OrgUnit)>					
					<cfif find(orgunit,orgs)> 
						<input style="width:17px; cursor:pointer;" 
						   type="checkbox" name="unit" id="unit_#orgunit#" class="clsFilterUnit" value="'#OrgUnit#'" <cfif find(orgunit,session.portalorgunit)>checked</cfif>>
				    </cfif>
				   
					</td>
				</tr>
			
			</cfoutput>
			
			<tr>
				<td colspan="3" style="padding-top:4px">
			    <table class="formspacing" style="width:100%;padding-top:5px">
					<tr><td><button onclick="doFilter('unit')" style="background-color:1A8CFF;color:white;font-size:15px;width:100%;height:35px" class="button10g"><cf_tl id="Show Selected Units"></button></td></tr>
				</table>
			    </td>
			</tr>
			
			</table>
			
		</td></tr>	
		
	<cfelse>
	
		<!--- many orgunit, we scroll --->
	
		<tr style="height:20px"><td style="width:100%;height:100%">

		<cf_divscroll>
	
			<table align="left" style="width:96%" class="navigation_table">
					
			<cfoutput query="Units">		
							
					<cfset cnt = "-1">
					<cfloop index="itm" list="#hierarchyCode#" delimiters="."><cfset cnt = cnt+1></cfloop>	
					<cfif cnt eq "0">
						<tr class="labelmedium linedotted" style="height:15px;background-color:f1f1f1">
						<td style="height:30px;padding-top:1px;padding-bottom:1px;padding-left:1px;font-size:16px;font-weight:bold" align="center" colspan="2">#OrgUnitNameShort#</td>
					<cfelse>		
						<tr class="labelmedium linedotted navigation_row">	
						<cfif cnt eq "1">
						   <cfset st = "background-color:6688aa">
						<cfelseif cnt gte "3">
						   <cfset st = "background-color:B0D8FF">
						<cfelse>
						   <cfset st = "background-color:1A8CFF">   
						</cfif>
						<td style="padding-left:1px;font-weight:bold;font-size:13px;height:100%;padding-right:4px">				
						<cfloop index="itm" from="1" to="#cnt#"><span style="border:0.5px solid white;border-right:0px;min-width:8px;height:100%;#st#">&nbsp;&nbsp;</span></cfloop>
					    </td>
						<cfif cnt eq "1">
						   <cfset st = "font-weight:bold">
						<cfelseif cnt gte "3">
						   <cfset st = "font-style: italic;">						   
						<cfelse>
						   <cfset st = "">   
						</cfif>
						<td style="#st#;font-size:12px;padding-top:2px;padding-right:3px">#OrgUnitName#</td>
					</cfif>
						
					<td valign="top" style="padding-left:1px;padding-right:2px">
						<input style="width:17px; cursor:pointer;" 
						   type="checkbox" name="unit" id="unit_#orgunit#" class="clsFilterUnit" value="'#OrgUnit#'" <cfif find(orgunit,session.portalorgunit)>checked</cfif>>
					</td>
				</tr>
			
			</cfoutput>
			
			</table>
		
		</cf_divscroll>
	
		</td></tr>	

		<tr><td colspan="3" style="padding-top:4px">
		    <table class="formspacing" style="width:100%;padding-top:5px">
				<tr><td><button onclick="doFilter('unit')" style="background-color:1A8CFF;color:white;font-size:15px;width:100%;height:35px" class="button10g"><cf_tl id="Show Selected Units"></button></td></tr>
			</table>
		</td></tr>
				
	</cfif>	

</table>

<cfset ajaxonload("doHighlight")>


