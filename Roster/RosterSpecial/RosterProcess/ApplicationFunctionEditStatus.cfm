
<table width="98%" cellspacing="0" cellpadding="0" align="center">

	
<cfset url.owner  = get.Owner>
<cfset url.status = get.Status>

<cfquery name="FunctionTopic" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT    *
		 FROM      FunctionOrganizationTopic FO LEFT OUTER JOIN ApplicantFunctionTopic A 
		    ON     FO.TopicId = A.TopicId
			AND    A.ApplicantNo = '#URL.ID#'
		  WHERE    FO.FunctionId = '#URL.ID1#'	  
		  ORDER BY Parent, TopicOrder
	</cfquery>

<cfif FunctionTopic.recordcount gte "1">
		
	<tr><td height="3"></td></tr>
		
	<tr>	
		
	    <TD style="padding-left:9px">
		
		  <table width="100%" cellspacing="0" cellpadding="0" align="center">
			 		 
			  <cfoutput query="FunctionTopic" group="Parent">
			  <tr><td colspan="2" class="labelmedium" style="height:30px;padding-left:8px;">#Parent#</td></tr>
				  <cfoutput>
				  <tr><td colspan="2" style="border-top:1px dotted gray"></td></tr>
				  <tr>					
					<td style="padding:2px; padding-left:12px;" class="labelit">#TopicPhrase#</td>
					<td align="center" style="padding:2px;" height="100%"><b>
						<table cellspacing="0" cellpadding="0" width="100%" height="100%">
							<tr>
							<td bgcolor="f4f4f4" height="100%" style="border:0px solid gray" align="center" class="labelmedium">
							<cfswitch expression="#TopicValue#">
								<cfcase value="">N/A</cfcase>
								<cfcase value="0"><font color="red">No</cfcase>
								<cfcase value="1"><font color="green">Yes</cfcase>
							</cfswitch>
							</td>
							</tr>
						</table>
					</td>
				  </tr>
				  <cfif TopicMemo neq "">
				  <tr>
				  	<td colspan="2" bgcolor="ffffcf" class="labelmedium" style="padding:3px; padding-left:12px;">
						#TopicMemo#
					</td>
				  </tr>
				  </cfif>
				  </cfoutput>
			  </cfoutput>	
		  </table>
		</TD>
	</TR>
		
	</cfif>

    <TR id="move">
	    <TD class="labelmedium">
			<table cellspacing="0" width="100%" cellpadding="0">
				
				<tr><td height="4"></td></tr>
				<!--- 
				<tr>
				<td class="labelmedium"><i>Set roster status:</td></tr>
				--->
				<tr>
				
								   
				<TD colspan="1" style="padding:3px">
														
					<input type="hidden" id="statusold" name="statusold" value="<cfoutput>#Get.Status#</cfoutput>">
					<input type="hidden" id="statusnew" name="statusnew" value="<cfoutput>#Get.Status#</cfoutput>">
								
					<table width="100%" cellspacing="0" cellpadding="0" bgcolor="ffffff">
					
					    <!--- processbox --->
					    <tr class="xxhide"><td id="processbox"></td></tr>
						
						<tr>						
						<td width="160" valign="top" id="setstatusbox" style="padding:8px">
						
						<cf_ApplicationFunctionEditStatusAction
							owner         = "#get.owner#"
							functionid    = "#get.FunctionId#"
							applicantno   = "#get.ApplicantNo#"
							currentstatus = "#get.Status#">
													
						</TD>
						
						<td valign="top" style="padding:7px">	
						
							<table width="95%" align="right">
								
								<tr id="boxstatusdate" class="xxhide">
								
									 <td class="labelit" style="width:80px"><cf_tl id="Effective">:<font color="FF0000">*</font></td>
									 <td>
									  
									  <cf_intelliCalendarDate9
										FieldName="StatusDate" 
										Manual="True"											
										Default=""
										class="regularxl"
										AllowBlank="True">	
									  
									 </td>
														
								</tr>
								
								<!--- show the reasons as ajax --->
								<tr><td colspan="2">
									<cfdiv id="reason" bind="url:#SESSION.root#/Roster/RosterSpecial/RosterProcess/ApplicationFunctionEditReason.cfm?status=#get.Status#&owner=#url.Owner#&functionid=#get.FunctionId#&applicantno=#URL.ID#">
								</td></tr>
								
							</table>
							
						</td>
						
						<td></td>
						
						</tr>
						
					</table>
				</td>
			</tr>
								
			</table>
	    </TD>
	</tr>
	
	 <!--- add candidates to the default roster --->
	   	   
	   <cfif Parameter.EnableRosterTransfer eq "0" or 
	         <!---
	         Parameter.DefaultRosterAdd or 
			 --->
			 FullAccess eq "NONE">
	   
	   	<!--- don't show transfer ; only roster manager --->
	   
	   <cfelse>
	  
	   <tr><td height="4"></td></tr>
	 			
		<TR class="line">		
		    <td colspan="2" style="padding-top:2px;padding-bottom:2px" class="labelit"><b>I believe this person is also suitable for:</td>			
		</tr>	
		
		<tr>
			
			<td colspan="2" style="padding:3px;">			
				<table width="100%" border="0" id="roster">
					<tr><td style="height:150;padding:3px">
					<cf_divscroll style="height:140">
					     <cfinclude template="ApplicantRosterEntry.cfm">
					</cf_divscroll>
					</td></tr>
				</table>			
		    </td>
			
		</tr>	
		
		</cfif>
							
	    <cfif cnt gte "1" and go is "1">
	
		<TR><td height="1" colspan="2"></td></tr>
			
		<TR><td class="labelit" style="padding:2px"><cf_tl id="Decision Remarks">:</td></tr>
		<tr><td colspan="2" style="padding-left:2px">

		    <textarea class="regular" 
		          cols="75" 
				  style="width:99%;font-size:13px;padding:3px" 
				  rows="3" 
				  name="ActionRemarks" 
				  type="text"><cfoutput query="Get" maxrows=1>#RosterGroupMemo#</cfoutput></textarea>
				  
	   </TD></tr>				   						       				
	   	   
	  <TR><td height="5" colspan="2"></td></tr>
	   <tr>
		   <td colspan="2" style="padding-left:2px">
		   
	    	 <cf_filelibraryN
				DocumentPath="Roster" SubDirectory="#get.FunctionId#" 
				Filter="#URL.ID#" Insert="yes" Remove="yes"	Highlight="no" Listing="yes">

				</td>
		</tr>
	   	   
	   </cfif>
	   	    
	   <cfif url.Mode neq "Print" and go eq "1">
	
	   <tr><td style="height:4px"></td></tr>	
	   <tr><td colspan="2" class="line"></td></tr>
	   
	   <TR><td height="40"
			    colspan="2"
			    align="center"
			    id="savePanel">	
						
		    <input type="button" name="Process" value="Submit" style="width:140;height:28" class="button10g" onclick="return ask('open')">					 
			<input type="button" name="ProcessC" value="Submit and Close" style="width:140;height:28" class="button10g" onclick="return ask('close')">
			
			</td>
		</tr>
		
	   </cfif>  
	   	   
</table>
		 