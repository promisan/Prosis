
<cfparam name="URL.ObjectId" default="">
<cfparam name="URL.Box"      default="">
<cfparam name="URL.Group"    default="">
<cfparam name="URL.Assist"   default="">
<cfparam name="URL.Mode"     default="View">

<!--- check if a prior setting was found to be inherited --->

<cfparam name="url.actiondelete" default="">

<cfquery name="Object" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  OrganizationObject 
		WHERE ObjectId    = '#URL.ObjectId#'		
</cfquery>

<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   OrganizationObjectActionAccess 
		WHERE  ObjectId    = '#URL.ObjectId#'
		AND    ActionCode  = '#ActionCode#'
</cfquery>

<cfif check.recordcount eq "0" and url.actiondelete eq "">

    <cftry>
	
	<cfquery name="InheritFavorite" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO OrganizationObjectActionAccess 
			         (UserAccount,
					  ObjectId,
					  ActionCode,
					  AccessLevel,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
			SELECT 	 DISTINCT UserAccountGranted,
					  '#URL.ObjectId#',
					  ActionCode,
					  AccessLevel,
					  'autoselect',
					  OfficerLastName,
					  OfficerFirstName
			FROM   Ref_EntityClassActionAccess
			WHERE  EntityCode  = '#Object.EntityCode#'
			AND    EntityClass = '#Object.EntityClass#'
			AND    ActionCode  = '#ActionCode#'
			AND    Mission     = '#Object.Mission#'
			AND    UserAccount = '#SESSION.acc#'												  			
	</cfquery>	
	
	<cfcatch></cfcatch>
	</cftry>
		
</cfif>

<cfif URL.Mode eq "Insert" or URL.Mode eq "BatchInsert">

	<table width="100%" align="center">
	
	<cfif url.mode eq "Insert">
	
		<cfquery name="Action" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
		     SELECT    ActionDescription
			 FROM      Ref_EntityActionPublish
			 WHERE     ActionCode      = '#url.ActionCode#'
			 AND       ActionPublishNo = '#url.ActionPublishNo#' 
		</cfquery> 			
				
	<cfelse>
		
		<cfif url.mode eq "Insert">
	
		<cfquery name="Action" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
		     SELECT    ActionDescription
			 FROM      Ref_EntityActionPublish
			 WHERE     ActionCode      = '#url.ActionCode#'
			 AND       ActionPublishNo = '#url.ActionPublishNo#' 
		</cfquery> 			
				
		<cfelse>
		
			<cfquery name="Action" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
			     SELECT    ActionDescription
				 FROM      Ref_EntityActionPublish
				 WHERE     ActionAccess    = '#url.ActionCode#'
				 AND       ActionPublishNo = '#url.ActionPublishNo#' 
			</cfquery> 			
	
		</cfif>	
	
	</cfif>	
	
	<cfparam name="url.label" default="Delegate">
	
	<cfoutput>
	<tr>
	<td colspan="2">
	<table border="0" style="width:100%">
		<tr>
		  
			<td height="15" colspan="2">
			
			<table class="formpadding">						
			<tr>			
			<td>															
				
				<table><tr>
				
				<td colspan="2" class="labelmedium" style="padding-left:10px">
								
				<cfset link = "ProcessActionAccess.cfm?accesslevel=1||box=#url.box#||Mode=#url.mode#||ObjectId=#url.ObjectId#||OrgUnit=#url.OrgUnit#||Role=#url.Role#||ActionPublishNo=#url.ActionPublishNo#||ActionCode=#url.ActionCode#||Group=#url.group#||Assist=#url.assist#">
																		 
				<cfif url.group neq "" and url.group neq "All" and url.group neq "[all users]">
											
					   <cf_tl id = "Select">
					  
					  					   
					   <cfif url.group eq "[mission]">					   
						   <cfset fil1 = "mission">	
						   <cfset val1 = "#Object.Mission#">	
						   <cfset label = "#Object.Mission#">	
						   						 						   		   
					   <cfelseif url.group eq "[unit]" and object.OrgUnit neq "">		
					   			   
						   <cfset fil1 = "orgunit">		
						   <cfset val1 = "#Object.OrgUnit#">	
						   					   
						    <cfquery name="qUserGroup" 
							 datasource="AppsOrganization"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
									SELECT  * 
									FROM  Organization
									WHERE OrgUnit = '#Object.OrgUnit#'
					       </cfquery>
												   		   
						   <cfset label = "#Unit.OrgUnitName#">	
						   
					   <cfelse>					   
					   
						   <cfset fil1 = "usergroup">		
						   <cfset val1 = "#URL.group#">		
						   
						   <cfquery name="qUserGroup" 
							 datasource="AppsOrganization"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
									SELECT  * 
									FROM system.dbo.UserNames
									WHERE Account ='#URL.group#'
					       </cfquery>
						   
						   <cfset label = "#qUserGroup.LastName#">
						   						   	   
					   </cfif>
					
					   <cf_selectlookup
						    box          = "#url.box#"
							link         = "#link#"
							icon         = "delegate.png"
							title        = "<font size='3' color='0080C0'>#label#</font>"
							button       = "No"
							close        = "No"
							class        = "user"
							des1         = "account"			
							filter1      = "#fil1#"
							filter1value = "#val1#">
							
				 <cfelse>
								 
					    <cf_selectlookup
						    box          = "#url.box#"
							title        = "<font size='3' color='0080C0'>Select Processor</font>"
							link         = "#link#"
							icon         = "delegate.png"
							button       = "No"
							close        = "No"
							class        = "user"
							des1         = "account"
							filter3      = "accounttype"
							filter3value = "all">			
							
				</cfif>		
				 				
				<cfset link = "ProcessActionAccess.cfm?accesslevel=0||box=#url.box#||Mode=#url.mode#||ObjectId=#url.ObjectId#||OrgUnit=#url.OrgUnit#||Role=#url.Role#||ActionPublishNo=#url.ActionPublishNo#||ActionCode=#url.ActionCode#||Group=#url.group#||Assist=#url.assist#">
				
				<cfif url.assist neq "" and url.assist neq "DISABLED" and url.assist neq "Not applicable">	
							
				    or						
				
					<cfif url.assist neq "[all users]" and url.group neq "All">
					  
						<cfquery name="qUserGroup" 
							 datasource="AppsOrganization"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
								SELECT  * 
								FROM   System.dbo.UserNames
								WHERE  Account ='#URL.assist#'
					   </cfquery>
					
					   <cf_tl id = "Select">
					   
					   <cfif url.group eq "[mission]">					   
						   <cfset fil1 = "mission">	
						   <cfset val1 = "#Object.Mission#">	
						   <cfset label = "#Object.Mission#">	
						   		   
					   <cfelseif url.group eq "[unit]" and object.OrgUnit neq "">		
					   			   
						   <cfset fil1 = "orgunit">		
						   <cfset val1 = "#Object.OrgUnit#">	
						   					   
						    <cfquery name="qUserGroup" 
							 datasource="AppsOrganization"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
									SELECT  * 
									FROM  Organization
									WHERE OrgUnit = '#Object.OrgUnit#'
					       </cfquery>
						 						   		   
						   <cfset label = "#Unit.OrgUnitName#">	
						   
					   <cfelse>					   
					   
						   <cfset fil1 = "usergroup">		
						   <cfset val1 = "#URL.group#">		
						   
						   <cfquery name="qUserGroup" 
							 datasource="AppsOrganization"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
									SELECT  * 
									FROM system.dbo.UserNames
									WHERE Account ='#URL.group#'
					       </cfquery>
						   
						   <cfset label = "#qUserGroup.LastName#">
						   	   
					   </cfif>
					
					   <cf_selectlookup
						    box          = "#url.box#"
							link         = "#link#"
							icon         = "delegate.png"
							title        = "<font size='3' color='green'>#label#</font>"
							button       = "No"
							close        = "No"
							class        = "user"
							des1         = "account"			
							filter1      = "#fil1#"
							filter1value = "#val1#">
							
				    <cfelse>						
									
					<cf_selectlookup
						    box          = "#url.box#"
							title        = "<font font size='3' color='green'>Select Assistant</font>"
							link         = "#link#"
							icon         = "delegate.png"
							button       = "No"
							close        = "No"
							class        = "user"
							des1         = "account"						
							filter3      = "accounttype"
							filter3value = "all">		
							
				     </cfif>	
				
				</cfif>	
				
				<cfif url.mode eq "Insert">
				<font color="purple"><cf_tl id="for">[#Action.ActionDescription#]</font>								
				<cfelse>
				</td>
				</tr>									
				
				<tr>
				<td>&nbsp;</td>
				<td colspan="2" class="labelit" style="padding-left:4px">
				<cfloop query="Action">
				     <font color="purple">- #ActionDescription#<br>
				</cfloop>	
				</td>
					
				</cfif>	
				
				</tr>
				</table>
											
			</td>
			
			
			
			</tr></table>
			</td>
			<td align="right">
			<!--- empty spot --->
			</td>
		</tr>
	</table>
	</td>
	</tr>
	
	</cfoutput>

<cfelse>

<table width="100%" height="100%" align="center">	   
	<tr class="line"><td colspan="3" class="labelmedium" style="padding-left:30px" bgcolor="F5FBFE" height="20"><cf_tl id="Access granted to">:</td></tr>	
		
</cfif>

<tr style="margin-bottom:10px;"><td colspan="3" valign="top">

	<table width="100%" height="100%">
	
	   <cfif URL.OrgUnit neq "NULL">
	   
		   <cfquery name="Mission" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT Mission
				FROM   Organization
				WHERE  OrgUnit = '#URL.OrgUnit#'
			</cfquery>
			
		</cfif>
		
		<cfquery name="Object" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   OrganizationObject
				WHERE  ObjectId = '#URL.ObjectId#'
		</cfquery>
						
		<cfquery name="Actor" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		
			SELECT DISTINCT U.Account, 
			                U.PersonNo, 
							U.FirstName, 
							U.LastName, 
				            U.AccountGroup, 
							U.eMailAddress, 
							A.OfficerLastName, 
							A.Created, 
							A.ClassParameter,
							A.AccessLevel,
							'Inherited' as Type
			FROM    OrganizationAuthorization A, 
			        System.dbo.UserNames U 
			WHERE   A.UserAccount    = U.Account
			AND     A.Role           = '#URL.Role#'
			AND     U.Disabled = 0
			<cfif url.mode neq "BatchInsert">
			AND     A.ClassParameter = '#URL.ActionCode#'
			<cfelse>
			AND     A.ClassParameter IN (SELECT  ActionCode
			 							 FROM    Ref_EntityActionPublish
										 WHERE   ActionAccess    = '#url.ActionCode#'
										 AND     ActionPublishNo = '#url.ActionPublishNo#')
			</cfif>
			AND     A.AccessLevel < '8'
			<cfif Object.EntityGroup neq "">
			AND     A.GroupParameter = '#Object.EntityGroup#' 
			AND     (A.Mission = '#Object.Mission#' OR A.Mission is NULL)		
			</cfif>
			
			<cfif Object.OrgUnit neq "">
			AND  (
			       (A.OrgUnit     = '#Object.OrgUnit#') 
					OR (A.OrgUnit is NULL and A.Mission = '#Mission.Mission#')
					OR (A.OrgUnit is NULL and A.Mission = '#Object.Mission#')
					OR (A.OrgUnit is NULL and A.Mission is NULL)
				) 
			</cfif>
	
				
			UNION
				
			SELECT DISTINCT U.Account, 
			                U.PersonNo, 
							U.FirstName, 
							U.LastName, 
				            U.AccountGroup, 
							U.eMailAddress, 
							A.OfficerLastName, 						
							A.Created, 
							A.ActionCode as ClassParameter,
							A.AccessLevel,
							'Document' as Type
			FROM    OrganizationObjectActionAccess A, 
			        System.dbo.UserNames U 
			WHERE   A.UserAccount   = U.Account
			AND     A.ObjectId      = '#URL.ObjectId#'
			<cfif url.mode neq "BatchInsert">
			AND     A.ActionCode    = '#URL.ActionCode#'
			<cfelse>
			AND     A.ActionCode IN (SELECT  ActionCode
			 						 FROM    Ref_EntityActionPublish
									 WHERE   ActionAccess    = '#url.ActionCode#'
									 AND     ActionPublishNo = '#url.ActionPublishNo#')
			</cfif>
			ORDER BY Type, U.LastName, U.FirstName, A.ClassParameter
		
		</cfquery>		
	
		<cfif Actor.recordCount eq "0">
			
			<tr class="line" style="border-top:1px solid silver">
			<td colspan="3" align="center" style="padding-left:80px" class="labelmedium">
			
				<cfoutput>				
					<font color="FF0000">Attention:</font><font color="gray"> No Actors were set for this action. Please do select an actor</font>
				</cfoutput>
			
			</td></tr>
			
		<cfelse>
				
			<cfset r = 0>
			<cfset c = 0>
			
			<cfoutput query="actor" group="type">
				
			<cfif type eq "Document">
			
			<tr>
			
			<td colspan="2" height="100%" valign="top">
			
			<table width="100%" height="100%" id="#URL.ActionCode#_#type#">
			
			<cfelse>
			
			<tr><td align="left" style="padding-left:20px;font-size:12px;cursor:pointer" 
			    colspan="2" 
				onClick="javascript:document.getElementById('#URL.ActionCode#_#type#').className='regular';">
			   <a><font color="808080">CLICK HERE <cf_tl id="view Inherited access through ROLE granted authorization"></font></a>
			</td></tr>
			
			<tr>
			
			<td colspan="2" valign="top">				
			<table width="96%" border="0" align="center" id="#URL.ActionCode#_#type#" class="hide formpadding">	
			
			</cfif>		
			
			<tr style="height:1px">		
			 	<td width="4%"></td>
				<td width="28%"></td>
				<td width="1%"></td>
				<td width="4%"></td>
				<td width="28%"></td>
				<td width="1%"></td>
				<td width="4%"></td>
				<td width="28%"></td>
				<td width="1%"></td>
			</tr> 
			 		 
			<cfoutput group="LastName">
			
			<cfoutput group="FirstName">
			
			<cfset c = c+1>
			
			<cfif r eq 3>
				<cfset r = 0>
			</cfif>		
			
			<cfif r eq "0">
				
				<cfif currentRow neq "1">
				<tr class="line"><td height="1" colspan="9"></td></tr>
				</cfif>
				
			</cfif>	
			
			    <td valign="top" style="padding-top:4px;padding-left:20px;padding-right:10px">#C#.</td>
				<td valign="top" style="padding-top:2px">
				
					<table><tr><td>
					
										
					<!--- I changed this line JM on 02/02/2010 : from type neq Document to type eq Document ---->		
					
					<cfif type eq "Document">		
							
					 <font color="gray">	
					 
					 	<table>
						 <tr class="labelmedium">
						 <td style="height:17px">					 			
						 #LastName# <cfif firstname neq "">, #FirstName#</cfif> <cfif accesslevel eq "0"><font size="1" color="808080">[<cf_tl id="Assistant">]</font></cfif>						 
						 </td>
						 					 
						 <cfparam name="url.group" default="">						
						 <td style="padding-left:4px;padding-top:2px;padding-right:5px">	
						 
						 <cfif url.mode eq "Insert">						 	
						   <cf_img icon="delete"							  
						   onClick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/tools/entityAction/ProcessActionAccessDelete.cfm?box=#url.box#&Mode=#url.Mode#&ObjectId=#url.ObjectId#&OrgUnit=#url.OrgUnit#&Role=#url.Role#&ActionPublishNo=#url.actionPublishNo#&ActionCode=#url.ActionCode#&Group=#url.group#&account=#Account#&assist=#url.assist#','#url.box#')">
						  </cfif> 					   
						   
						 </td>
						 
						 <td id="b#account#_favorite">  
						 
							<cfquery name="CheckFavorite" 
							datasource="AppsOrganization" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">	 
							    SELECT 	  *
								FROM   Ref_EntityClassActionAccess
								WHERE  EntityCode  = '#Object.EntityCode#'
								AND    EntityClass = '#Object.EntityClass#'
								AND    ActionCode  = '#url.ActionCode#'
								AND    Mission     = '#Object.Mission#'
								AND    UserAccount = '#SESSION.acc#'		
								AND    UserAccountGranted = '#account#'
							 </cfquery>
																		 
							 <cfif checkfavorite.recordcount eq "0">
							   					   
								  <img src="#SESSION.root#/Images/favoriteadd.png" 
								   title="Remember delegation for #LastName#, #FirstName# for future objects of the same entity" 
								   width="16" height="16" 								 
								   style="cursor: pointer;" 
								   onClick="ptoken.navigate('#SESSION.root#/tools/entityAction/ProcessActionAccessFavorite.cfm?ObjectId=#url.ObjectId#&ActionCode=#url.ActionCode#&action=grant&account=#Account#&accesslevel=#accesslevel#','b#account#_favorite')">
								   
							  <cfelse>
							  
								  <img src="#SESSION.root#/Images/favorite.png" 
								   title="Account was delegated for future actions for the same entity (#LastName#, #FirstName#), press to remove" 
								   width="14" height="14"  
								   style="cursor: pointer;" 
								   onClick="ptoken.navigate('#SESSION.root#/tools/entityAction/ProcessActionAccessFavorite.cfm?ObjectId=#url.ObjectId#&ActionCode=#url.ActionCode#&action=reset&account=#Account#&accesslevel=#accesslevel#','b#account#_favorite')">
													  
							  </cfif> 
						  
						   </td>
						   
						   <td>
						   						   
							<cf_securediv id="session_#url.ActionCode#_#account#"  bind="url:#session.root#/tools/entityaction/session/setsession.cfm?actionid=#url.actionid#&entityreference=#url.ActionCode#&useraccount=#account#">														   
						  
						   </td>
						   
						   
						   </tr>
						   </table>
							
					<cfelseif URL.mode eq "View" and SESSION.isAdministrator eq "Yes">
									
					   <font color="gray">* 
						<a href="javascript:ShowUser('#URLEncodedFormat(Account)#')">#LastName# <cfif firstname neq "">, #FirstName#</cfif></a>
									
					<cfelseif URL.Mode eq "Insert">
							
						<cfif SESSION.isAdministrator eq "Yes">
							<a href="javascript:accessedit('#URL.Role#','Object','#URL.ObjectId#','#Account#','#url.box#','#url.mode#','#url.orgunit#','#url.actionPublishNo#','#url.actionCode#','#url.group#','#url.assist#')">							
							<!--- #dateformat(created,CLIENT.DateFormatShow)#--->#LastName# <cfif firstname neq "">, #FirstName#</cfif> <cfif accesslevel eq "0"><font color="gray">[Assistant]</font></cfif>							
							</a>
						<cfelse>
							#LastName# <cfif firstname neq "">, #FirstName#</cfif>
						</cfif>			   
					    					
						<cfparam name="url.group" default="">
						
						<!--- 28/7/2013 : removed the delete as this is not on-the-fly access 	
						<img src="#SESSION.root#/Images/delete_user.gif" 
						   alt="Remove access #LastName#, #FirstName#" 
						   width="12" 
						   height="12" 
						   border="0" 
						   style="cursor: pointer;" 
						   onClick="ColdFusion.navigate('#SESSION.root#/tools/entityAction/ProcessActionAccessDelete.cfm?box=#url.box#&Mode=#url.Mode#&ObjectId=#url.ObjectId#&OrgUnit=#url.OrgUnit#&Role=#url.Role#&ActionPublishNo=#url.actionPublishNo#&ActionCode=#url.ActionCode#&Group=#url.group#&account=#Account#&assist=#url.assist#','#url.box#')">
						   --->
											
					<cfelseif URL.mode eq "BatchInsert">	
					
						<cfif SESSION.isAdministrator eq "Yes">						
							<a href="javascript:accessedit('#URL.Role#','Object','#URL.ObjectId#','#Account#','#url.box#','#url.mode#','#url.orgunit#','#url.actionPublishNo#','#url.actionCode#','#url.group#','#url.assist#')">
							#LastName#<cfif firstname neq "">, #FirstName#</cfif>
							</a>
						<cfelse>
						     <font color="gray">#LastName#<cfif firstname neq "">, #FirstName#</cfif></font>
						</cfif>		
						
					<cfelse>					
						   <font color="gray">#LastName#<cfif firstname neq "">, #FirstName#</cfif></font>						
					</cfif>				
					
					</td></tr>
					
					<cfif url.mode eq "BatchInsert">
									
					<cfoutput group="ClassParameter">
					
						<tr>
						<td>
						
							<table>
													
							<cfquery name="ThisAction" 
								 datasource="AppsOrganization"
								 username="#SESSION.login#" 
								 password="#SESSION.dbpw#">
								     SELECT    ActionDescription
									 FROM      Ref_EntityActionPublish
									 WHERE     ActionCode      = '#classParameter#'
									 AND       ActionPublishNo = '#url.ActionPublishNo#' 
							</cfquery> 		
							
							<tr class="labelit" style="height:15px">
							
							<cfif type eq "Document">
							
								<td>								
								<cf_img icon="delete" 
								 onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/tools/entityAction/ProcessActionAccessDelete.cfm?box=#url.box#&Mode=#url.Mode#&ObjectId=#url.ObjectId#&OrgUnit=#url.OrgUnit#&Role=#url.Role#&ActionPublishNo=#url.actionPublishNo#&ActionCode=#url.actionCode#&ActionDelete=#classparameter#&Group=#url.group#&assist=#url.assist#&account=#Account#','#url.box#')">								 
							     </td>	  
								  
							 </cfif> 
							 							
							<td>								
						    #ThisAction.ActionDescription#
							</td>							
							</tr>							
							</table>
							   
						</td>
						</tr>	   
			
					</cfoutput>			
					
					</cfif>
					<td></td>
					</table>
				</td>
				<td></td>
							
				<cfset r = r + 1>
			
			<cfif r eq "0">
				</tr>
				
			</cfif>	
			
			</cfoutput>
			
			</cfoutput>
			
			</table>
			</td></tr>
			
			</cfoutput>
	
			</table>
		   
		   </td>
		   
		</tr>	 
		</cfif>
	
		
		<cfquery name="MailSent" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM    OrganizationObjectMail M,
			        System.dbo.UserNames N  
			WHERE   M.Account = N.Account
			AND     M.ObjectId    = '#URL.ObjectId#'
			AND     M.ActionCode  = '#URL.ActionCode#'
		</cfquery>
		
		<cfif URL.Mode eq "View" and MailSent.recordcount gte "1">
		
		<tr><td style="padding:4px">	
						
				<table width="98%" align="center">
				
					<tr><td colspan="9" class="labelmedium" style="height;30px;padding-left:4px">A notification was sent to the below users:</td></tr>
						
					<tr>
					   <td colspan="9">
							<table width="100%" align="center">
							<cfoutput>
							<cfloop query="MailSent">				
							<tr class="labelmedium line">
								<td style="padding-left:9px">#FirstName# #LastName# (#Account#)</td>
								<td>#EMailAddress#</td>
								<td>#EMailType#</td>
								<td><cfif Exchangeid neq "">Task<cfelse>Mail</cfif></td>
								<td>#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>
								<td>#OfficerLastName#</td>
							</tr>
							</cfloop>
							</cfoutput>
							</table>
					   </td>
					</tr>   	
				</table>	
		
		</td></tr>	
			
		</cfif>
			
	</table>

</td></tr>

</table>	
