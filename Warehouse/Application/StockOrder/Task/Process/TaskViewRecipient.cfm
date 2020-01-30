
<cfset link = "ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/task/Process/TaskViewRecipientLines.cfm?webapp=#url.webapp#&id=#url.id#&mission=#url.mission#&mode=inquiry','details','','','POST','requestform')">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center">

	<tr><td bgcolor="f4f4f4" style="padding-top:2px;padding-left:6px;padding-bottom:2px;border-left:1px dotted silver;border-right:1px dotted silver;">
				
		<table width="97%" style="padding:1px;border:0px dotted silver" align="center">
		
		<tr><td height="20">
		
		<form name="requestform" id="requestform">
		
		<table style="padding:1px;border:0px dotted silver">
				
			<cfoutput>
			    
				<tr>							
					
					<!--- <td class="labelmedium" style="padding-right:4px"><b><i><cf_tl id="Filter">:</td> --->
					
					<td style="padding:2px" id="selectall">
						<table>
							<tr><td>
							<input type="radio" name="filter" id="filter" value="action" checked onclick="#link#;document.getElementById('selectpending').className='hide'">
							</td>
							<td style="padding:2px" class="labelmedium"><cf_tl id="Pending for Action"></td>
							</tr>
						</table>
					</td>
					
					<td>|</td>
					
					<td style="padding:2px" id="selectall">
						<table>
							<tr><td>
							<input type="radio" name="filter" id="filter" value=""  onclick="#link#;document.getElementById('selectpending').className='regular'">
							</td>
							<td style="padding:2px" class="labelmedium"><cf_tl id="Pending Requests"></td>
							</tr>
						</table>
					</td>
					
					<td style="padding:2px" id="selectpending" class="hide">
					
					<select name="filtersub" id="filtersub" class="regularxl" onchange="#link#">
						<option value="">All</option>
						<option value="Submission"><cf_tl id="New Requests"></option>
						<!--- dynamically added by the loading page --->					
					</select>
					
					</td>	
															
					<td>|</td>	
					
					<td style="padding:2px"  class="xhide">
					
						<table>
						<tr>
						<td style="padding:2px">
						<input type="radio" name="filter" id="filter" value="Completed" onclick="#link#;;document.getElementById('selectpending').className='hide'">
						</td>
						<td style="padding:2px" class="labelmedium"><cf_tl id="Completed Requests"></td>
						</tr>
						</table>
					
					</td>			
								
				</tr>
	
			</cfoutput>
			
		</table>	
		
		</form>		

	</td></tr>
		
	</table>
	</td>
	</tr>
			
	<tr id="pendingheader"><td height="25">
	
		<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" align="center" id="myListing">		  
			
		<tr><td valign="top">
				
		<table width="97%" style="padding-right:15px" height="100%" cellspacing="0" cellpadding="0" align="center">
		
		   <cfinclude template="TaskViewRecipientHeader.cfm">
				
		</table>
		</td>
		</tr>		
		</table>
		</td>
	</tr>	
		
	<tr><td height="100%" valign="top" width="100%" style="padding-top:10px">
			
		<cf_divscroll id="details">	
		     <cfdiv bind="url:#SESSION.root#/warehouse/application/stockorder/task/Process/TaskViewRecipientLines.cfm?webapp=#url.webapp#&id=#url.id#&mission=#url.mission#">			
		</cf_divscroll>
		
	</td></tr>	

</table>
