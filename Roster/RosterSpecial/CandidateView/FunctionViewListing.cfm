
<cfparam name="url.source" default="">

<cfoutput>

	<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formspacing">	 												 
	
		<cfparam name="url.view" default="LastName">
		
		<cfif url.source eq "">
		
		<tr class="line">
		
			 <cfif expand eq "1">
			 		
				<td class="labelmedium" style="font-weight:200;font-size:20px;height:30px;padding-left:5px;padding-right:4px">										
				<font color="black">#Meaning# (#Status#) <cfif Meaning neq ProcessMeaning>at status: <b>#ProcessMeaning#</b></cfif>				
				
				</td>
			
			<cfelse>
							
				<td colspan="1" class="labelmedium" style="font-weight:200;font-size:20px;height:30px;padding-left:10px;padding-right:5px">
				#Meaning# (#Status#) <cfif Meaning neq ProcessMeaning>at status: <b>#ProcessMeaning#</b></cfif>
				</td>	
						
			</cfif>								 				
						
		
		  <td height="35" width="260" align="right">
		  
		    <table cellspacing="0" cellpadding="0">
			<tr>
					
			<td style="padding-left:0px">
			<input type="button" class="button10g" name="Export" value="Export" style="height:25;width:120" onclick="listing('#url.tab#','#day##Status#_#ProcessStatus#','show','#Day#','#Status#','#ProcessStatus#','','#total#','#process#','1',document.getElementById('view').value,'3')">
			</td>
					
			<td style="padding-left:3px">
			<input type="button" class="button10g" name="Print" value="Print" style="height:25;width:120" onclick="listing('#url.tab#','#day##Status#_#ProcessStatus#','show','#Day#','#Status#','#ProcessStatus#','','#total#','#process#','1',document.getElementById('view').value,'1')">
			</td>
			<td style="padding-left:3px">
			<input type="button" class="button10g" name="Print" value="Broadcast" style="height:25;width:120" onclick="broadcast('#url.idfunction#','#url.status#')">
			</td>
			<td style="padding-left:3px">
			<input type="button" class="button10g" id="refresh" name="refresh" value="Refresh" style="height:25;width:120" 
			     onclick="listing('#url.tab#','#day##Status#_#ProcessStatus#','show','#Day#','#Status#','#ProcessStatus#','','#total#','#process#','1',document.getElementById('view').value,'0')">
			</td>
						
			<td height="25" colspan="12" id="dmanual" style="padding-left:5px">
	  
			  <select name="view" id="view" size="1" class="regularxl"
			    onChange="listing('#url.tab#','#day##Status#_#ProcessStatus#','show','#Day#','#Status#','#ProcessStatus#','','#total#','#process#','1',this.value,'0')"> 
				 <OPTION value="LastName" <cfif URL.View eq "LastName">selected</cfif>>Name 
				 <OPTION value="Gender" <cfif URL.View eq "Gender">selected</cfif>>Gender 
			     <OPTION value="CreatedA" <cfif URL.View eq "CreatedA">selected</cfif>>Application date (Ascending) 
			     <OPTION value="CreatedD" <cfif URL.View eq "CreatedD">selected</cfif>>Application date (Descending) 
				 <OPTION value="Nationality" <cfif URL.View eq "Nationality">selected</cfif>>Nationality 			
			 </select>
			 
		   </td>
		   </tr>	
		   		
		   </table>					
								
			</td>		
						 			 
			
	  	</TR> 	
					
		</cfif>
		
		<cfif url.source eq "">		
		
			<tr class="regular" id="d#day##Status#_#ProcessStatus#">
					<td height="100%" align="center" colspan="5" id="i#day##Status#_#ProcessStatus#">
						
						<cfset url.box     = "#day##Status#_#ProcessStatus#">
						<cfset url.filter  = "#status#">
						<cfset url.level   = processstatus>									
						<cfinclude template= "FunctionViewListingContent.cfm">
						
					</td>
			</tr>
		
		<cfelse>
		
		<!--- manual --->
		
		<tr class="regular" id="dmanual">
				<td height="100%" colspan="5" id="imanual" align="center">								
					<cfinclude template= "FunctionViewListingContent.cfm">
				</td>
		</tr>		
		
		</cfif>
					
	</table>
								
</cfoutput>							