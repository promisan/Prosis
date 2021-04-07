<table width="100%">
												  													   
<cfset dateob=CreateDate(URL.year,URL.month,"1")>			

 <cfquery name="action" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  
		SELECT 	 *,
				
			(SELECT  TOP 1 ObjectKeyValue4 
			 FROM    Organization.dbo.OrganizationObject 
			 WHERE   ObjectKeyValue4 = A.OrgUnitActionId
			 AND     EntityCode = 'OrgAction' 
			 AND     Operational = 1) as Workflow		
						
		FROM 	  Organization.dbo.OrganizationAction A
		WHERE     OrgUnit           = '#URL.ID0#'
		AND       CalendarDateStart = #DateOb#
		AND       WorkAction = 'Attendance'
		ORDER BY  Created
						
  </cfquery>		
  
  <cfoutput>
  					  											   
  <cfif action.recordcount gte "1">
  
	  <input type="hidden" 
	   name="workflowlink_#action.orgunitactionid#" 
	   id="workflowlink_#action.orgunitactionid#" 	   
	   value="OrganizationWorkflow.cfm">	
   
	   <tr>
	  										  											
	   	   <td style="height:26px;padding-left:25px;padding-right:20px;min-width:300px;padding-top:1px" valign="top">
	
			   <table width="100%" style="height:25px;border-top:1px solid silver;background-color:f1f1f1">
			
			        <!---
				   <tr class="line labelmedium">										      
					  <td style="min-width:100"><cf_tl id="Mode"></td>
					  <td style="min-width:100"><cf_tl id="Action"></td>
					  <td style="min-width:100%"><cf_tl id="Period"></td>
				      <td style="min-width:180"><cf_tl id="Officer"></td>
				      <td style="min-width:100"><cf_tl id="Date"></td>
				   </tr>
				   --->
				   														     
				   <cfloop query="Action">
					   <tr class="labelmedium2">
					     
						 <td>
							 <table>
								 <tr style="height:30px" class="labelmedium2">
								 <td>
								 <cfif actionstatus eq "0">
								 <input type="radio" class="radiol" name="content" checked value="1" onclick="Prosis.busy('yes');timesheet('#dateformat(dateob,client.datesql)#','unit','#URL.ID0#','0','false','function(personNo, pType) { scheduleCopy(personNo, pType); }', 'function(personNo) { scheduleRemove(personNo); }');">
								 <cfelse>
								 <input type="radio" class="radiol" name="content" checked value="1" onclick="Prosis.busy('yes');timesheet('#dateformat(dateob,client.datesql)#','unit','#URL.ID0#','0','false','','');">								
								 </cfif>
								 </td>
								 <td style="padding-left:4px"><cf_tl id="Detailed schema"></td>
								 <cfif now() gte action.CalendarDateStart>
								 <td style="padding-left:10px"><input type="radio" class="radiol" name="content" value="1" onclick="showworkflow('#orgunitactionid#')"></td>
								 <td style="padding-left:4px"><cf_tl id="Submission flow"></td>
								 </cfif>
								 </tr>
							 </table>
						 </td>
						 <td>#WorkAction#</td>
						 <td>#DateFormat(CalendarDateStart, CLIENT.DateFormatShow)# - #DateFormat(CalendarDateEnd, CLIENT.DateFormatShow)#</td>
					     <td>#OfficerFirstName# #OfficerLastName#</td>
					     <td>#DateFormat(Created, CLIENT.DateFormatShow)#</td>
					   </tr>  
				   </cfloop>
			   
			   </table>	
	   
	       </td>	
		   
		</tr>   
   
   </cfif>
   
</cfoutput>   
   
</table>