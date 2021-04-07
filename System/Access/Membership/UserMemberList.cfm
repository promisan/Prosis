<cfparam name="url.find" default="">

<cfform style="height:100%" action="#SESSION.root#/system/access/Membership/UserMemberSubmit.cfm?Mode=regular&Acc=#URL.ID#" method="post">

		<table width="99%" style="height:100%" align="center">
		
		<cfquery name="Group" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     G.AccountGroup, 
		           A.AccountMission, 
				   A.LastName, 
				   A.Remarks, 
				   G.OfficerUserId, 
				   G.OfficerLastName, 
				   G.OfficerFirstName, 
				   G.Created
		FROM       UserNamesGroup G INNER JOIN UserNames A ON G.AccountGroup = A.Account
		WHERE      G.Account = '#URL.ID#'
		</cfquery>
		
		<!---
		<tr class="labelit">		
		  <td class="labelit" width="40%">Group</td>
		  <td class="labelit" width="15%">Account</td>
		  <td class="labelit" width="10%">Mission</td>
		  <td class="labelit" width="15%">Officer</td>
		  <td class="labelit" width="10%">Date</td>
		  <td class="labelit" width="5%"></td>
		</tr>
		--->		
		
		<cfset grp = "">
		
		<tr><td height="1" colspan="6" class="line"></td></tr>
		
		<cfif group.recordcount eq "0">	
		<tr><td colspan="6" height="30" class="labelit"><font color="gray">There has been NO membership defined for this user</td></tr>		
		<cfelse>		
		<tr><td colspan="5" class="labellarge">Assigned Usergroup</td></tr>	
		</cfif>
		
		<cfoutput query="group">
		
			<cfset grp = "#grp#,#AccountGroup#">
									
			<tr class="labelmedium2 line" bgcolor="E8F5FD">
			   <td style="height:20px;padding-left:4px"><a href="javascript:ShowUser('#AccountGroup#')">#LastName#</a></td>
			   <td>#AccountGroup#</td>
			   <td>#AccountMission#</td>
			   <td>#OfficerFirstName# #OfficerLastName#</td>
			   <td>#dateformat(Created, CLIENT.DateFormatShow)#</td>
			   <td>
			   
			   <cfinvoke component="Service.Access"  
				   method="usergroup" 
				   group="#AccountGroup#" 
				   returnvariable="accessGroup">	
			   
			   <cfif AccessGroup eq "Granted">
				   <cf_img icon="delete" onclick="memberpurge('#AccountGroup#')">   
				</cfif>
				
				</td>
			</tr>
			<cfif Remarks neq "">
				<tr bgcolor="f5f5f5">
				   <td></td>
				   <td style="padding-left:10px" colspan="5" class="labelit">#Remarks#</td></tr>
			</cfif>
		
		</cfoutput> 				
		
		<tr><td height="1" colspan="6" class="linedotted"></td></tr>			
		
		<tr>
		<td colspan="6" style="height:100%" valign="top">
		
		<table style="height:100%" width="100%" class="formpadding">
		
		<tr>
		<td style="height:40px" class="labellarge"><cf_tl id="New Membership">:</td>
						
			<td align="right" width="150" style="padding-right:5px">
				<table><tr><td style="border: 1px solid Silver;">   		 
			   
			   <cfoutput>		
			   	   
				    <input type="text" 
					 name="criteria" 
					 id="criteria"
					 class="regular3" 
					 value="#url.find#" 
					 id="criteria" 
					 style="font-size:16px;height:24px;padding-left:4px"
					 onClick = "this.value=''" 
					 onkeyup= "filterme()">
					 
					</td>
					 
					<td style="border: 1px solid Silver;">
					 
					<img src="#SESSION.root#/images/search.png"
					     alt="Search"
					     width="24"
					     height="24"
					     border="0"
					     align="absmiddle"
					     style="cursor: pointer;"
					     onClick="filterme()">		
						 
					</td> 
						
				</cfoutput>	
				
				</tr></table>		
				
			</td>
							
		</td>	
		</tr>
		
										
		<tr><td colspan="6" style="height:100%;padding-right:5px">	
		
		    <cf_divscroll id="myfilter" style="height:100%">			
			<cfinclude template="MemberSelect.cfm">					
			</cf_divscroll>
		</td></tr>
				
		<tr><td height="1" colspan="6" class="line"></td></tr>	
		<tr><td height="30" colspan="6" align="center">
		<input type="submit" style="width:200px;font-size:13px" class="button10g" name="Submit" id="Submit" value="Assign">
		</td></tr>
				
		</table>
		
		
		</td>
		</tr>
		</table>
		
</cfform>