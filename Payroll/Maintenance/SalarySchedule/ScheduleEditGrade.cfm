<cfquery name="SelectGrade"
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   R.*
		FROM     Ref_PostGrade R
		WHERE    PostGradeContract = 1	
		ORDER BY PostOrder
	</cfquery>
	
	<table width="100%">
	<tr>
	
	<td valign="top">
	
		<table width="100%" align="center">
	
			<tr class="line"><td height="21" align="center" class="labelmedium2">Service Levels to be covered</td></tr>		
						
			<tr><td align="center">
			
				<table width="96%" border="0" align="center">			
				
					  <cfset row = 1>
					  
				      <cfoutput query="SelectGrade">
					   
					       <cfif row eq 1><tr style="height:14px" class="labelmedium2 line"></cfif> 	  
					      			
							  <cfquery name="check"
				              datasource="AppsPayroll" 
				              username="#SESSION.login#" 
				              password="#SESSION.dbpw#">
					          	  SELECT   *
						          FROM     SalaryScheduleServiceLevel
								  WHERE    ServiceLevel   = '#PostGrade#'
								  AND      SalarySchedule = '#url.id1#'
								  AND      Operational = 1
				             </cfquery>
							 
						    <td style="padding-left:4px;width:30px" align="left" width="1%" valign="top" bgcolor="<cfif #check.recordcount# neq "0">yellow</cfif>">						  		  
								 
								  
								<input type="checkbox" 								  
								   name="selectedgrade" class="radiol"
								   value="#SelectGrade.PostGrade#" <cfif check.recordcount gte "1">checked</cfif>>
										   
							</td>			
							 
							<td width="25%" bgcolor="<cfif #check.recordcount# gte "1">yellow</cfif>">#SelectGrade.PostGrade#</td>
							<td width="5%" style="padding-right:40px" bgcolor="<cfif #check.recordcount# gte "1">yellow</cfif>">#Postgradesteps#</td>
							 													
							<cfset row = row + 1>
						    <cfif row eq "4">
					            </tr>
					            <cfset row = 1>
				    	    </cfif>
							 
					  </cfoutput> 
		
				  </table>
	 				
				</td>
			</tr>
		
		</table>
	
	</td>
	</table>