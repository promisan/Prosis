<cfoutput>


		<cfif prior gte AssignmentStart and cls neq "" and Incumbency neq "0">
		
		<tr><td bgcolor="white"></td>
		    <td colspan="11" align="center" bgcolor="FF0000">
			<font color="white">Attention: Assignment period overlaps with prior record	  					 
			</td>
		</tr>
			
		<cfelseif (prior+1) lt AssignmentStart and cls neq "">
		
		<tr><td bgcolor="white"></td>
		    <td colspan="11" align="center" bgcolor="E8FFE8">
			<font color="black"><b>Attention:</b>  No post assignment for period (#dateformat(prior+1,CLIENT.DateFormatShow)# - #dateformat(assignmentstart-1,CLIENT.DateFormatShow)#)						 
			</td>
		</tr>
			
		</cfif>

		<tr><td bgcolor="white"></td>
				
			<cfif AssignmentStart lte now() and AssignmentEnd gte now()>
			  <cfset cl = "ffff9f">			  
			<cfelse> 
			  <cfset cl = "f9f9f9">	
			</cfif>
			
			<td bgcolor="#cl#">
			
				<table width="100%"  cellspacing="0" cellpadding="0">
				<tr>
				<td width="70">
				   <a title="Edit assignment" href="javascript:EditAssignment('#PersonNo#','#AssignmentNo#','#PositionNo#','#PositionParentId#')">
					   #IndexNo#
					</a>
				</td>
				<td>			
				 <a title="Edit assignment" href="javascript:EditAssignment('#PersonNo#','#AssignmentNo#','#PositionNo#','#PositionParentId#')">
				    <!--- KRW: 070408: highlight GTA assignments --->		
					<cfif AssignmentClass eq "GTA"><font color="FF0000"></cfif>
				    #LastName#, #FirstName#					
				 </a>
				</td>
				<td align="center" width="50" bgcolor="<cfif incumbency lt '100'>red</cfif>">
				<cfif incumbency lt "100"><font color="FFFFFF"></cfif>#incumbency#%
				</td>
				</tr></table>	
			</td>
			
			<td bgcolor="#cl#">#Gender#</td>
			<td bgcolor="#cl#">#Nationality#</td>
			<td bgcolor="#cl#" width="60"><cfif ContractLevel neq "">#ContractLevel#/#ContractStep# <cfif contractTime neq "100">#contractTime#%</cfif><cfelse><font color="FF0000">N/A</font></cfif></td>
			<td bgcolor="#cl#" width="60"><cfif PostAdjustmentLevel neq "">#PostAdjustmentLevel#/#PostAdjustmentStep#<cfelse><font color="FF0000">N/A</font></cfif></td>			
			<td bgcolor="#cl#" align="center">#DateFormat(AssignmentStart,CLIENT.DateFormatShow)#</td>
			<td bgcolor="#cl#" align="center">#DateFormat(AssignmentEnd,CLIENT.DateFormatShow)#</td>																
			<td bgcolor="#cl#"></td>
			<td bgcolor="#cl#"></td>
		</tr>
		
		<cfif AssignmentStart eq AssignmentEnd>
		
		<tr><td bgcolor="white"></td>
		    <td colspan="9" align="center" bgcolor="FFCFB9">
			<font color="black">One day assignment
			
				<img src="#SESSION.root#/Images/delete5.gif"
			     alt="Remove One day Assignment"
				 height="11" width="11"
				 onclick="refresh('#PositionParentId#','assignmentdelete','#AssignmentNo#')"
			     border="0"
				 align="absmiddle"
			     style="cursor: pointer;">
				 
			</td></tr>
	
		</cfif>
		
		<cfif FunctionNoAss neq FunctionNo>
		
		<tr><td bgcolor="white"></td>
		    <td colspan="9" align="left" bgcolor="ffffef">
			<font color="black">#FunctionDescriptionAss#
			</td></tr>
	
		</cfif>
				
		<cfset prior = AssignmentEnd>
		<cfset cls   = AssignmentClass>
		
		<cfif AssignmentEnd gt now()>
			  <cfset vac = 0>
		</cfif>

</cfoutput>