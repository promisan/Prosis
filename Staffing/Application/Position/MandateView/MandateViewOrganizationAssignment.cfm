

<cfoutput>

   <cfset descp = FunctionDescription>
   <cfset orgcp = OrgUnitOperational>
   	
	 <cfif LastName neq "">
	 
	 <table width="100%" align="center">
	 	 
	 <cfset color = "f4f4f4">
	 	 
	 <cfif AssignmentStatus eq "0" and Mandate.MandateStatus eq "1">
	    <cfset color = "ffffcf">		
	 </cfif>	
	 			
		 <TR bgcolor="#color#" class="labelmedium line" style="height:20px">
			
			<TD width="4%" style="padding-left:10px">
			<cfif url.pdf eq "0">
				<cfif Mandate.MandateStatus eq "0"
				      and ((AccessPosition eq "EDIT" or AccessPosition eq "ALL") or (AccessStaffing eq "EDIT" or AccessStaffing eq "ALL"))>
				
					  <cfset batch = "1">
					  <input type="checkbox" style="height:13px;width:13px" name="AssignmentNo" value="#AssignmentNo#">
				
				<cfelse>
					<cfif Extension neq "">
								
					    <cfif Dateformat(DateExpirationAssignment, CLIENT.DateFormatShow) eq Dateformat(Mandate.DateExpiration, CLIENT.DateFormatShow)>
										
							<img src="#SESSION.root#/Images/reminder.png" height="13" alt="Extension requested" border="0">
						
						<cfelse>
						
						  <cfquery name="clean" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							DELETE FROM PersonExtension
							WHERE  PersonNo  = '#PersonNo#'
							AND    Mission   = '#Mandate.Mission#'
							AND    MandateNo = '#MandateNo#'
							AND    PersonNo NOT IN (SELECT PersonNo 
							                        FROM   PersonAssignment
													WHERE  DateExpiration = '#Dateformat(Mandate.DateExpiration, CLIENT.DateSQL)#'
													AND    AssignmentStatus IN ('0','1')
												   )	
						</cfquery>				
						
						</cfif>
					</cfif>	
				</cfif>
			</cfif>
			</td>		
			
			<td width="20" align="center"style="padding-right:4px">-</td>
			<TD width="36%" class="fixlength">
			<cfif (AccessStaffing eq "EDIT" or AccessStaffing eq "ALL") AND URL.PDF eq 0>
			    <a title="Edit assignment" href="javascript:EditAssignment('#PersonNo#','#AssignmentNo#','#PositionNo#','i#positionNo#')">				
			</cfif>		
			#FirstName# #LastName#</a>
			</TD>
			
			<td width="12%" class="labelit">
			<cfif URL.PDF eq 0>
				<a href="javascript:EditPerson('#PersonNo#')">#IndexNo#</a>
			<cfelse>
				#IndexNo#
			</cfif>
			</td>
			<td style="min-width:140px">#ContractLevel#/#ContractStep# <cfif contractTime neq "100">#contractTime#%</cfif></td>
			<td width="5%">#PostAdjustmentLevel#/#PostAdjustmentStep#</td>
			<td width="4%">#Gender#</td>
			<td width="3%">#Nationality#</td>
			<td width="5%" align="center">#Incumbency#</td>
			<td width="12%">#Dateformat(DateEffectiveAssignment, CLIENT.DateFormatShow)#</td>		
			<td width="10%" align="center">#Dateformat(DateExpirationAssignment, CLIENT.DateFormatShow)#</td>
			
		</tr>
	
	<cfif (FunctionDescriptionActual neq descp and FunctionDescriptionActual neq "") or OrgUnit neq orgcp>
		<tr>
		<td bgcolor="ffffcf"></td>
		<td colspan="11" class="labelit" bgcolor="ffffcd" style="padding:2px">
		   <cfif FunctionDescriptionActual neq descp>&nbsp;<b><cf_tl id="Assigned as">:</b> #FunctionDescriptionActual#</cfif> #OrgUnitName#</td>
		</tr>
	</cfif>	
				
	</table>
	
	</cfif>
			 	    
</cfoutput>   