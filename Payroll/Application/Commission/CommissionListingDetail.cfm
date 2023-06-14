
 <table width="100%" class="navigation_table">
 
	 <tr><td>
	 
		 <table width="100%" class="navigation_table">
		 
		        <!---
								 
				<cfquery name="Object" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   * 
				    FROM     OrganizationObject
					WHERE    ObjectKeyValue4 =  '#URL.AjaxId#'
				</cfquery>
				
				<cfquery name="Get" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    	SELECT *
					    FROM   OrganizationAction
						WHERE  OrgUnitActionId = '#URL.AjaxId#'
				</cfquery>
				
				<cfquery name="Unit" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
				    	SELECT *
					    FROM   Organization
						WHERE  OrgUnit = '#get.OrgUnit#'
				</cfquery>				 
				
				--->
				
				<cfparam name="url.SalarySchedule"    default="#form.salaryschedule#">				
				<cfparam name="url.CalendarDateEnd"   default="12/31/2022">
				<cfparam name="url.CalendarDateStart" default="12/01/2022">
				<cfparam name="url.PayrollItem"       default="#form.payrollitem#">
				<cfparam name="url.Class"             default="#form.entitlementclass#">
				
				<cfoutput>#url.class#</cfoutput>
				
				<!--- we check if the selection in the header 1 or more records in the table --->
				
				<cfquery name="Get" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">							
					
					SELECT      OrgUnitActionId
					FROM        PersonMiscellaneous AS M INNER JOIN
					            Organization.dbo.OrganizationAction AS A ON M.SourceId = A.OrgUnitActionId
					WHERE       A.OrgUnit             = '#url.orgunit#' 
					AND         A.CalendarDateEnd     = '#url.CalendarDateEnd#'
					AND         A.WorkAction          = '#url.salaryschedule#'
					AND         M.PayrollItem         = '#url.PayrollItem#'
					AND         M.EntitlementClass    = '#url.Class#'			 
					AND         M.Source              = 'Unit'					
				</cfquery>	
						 
				<cfquery name="getPersons" 
					  datasource="AppsEmployee" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  SELECT 	DISTINCT P.PersonNo, 
								        P.LastName, 
										P.ListingOrder,
										P.FirstName, 
										A.FunctionDescription, 
										A.LocationCode,
										P.IndexNo, 
										A.AssignmentNo, 
										A.DateEffective, 
										A.DateExpiration,
										
										(SELECT   TOP 1 ContractLevel
										 FROM     PersonContract
										 WHERE    PersonNo     = P.PersonNo
										 AND      Mission      = Pos.Mission
										 AND      ActionStatus IN ('0','1')
										 AND      DateEffective <= '#url.CalendarDateEnd#'
										 ORDER BY DateEffective DESC) as PersonGrade
										 
					  FROM 	Person P 
					        INNER JOIN PersonAssignment A ON P.PersonNo = A.PersonNo
							INNER JOIN Position Pos ON A.PositionNo = Pos.PositionNo
								
					  WHERE   P.PersonNo = A.PersonNo
					  <!--- the unit of the operational assignment --->
					  AND     A.OrgUnit = '#url.orgunit#'
					  -- AND     A.Incumbency       > '0'
					  AND     A.AssignmentStatus IN ('0','1')
					  -- AND     A.AssignmentClass  = 'Regular'	<!--- not needed anymore as loaned people have leave as well --->		
					  AND     A.AssignmentType   = 'Actual'
					  AND     A.DateEffective   <= '#url.CalendarDateEnd#'
					  AND     A.DateExpiration  >= '#url.CalendarDateStart#'							
				 </cfquery>	
				 
				 <tr class="labelmedium2 line fixlengthlist">
				     <td style="padding-left:4px"><cf_tl id="IndexNo"></td>
					 <td><cf_tl id="FirstName"></td>
					 <td><cf_tl id="LastName"></td>
					 <td><cf_tl id="Function"></td>
					 <td><cf_tl id="Contract"></td>
					 <td><cf_tl id="Prior"></td>
					 <td style="width:90px"><cf_tl id="Amount"></td> 		
					 <td><cf_tl id="Memo"></td> 	 
				 </tr>
				 
				 <cfoutput query="getPersons">
				 
				    <cfquery name="getAmount" 
					  datasource="AppsPayroll" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">				 
					     SELECT     Amount, Status
		  	             FROM       PersonMiscellaneous
		      	         WHERE      PersonNo = '#Personno#'
						 AND        Source    = 'Unit' 
						 <cfif get.OrgUnitActionId neq "">
						 AND        SourceId  = '#get.OrgUnitActionId#'
						 <cfelse>
						 AND        1=0
						 </cfif>
					 </cfquery>
				 
					 <tr class="labelmedium2 line navigation_row fixlengthlist">
					     <td style="padding-left:4px">#IndexNo#</td>
						 <td>#FirstName#</td>
						 <td>#LastName#</td>
						 <td>#FunctionDescription#</td>
						 <td>#PersonGrade#</td>
						 <td></td>
						 <td><input type="text" class="regularxl" style="max-width:90px;min-width:80px;border-bottom:0px;border-top:0px;background-color:##e1e1e180;text-align:right;padding-right:4px" name="#PersonNo#_Amount" value="0"></td>			 
						 <td><input type="text" class="regularxl" style="width:100%;min-width:120px;border-bottom:0px;border-top:0px;background-color:##e1e1e180;padding-left:4px" name="#PersonNo#_DocumentReference" value=""></td>			 
						
					 </tr>			 
				 
				 </cfoutput>
				 
		 </table>	
	 
	 </td>
	 </tr>
 
	 <tr>
	 <td align="center" style="padding-top:5px"><input type="button" style="width:200px" class="button10g" name="Submit" value="Submit"></td></tr>
		
						
	 <tr><td style="padding-left:4px;padding-right:4px">
			
			<cfif get.OrgUnitActionId neq "">
			
			    <cfset url.ajaxid = get.OrgUnitActionId>
				
				<cfset link = "Payroll/Application/Commision/CommisionListing.cfm?ajaxid=#url.ajaxid#&ID0=#get.OrgUnit#&ID2=#Object.Mission#">
						
				<cf_ActionListing 
					    EntityCode       = "OrgAction"
						EntityClass      = "Entitlement"
						EntityGroup      = ""
						EntityStatus     = ""		
						Mission          = "#Object.Mission#"
						OrgUnit          = "#get.OrgUnit#"
						ObjectReference  = "Miscellneous #Unit.OrgUnitName# #dateformat(get.CalendarDateStart,'YYYY/MM')#"			    
						ObjectKey4       = "#URL.AjaxId#"
						AjaxId           = "#URL.AjaxId#"
						ObjectURL        = "#link#"
						Show             = "Yes"		
						Toolbar          = "Yes">
					
			</cfif>		
					
					
			</td></tr>		 
			
</table>			

<cfset ajaxonload("doHighlight")>