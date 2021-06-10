<cfparam name="url.find" default="">

<cfform style="height:100%" name="memberform" onsubmit="return false" method="post">

<table width="100%" style="height:100%">
<tr><td valign="top" style="padding-left:16px">

<cf_divscroll id="myfilter" style="height:100%">

		<table width="98%" class="navigation_table">
		
		<cfquery name="Group" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     G.AccountGroup, 
		           A.AccountMission, 
				   A.LastName, 
				   A.Remarks,
				   A.OfficerLastName as GroupLastName, 
				   A.Created as GroupCreated,
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
		
		<tr><td height="1" colspan="5" class="line"></td></tr>
		
		<cfif group.recordcount eq "0">	
		<tr><td colspan="5" height="30" class="labelit"><font color="gray">There has been NO membership defined for this user</td></tr>		
		<cfelse>		
		<tr class="labelmedium2"><td colspan="5" style="height:40px;font-size:22px"><cf_tl id="Assigned usergroups"></td></tr>	
		</cfif>
		
		<cfoutput query="group">
		
			<cfset grp = "#grp#,#AccountGroup#">
									
			<tr class="labelmedium2 line navigation_row">
			   <td style="height:20px;padding-left:4px"><a href="javascript:ShowUser('#AccountGroup#')">#LastName# [<font size="1">#AccountGroup#]</a></td>			  
			   <td style="padding-left:4px;min-width:100px">#AccountMission#</td>
			   <td style="width:40%">#Remarks# <font size="1" color="8000FF">[#GroupLastName# #dateformat(GroupCreated, CLIENT.DateFormatShow)#]</td>
			   <td style="padding-left:4px">#OfficerLastName#&nbsp;#dateformat(Created, CLIENT.DateFormatShow)#</td>
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
					
		</cfoutput> 				
		
		<tr>
		<td colspan="5" style="height:100%" valign="top">
		
			<table style="height:100%" width="100%" class="formpadding">
			
			<tr>
			<td style="height:40px;font-size:22px"><cf_tl id="New Membership">:</td>
							
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
											
			<tr class="line"><td colspan="5" style="height:100%;padding-right:5px">						    			
				<cfinclude template="MemberSelect.cfm">									
			</td></tr>		
					
			</table>		
		
		</td>
		</tr>
		</table>
		
		</cf_divscroll>

</td>
</tr>		
<tr><td height="30" colspan="6" align="center">
		<input type="button" onclick="memberadd()" style="width:200px;font-size:13px" class="button10g" name="Submit" id="Submit" value="Assign">
		</td></tr>
		
</table>		
		
</cfform>		

<cfset ajaxonload("doHighlight")>