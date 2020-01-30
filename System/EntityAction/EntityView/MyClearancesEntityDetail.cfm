<cfoutput>

	    <cfif ObjectDue neq "">
				
		    <!--- leadtime --->									
			<cfset y = DateDiff("d", "#ObjectDue#", "#now()#")>			
			
		</cfif>

	    <cfif DateLast neq "">
				 
		 	<!--- leadtime --->			
			<cfset x = DateDiff("d", "#DateLast#", "#now()#")>
						
			<cfif x gt ActionLeadTime+5>						
				<cfset cl = "f1f1f1">
			<cfelse>			
				<cfset cl = "ffffff">
			</cfif>
			
			<!--- action time --->
			
			<cfset at = DateDiff("h", DateLast, now())>						
			<cfif at gt ActionTakeAction and ActionTakeAction gt "0">
				<cfset cl = "f1f1f1">				
			<cfelse>
				<cfset cl = "ffffff">
			</cfif>
			
		<cfelse>	
		
			<cfset cl = "f7fbff">	
		
		</cfif>	
				
		<TR class="clsRow <cfif total.recordcount lt nav>navigation_row</cfif>">		  
		<td width="60" class="line" valign="top" style="padding-top:1px">
		
			<table height="100%" border="0" cellspacing="0" cellpadding="0">
		
				<tr class="labelmedium" style="height:15px">							
				<td valign="top" style="width:35px;padding:10px 4px 0 6px;font-size: 14px;">#currentrow#.</td>							
				<td valign="top" style="padding-top:3px;padding-left:2px;padding-right:8px" onclick="process('#ObjectId#')" class="<cfif total.recordcount lt nav>navigation_action</cfif>">
											
				<cfif ActionStatus eq "2">
				
					    <img src="#SESSION.root#/Images/check_mark.gif" alt="Document action has been completed" border="0" align="absmiddle">
					  
				<cfelse>
				
				   <cfif DateLast neq "">
					   
						<cfif x gt ActionLeadTime+5>
										
							<img src="#SESSION.root#/Images/Alert.png" alt="Process this action" name="img_#entitycode#_#currentrow#" 
								  onMouseOver="document.img_#entitycode#_#currentrow#.src='#SESSION.root#/Images/Alert-Red.png'" 
								  onMouseOut="document.img_#entitycode#_#currentrow#.src='#SESSION.root#/Images/Alert.png'"
								  height="24" width="24"
								  style="cursor: pointer;margin-top:4px" border="0">
						  
						<cfelseif at gt ActionTakeAction and ActionTakeAction gt "0">
						
							<img src="#SESSION.root#/Images/Alert.png" alt="Action overdue" name="img_#entitycode#_#currentrow#" 
								  onMouseOver="document.img_#entitycode#_#currentrow#.src='#SESSION.root#/ImagesAlert-Red.png'" 
								  onMouseOut="document.img_#entitycode#_#currentrow#.src='#SESSION.root#/Images/Alert.png'"
								  height="24" width="24"
								  style="cursor: pointer;margin-top:4px" border="0">
						  				  
						<cfelse>  						
						  <cf_img mode="open">																					
						</cfif>
						
				  <cfelse>						
				  	 <cf_img mode="open">				 																
				  </cfif>
					
				</cfif>
				
				</td>
				
				</tr>
				
			</table>
		
		</td>
								
		<td class="ccontent line">	
		   
		    <table width="100%">
			
				<tr class="labelmedium" style="height:15px">
					<td style="font-size:14px;padding-left:4px">
				    <cfif PersonNo neq "">
					<a href="javascript:EditPerson('#PersonNo#')"><font color="0080C0">
					</cfif>							
					#ObjectReference# 
					#ObjectReference2#
					<cfif PersonNo neq ""></a></font></cfif>							
									
					</td>
				</tr>
			
	    		<tr class="labelmedium" style="height:15px">
    		    <td style="border-left:1px solid silver;padding-left:5px;height:19px;word-break: break-all; word-wrap: break-word;">
				
					<cfif Mission neq "">
						#Mission# : #OrgUnitName#
					<cfelse>
						<!--- not on the mission level --->
					</cfif>
					<cfif Mission neq "">/</cfif>				
					<font color="C46200">#ActionDescription#</font>		
					
					<cfif FlyAccess gte "1" or MailAccess gte "1">
					
						<cfquery name="Actor" 
						 datasource="AppsOrganization"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT   OAS.UserAccount, U.LastName, U.FirstName
						 FROM     OrganizationObjectActionAccess OAS INNER JOIN System.dbo.UserNames U ON OAS.UserAccount = U.Account
						 WHERE    ObjectId   = '#ObjectId#' 
						 AND      ActionCode = '#ActionCode#'
						 UNION
						 SELECT   OAS.Account, U.LastName, U.FirstName
						 FROM     OrganizationObjectMail OAS INNER JOIN System.dbo.UserNames U ON OAS.Account = U.Account
						 WHERE    ObjectId   = '#ObjectId#' 
						 AND      ActionCode = '#ActionCode#'						 
						</cfquery> 
						
						:&nbsp;<cfloop query="Actor"><font color="black">#LastName#<cfif currentrow neq recordcount>,&nbsp;</cfif></cfloop>
										
					</cfif>
							
					
				</td>
				</tr>			
				
				<tr class="labelmedium" style="height:15px">			
						<td style="font-size:12px;padding-left:6px;">
						<cf_UIToolTip sourcefortooltip="#SESSION.root#/system/entityaction/entityview/myclearancetooltip.cfm?objectid=#objectid#">
							<font color="808080">#InceptionFirstName# #InceptionLastName# (#dateformat(InceptionDate,CLIENT.DateFormatShow)#)
							<cfif missionowner neq "">[#MissionOwner#]</cfif>
							</font>
						</cf_UIToolTip>
						</td>			
				</tr>			
			
			</table>				
			
		</td>			
				
		<td align="right" valign="top" style="padding-right:7px;">				
		    <table width="100%">
				<tr class="labelmedium">
				<td class="line" style="min-width:70px;height:15px;text-align:center;border:1px solid ##cccccc;border-radius: 5px; margin-top: 5px;">	
														
			    <cfif DateLast neq "">							
					<cfif at gt ActionTakeAction AND ActionTakeAction gt "0">
						<font color="FF0000">#at-ActionTakeAction#</font>
					</cfif>				
				</cfif>		
							
				</td>
				</tr>
			</table>	
			
		</td>
		
		<td align="right" valign="top" style="padding-right:2px;">			
			
			<table width="100%"><tr class="labelmedium">
			<td class="line" style="min-width:70px;text-align:center;height:15px;border:1px solid silver;">
			 
			<cfif ActionStatus eq "1">
		       On hold
			<cfelse>
		    <cfif DateLast neq "">
									
			<cfset x = DateDiff("d", "#DateLast#", "#now()#")>
				<cfif x gt ActionLeadTime>
					<font color="FF0000">#x-ActionLeadTime#</font>
				</cfif>
			</cfif>
			</cfif>
			
			</td></tr></table>	
			
		</td>
		
		<td align="center" valign="top" style="padding-right:2px;">								
						 			
		    <cfif ObjectDue neq "">		
										
				<cfif due gt 0>
					<table width="100%">
					<tr class="labelmedium">
					<td class="line" bgcolor="FF0000" style="text-align:center;height:15px;border:1px solid gray;">
					<font color="white">#due#</font>
					</td></tr></table>				
				</cfif>
			
			</cfif>
			
				
		</td>

		</tr>	
		
		
		
		
</cfoutput>		
