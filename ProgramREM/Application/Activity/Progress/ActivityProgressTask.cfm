
<cfoutput>

		<!--- ---- --->
		<!--- TASK --->		
		<!--- ---- --->		
		
		<cfif Status eq "Pending" and ActivityDateStart gt now()>
		   <cfset actcolor  = "NotStarted"> <!--- normal --->
		<cfelseif Status eq "Pending" and ActivityDateStart lte now() and ActivityDateEnd gt now()>
		   <cfset actcolor  = "OnSchedule"> <!--- due --->  
		<cfelseif Status eq "Pending" and ActivityDateEnd lte now()>
		   <cfset actcolor  = "Overdue"> <!--- overdue --->
		<cfelseif Status eq "">  
		   <cfset actcolor  = "Completed"> <!--- green --->
		<cfelse>
		   <cfset actcolor = "White">   
		</cfif> 
		<cfset st = Status>		
					
	    <cfset act = act+1>
		
		<cfset ds = ActivityDateStart>

		<cfif url.output eq "1" or Status eq "Pending">
			<cfset de = ActivityDateEnd>
		<cfelse>
			<cfset de = ActivityDate>
		</cfif>
				
		<cfinclude template="ActivityProgressDefine.cfm">		
	
		<tr name="cl#clrow#" id="cl#clrow#" class="line navigation_row">
		
		<cfif url.outputshow eq "0">
		
			<td align="center" style="cursor:pointer" onClick="javascript:showprogress('#activityId#')">
			
			<cf_space spaces="8">
			
			<img src="#SESSION.root#/Images/ArrowRight.gif"
			     alt="Progress"
			     id="max#activityId#"
			     border="0"
				 style="height:13"
				 align="absmiddle"
			     class="regular">
			 
			<img src="#SESSION.root#/Images/ArrowDown.gif"
			     alt="Collapse"
			     id="min#activityId#"
				 style="height:13"
			     border="0"
				 align="absmiddle"
			     class="hide">
			 								 
			</td>
		
		</cfif>
		
		<td style="border-right: 1px solid gray;" style="cursor: pointer;" 
		 onClick="javascript:showprogress('#activityId#')">
		<cf_space spaces="10" label="#currentrow#.">
		</td>
		
		<td style="border-right: 1px solid gray;" class="labelit">
		<cfif ActivityDescription neq "">
		    <cfif len(ActivityDescription) gte 60>
			<cfset vDescription="#left(ActivityDescription,60)#...">
			<cfelse>
			<cfset vDescription=ActivityDescription>
			</cfif>					
		<cfelse>
			<cf_tl id="Undefined" var="1">'
			<cfset vDescription="<font color='red'>(#lt_text#)</font>">
		</cfif>
		
		<cfif currentrow eq "1">
			<cfset spc = "72">
		<cfelse>
		    <cfset spc = "0">
		</cfif>
		
		<cfif (EditAccess eq "Edit" or EditAccess eq "ALL") and (ActivityPeriod eq url.Period)>	
			<cf_space spaces="#spc#" label="#vDescription#" tip="#ActivityDescription#" class="labelit" script="javascript:edit('#activityid#')">
		<cfelse>
			<cf_space spaces="#spc#" label="#vDescription#" tip="#ActivityDescription#" class="labelit">
		</cfif>
		
		</td>		
								
		<td style="border-right: 1px solid gray;" class="labelit">
		
		<cfif currentrow eq "1">
			<cfset spc = "23">
		<cfelse>
		    <cfset spc = "0">
		</cfif>
		
		<cf_space align="center" spaces="#spc#" label="#DateFormat(ActivityDateStart, CLIENT.DateFormatShow)#"></td>
		
		<td style="border-right: 1px solid gray;" class="labelit">
		<cfif url.output eq "1" or Status eq "Pending">
			<!--- the real planned date ---->
			<cf_space align="center" spaces="#spc#" class="labelit" label="#DateFormat(ActivityDateEnd, CLIENT.DateFormatShow)#">
		<cfelse>
			<cf_space align="center" spaces="#spc#" class="labelit" label="#DateFormat(ActivityDate, CLIENT.DateFormatShow)#">
		</cfif>	
		</td>
		
		<td style="border-right: 1px solid gray;">
		
		<cfif currentrow eq "1">
			<cfset spc = "14">
		<cfelse>
		    <cfset spc = "0">
		</cfif>
		
		<cftry>
		
			<cfif url.output eq "1" or Status eq "Pending">
				<cfset vduration = ActivityDateEnd - ActivityDateStart  + 1>		
				<cf_space align="center" spaces="#spc#" label="#vduration#d">
			<cfelse>
				<cf_space align="center" spaces="#spc#" label="#ActivityDays#d">
			</cfif>
		
			<cfcatch></cfcatch>
		
		</cftry>
		
		</td>
		
		<cfset ln = 0>
		
		<td>
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
		
		<cfloop index="itm" from="1" to="#Mth#">		
				   
			<td style="border-left: 1px dotted gray;">
			
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			
			<cfloop index="wk" from="1" to="4">	
				
				<cfset ln = ln+1>		
				
				<cfif ln gte elmS AND ln lte elmE>
				    <cfset color = actcolor>
				<cfelse>
					<cfset color = "white">
			   </cfif>	
			   
			   <cfif ln lte elmC>	
			      <cfset bc = "ffffcf"> 
			   <cfelse>
			      <cfset bc = "f4f4f4">
			   </cfif>
			  		  				
				<td width="25%" style="font-size:2px" bgcolor="#bc#">
				
				&nbsp;  <!--- Hanno 12/10/2015 do not removed &nbsp; --->
				
					<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
					
					<cfif color eq "white">
					
						<tr>
						<td>
						<cfif ln eq "1">	
						   <cfdiv id="dep#activityid#" class="hide" style="position:absolute; width:180px; z-index:1; border: 1px solid gray; ">							
						</cfif>
						</td>
						</tr>	
					
					<cfelse>
					
					<tr><td height="4">				
									
						<cfif ln eq "1">	
						   <cfdiv id="dep#activityid#" class="hide" style="position:absolute; width:180px; z-index:1; border: 1px solid gray; ">							
						</cfif>
					
					</td></tr>
					
					<cfif ln eq elmS and ln eq elmE>
					
					    <cfif dependent gte "1">
												
							<tr>
							<td height="10" class="connector" onclick="showdep('#activityid#','dep#activityid#')"><td>												
							</tr>
							
						<cfelse>
						
							<tr><td height="10" id="bar#ActivityId#" class="#color#" style="border-left: 1px solid Black;border-right: 1px solid Black;"></td></tr>
							
						</cfif>
								
					<cfelseif ln eq elmS>
						<cfif dependent gte "1">						
							
							<tr>											
							<td height="10"
								class="connector"  onclick="showdep('#activityid#','dep#activityid#')">																												
							</td>						
							</tr>
							
						<cfelse>
							<tr><td height="10" id="bar#ActivityId#" class="#color#" style="border-left:1px solid black;border-top-left-radius:15px;border-bottom-left-radius:15px"></td></tr>
						</cfif>
					<cfelseif ln eq elmE>
						<tr><td height="10" id="bar#ActivityId#" class="#color#" style="border-right:1px solid Black;border-top-right-radius:15px;border-bottom-right-radius:15px"></td></tr>							
					<cfelse>
						<tr><td height="10" id="bar#ActivityId#" class="#color#"></td></tr>
					</cfif>
					<tr><td height="4"></td></tr>				
					</cfif>
					
					</table>	
				
				</td>
				
			</cfloop>
			</tr>	
			</table>	
			</td>
		</cfloop>
		</tr>
		</table>
		</td>
		
		</tr>
													
		<cfif url.output neq "print">	
						
			<cfparam name="url.output" default="0">
							
			<cfif url.outputshow eq "1">
			
				<tr id="row#activityid#">
				<td colspan="#cols#">
								
				<cfdiv id="box#activityid#">
				
				   <cfset url.fileNo = fileNo>							 
				   <cfset url.activityid = activityid>
				   <cfset url.mode = "read">
				      
				   <cfinclude template="ActivityProgressOutput.cfm">
				   
				   </cfdiv>
				   
				 </td></tr>	  
				   
			<cfelseif url.outputshow eq "0">
								
				<tr class="hide" id="row#activity.activityid#">
				<td colspan="#cols#">
			
			<cfdiv id="box#activity.activityid#"/>
			
				</td></tr>	
				   
			</cfif>	   
		
		</cfif>
		
		</td></tr>	
		
		<!---
		
		<tr><td colspan="#6+mth#" class="linedotted"></td></tr>	
		
		--->
		
</cfoutput>		