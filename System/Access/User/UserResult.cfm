<!--- Create Criteria string for query from data entered thru search form --->

<head>
<cfoutput>
<script type="text/javascript">
  // Change cf's AJAX "loading" HTML
  _cf_loadingtexthtml="<div><img src='#SESSION.root#/images/busy5.gif'/>";
</script>
</cfoutput>
</head>

<cf_screentop html="No" scroll="Yes" height="100%" jQuery="yes" menuaccess="Context">

<cfparam name="Form.Page"              default="1">
<cfparam name="Form.Group"             default="LastName">
<cfparam name="URL.Page"               default="#Form.Page#">
<cfparam name="URL.IDSorting"          default="#Form.Group#">
<cfparam name="CLIENT.UserQueryString" default="">

<cfoutput>
	
	<script language="JavaScript">
	
	function setstatus(acc,act)	{
		var accId = acc.replace(/ /gi, '');
		accId = accId.replace(/\//gi, '');
		_cf_loadingtexthtml='';	
		ptoken.navigate('UserStatusUpdate.cfm?id4='+acc+'&act='+act,accId)	
	}
	
	function Process(action) {
		if (confirm("Do you want to completely " + action + " selected users ?")) {
			op = document.getElementById("operation");
			op.value = action;
			Prosis.busy('yes');
			result.submit(); 
		}	
	}
	
	function CopyAccess(grp) {	    
		ProsisUI.createWindow('mydialog', 'Copy access to other entities', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,resizable:false,center:true})    						
		ptoken.navigate('#SESSION.root#/System/Access/User/CopyView.cfm?group='+grp,'mydialog') 	
	}
	
	function reloadForm(group,page) {
	    _cf_loadingtexthtml='';	
	    Prosis.busy('yes');
	    ptoken.location("UserResult.cfm?idmenu=#URL.idmenu#&ID=1&IDSorting=" + group + "&Page=" + page);
	}
	
	function locate() {
	    ptoken.location("UserSearch.cfm?idmenu=#URL.Idmenu#")
	}
	
	function newuser(grp) { 
	    ProsisUI.createWindow('newaccount', 'User account', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,resizable:false,center:true})
		ptoken.navigate('#SESSION.root#/System/Access/User/UserEntryView.cfm?mode=entry&ID='+grp,'newaccount')
	}	
	
	function UserEdit(Account) {
		ProsisUI.createWindow('mydialog', 'User account', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,resizable:false,center:true})
		ptoken.navigate('#SESSION.root#/System/Access/User/UserEntryView.cfm?mode=edit&ID=' + Account,'mydialog');		
	}  	
	 
		
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
		function hl(itm,fld){		 
	     if (ie){
	          while (itm.tagName!="TR")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TR")
	          {itm=itm.parentNode;}
	     }	 		 	 	
		 if (fld != false){
			 itm.className = "labelmedium line highlight2";
		 }else{
			 itm.className = "labelmedium line";		
		 }	
	  }	 
	</script>	
		
</cfoutput>

<cfinvoke component = "Service.Access"  
    method          = "useradmin" 
    treeaccess      = "No"   <!--- check if user has treerolemanager for that role --->
    role            = "'AdminUser'"
    returnvariable  = "adminaccess">	
	
<cfinvoke component = "Service.Access"  
    method          = "RoleAccess"    
	role            = "'orgunitmanager'"
	accesslevel     = "'2','3'"
    returnvariable  = "orgaccess">		

<cfset access = "DENIED">
	
<cfif AdminAccess eq "EDIT" or AdminAccess eq "ALL">	
	<cfset access = "GRANTED">
<cfelseif orgaccess eq "GRANTED">
    <cfset access = "GRANTED"> 
</cfif>
	  
	<cfquery name="Anonymous" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM Parameter
	</cfquery> 
	
	<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   rTrim(U.Account) as Account, 
		         U.IndexNo, 
			     U.AccountType, 
			     U.LastName, 
				 U.AccountNo,
				 U.MailServerAccount,
				 U.MailServerDomain,
			     U.FirstName, 
			     U.eMailAddress, 
				 U.AccountMission,
			     U.AccountGroup,
			     U.PersonNo, 
			     U.OfficerUserId,
			     U.Created, 
				 (SELECT  ApplicantNo 
			      FROM    Applicant.dbo.ApplicantSubmission
				  WHERE   ApplicantNo = U.ApplicantNo ) as NaturalPerson,
				 				 
				 (  SELECT  LastConnection 
				    FROM    skUserLastLogon 
					WHERE   Account = U.Account) as LastLogon,							
					
				 (	SELECT count(*) 
				    FROM    Ref_Application
					WHERE   OfficerManager = U.Account) as Manager,				
					
				 <cfif AdminAccess eq "NONE">	
				 				
					<!--- check if access to this user that connected is granted for user admin --->
					
					( SELECT count(*)
					  FROM   Organization.dbo.OrganizationAuthorization
					  WHERE  UserAccount  = '#session.acc#'
					  AND    Mission      = U.AccountMission
					  AND    Role         = 'OrgUnitManager'
					  AND    AccessLevel IN ('2','3')
					 ) as AccessCount, 					 
					 
				 <cfelse> 
				 
				 	<!--- admin Access was granted so default = 1  --->				   				    
				 
					1 as AccessCount,						
					
				 </cfif>											  
				 
			     U.disabled				 
		FROM     UserNames U
		WHERE    1=1 
		<cfif len(Client.UserQueryString) gte "2">
		#PreserveSingleQuotes(Client.UserQueryString)# 
		</cfif>
		<cfif url.idsorting neq "" and url.idsorting neq "AccountType">
		ORDER BY  U.#URL.IDSorting#, AccountType
		<cfelse>
		ORDER BY  AccountType 
		</cfif>
	</cfquery>

<cf_dialogStaffing>

<form style="height:98%" action="UserBatch.cfm?idmenu=<cfoutput>#URL.IDMenu#</cfoutput>" method="post" name="result" id="result">

<input type="hidden" name="operation" id="operation" value="">
	
<table width="96%" height="100%" align="center">
 
  <tr><td height="6"></td></tr>
  <tr class="line">
      <td style="height:50;font-size:30px;padding-top:4px;padding-left:6px;font-weight:200" class="labellarge">
		<cfoutput>#SESSION.welcome#</cfoutput> <cf_tl id="User Accounts">
	</td>
	<td align="right">
    </td>
  </tr>
   
  <tr>

	<td height="100%" width="100%" colspan="2">

		<table width="100%" align="center" height="100%">
		
		<TR>
		
		<td colspan="2">
		
			<table height="100%" width="100%" align="center">
			
			<script language="JavaScript">
			
			function todays(enforce) {
			
			  se = document.getElementById("itoday")
			  e  = document.getElementById("todayExp")
			  m  = document.getElementById("todayMin")
			
			  if (se.className == "hide" || enforce == "yes") {
					  
				  se.className = "regular"
				  _cf_loadingtexthtml='';	
				  ptoken.navigate('UserEntryToday.cfm','todaybox')
				  e.className = "hide"
				  m.className = "regular"	  
				  
				  } else {
				  
				  se.className = "hide"
				  e.className = "regular"
				  m.className = "hide"
				  
				  }
			  	
			}	
			
			</script>
			
			<cfquery name="today" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   rTrim(U.Account) as Account, 
				         U.IndexNo, 
					     U.AccountType, 
					     U.LastName, 
					     U.FirstName, 
					     U.eMailAddress, 
					     U.AccountGroup,
					     U.PersonNo, 
					     U.Created, 
					     (SELECT LastConnection FROM skUserLastLogon WHERE Account = U.Account) as LastLogon,
					     U.disabled,
						 U.OfficerUserId,
					     U.OfficerLastName,
					     U.OfficerFirstName,
					     U.Created
				FROM     UserNames U
				WHERE    U.OfficerUserid = '#SESSION.acc#'
				AND      U.Created > getDate()-7
				ORDER BY U.Created
			</cfquery>
			
				<table height="100%" width="100%" class="navigation_table" navigationhover="#e4e4e4" navigationselected="d6d6d6">
				
				<cfif today.recordcount gte "0">
					
					<tr bgcolor="white" style="height:10px">
					    
						<cfoutput>
						
						<td colspan="1" width="30" height="27">
						
						  <img src="#client.virtualdir#/Images/ct_collapsed.gif" alt="Show candidates" 
							id="todayExp" 
							border="0" 
							align="absmiddle" 
							class="regular" style="cursor: pointer;" 
							onClick="todays()">
									
						  <img src="#client.virtualdir#/Images/ct_expanded.gif" 
							id="todayMin" alt="Hide candidates" border="0" 
							align="absmiddle" 
							class="hide" style="cursor: pointer;" 
							onClick="todays()">
													
						</td>
						
						<td colspan="8" class="labelit" style="padding-top:2px;padding-left:5px">
						<a href="javascript:todays()">Click here to hide/show user accounts that were added by me recently</a>
						</td>
						</cfoutput>
						
					</tr>
					
					<tr id="itoday" class="hide">
					    <td colspan="12" id="todaybox" style="border:0px solid silver">
					</td>
					</tr>
				
					
				</cfif>	
					
				<tr bgcolor="white" style="height:20px">
				
				<td colspan="13" align="right">
					<table width="100%" cellspacing="0" cellpadding="0">
					
					<tr><td style="padding:4px">
					
						<INPUT type="button" class="button10g"  style="width:100px" value="Find" onClick="locate()">
							
						<cfif Access eq "GRANTED">
					    	<INPUT type="button" class="button10g" style="width:100px" value="New User"  onClick="newuser('Individual')">
							<INPUT type="button" class="button10g" style="width:100px" value="New Group" onClick="newuser('Group')">
						</cfif>	
					
					</td>
					
					<td align="right">
					
					<table cellspacing="0" cellpadding="0" align="right">
					
						<tr>
						<td>
						
						<select name="group" id="group" size="1" class="regularxl" onChange="reloadForm(this.value,document.getElementById('page').value)">
						     <option value="AccountGroup" <cfif URL.IDSorting eq "AccountGroup">selected</cfif>>Sort by Account group
						     <OPTION value="LastName" <cfif URL.IDSorting eq "LastName">selected</cfif>>Sort by Last name
						     <OPTION value="Account" <cfif URL.IDSorting eq "Account">selected</cfif>>Sort by Account name
							 <option value="AccountMission" <cfif URL.IDSorting eq "AccountMission">selected</cfif>>Sort by Entity
						</SELECT> 
						
						</td>
						
						<cf_pageCountN count="#SearchResult.recordCount#">	
																		
						<cfif pages gt 1>
						
							<td align="right" style="padding-left:2px">
						   
								<select name="page" id="page" class="regularxl" size="1" onChange="reloadForm(document.getElementById('group').value,this.value)">
							    <cfloop index="Item" from="1" to="#pages#" step="1">
						    	    <cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
							    </cfloop>	 
								</SELECT>	
							  
						    </td>
							
						<cfelse>
							   
						  	<input type="hidden" name="page" id="page" value="1">
									
					    </cfif>		
							
						</tr>
						
					</table>
					
					</td>
					</tr>
					
					</table>
					
					
				</td>
				</tr>
				
				<tr><td colspan="2" style="height:100%">
				
				<cf_divscroll>
				
				<table width="98%">
								
				<tr class="labelmedium fixrow">
					<td height="22" style="width:40px"></td>
					<td style="min-width:200px" width="25%"><cf_tl id="Name"></td>
					<td width="100"><cf_tl id="Account"></td>
					<td width="130"><cf_tl id="Network"></td>
					<td style="min-width:120px"><cf_tl id="IndexNo"></td>
					<td width="100"><cf_tl id="Managed"></td>
					<td width="20%"><cf_tl id="eMail"></td>
					<td width="100"><cf_tl id="Group"></td>
					<td width="110"><cf_tl id="Last logon"></td>
					<td width="20"></td>
					<td width="20"></td>
					<td width="20"></td>
					<td width="20"></td>
				</tr>
								
				<cfset currrow = 0>
				
				<CFOUTPUT query="SearchResult" group="#URL.IDSorting#" startrow="#first#">
				
				   <cfif currrow lt No>
				      
					   <cfswitch expression="#URL.IDSorting#">
					   
					     <cfcase value = "AccountGroup">
					      <tr class="fixrow2 labelmedium line"><td colspan="12" height="23" bgcolor="white">#AccountGroup#</td></tr>						  
					     </cfcase>
						  <cfcase value = "AccountMission">
					      <tr class="fixrow2 labelmedium line"><td colspan="12" height="23" bgcolor="white">#AccountMission#</td></tr>						  
					     </cfcase>
					     <cfcase value = "LastName">
						 
					     <!--- <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#LastName#</b></font></td> --->
					     </cfcase>	 
					     <cfcase value = "Account">
					     <!--- <td colspan="8"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(TransactionDate, "#CLIENT.DateFormatShow#")#</b></font></td> --->
					     </cfcase>
					     <cfdefaultcase>		 
					      <tr><td colspan="12" class="labelmedium">#AccountGroup#</td></tr>
					     </cfdefaultcase>
					   </cfswitch>
				
				   </cfif>     
				   
				   <cfoutput>
				   
				   <cfset currrow = currrow + 1>
				   
				   <cfif currrow lte No>
				   
				   <TR bgcolor="#IIf(disabled eq '1', DE('d6d6d6'), DE('FFFFFF'))#" class="labelmedium navigation_row line" style="height:20px">
				        
				   <td width="60" align="center">
				   
					   <table cellspacing="0" cellpadding="0">
					   <tr>
					   
					   <td>#currentrow#</td>
					  					  						
						<cfif AccessCount gte "1">
					   	   
						    <cfif AccountType eq "Group">
							
						        <td style="width:24;padding-left:6px;padding:1px" class="navigation_action" onclick="UserEdit('#Account#')">								 
								  <cf_img icon="select">										     									 
								</td>
								
						   <cfelse>
						   
						        <td style="width:24;padding-left:6px;padding-top:2px" class="navigation_action" onclick="UserEdit('#Account#')">				
								  <cf_img icon="select">							   				 
								</td>    	 
								 
						   </cfif>	
						   
						  <cfelse>
						  
						  <!--- no access ---> 
						   
						  </cfif>  						 				  	  
							
					   	</tr>
						</table>
					
				   </td>
				
				   <TD><a href="javascript:ShowUser('#URLEncodedFormat(Account)#')">#LastName#<cfif firstname neq "">, #FirstName#</cfif></a></td> 
				   <TD>#Account#</TD>  
				   <TD style="padding-right:5px"><cfif mailserverdomain neq "">#MailServerDomain#/</cfif>#MailServerAccount#</TD> 
				   
				   <cfif NaturalPerson eq "">				   
				   		<TD><A HREF="javascript:EditPerson('#PersonNo#')">#IndexNo#</a></TD>   				   
				   <cfelse>				   
				    	<TD><A HREF="javascript:ShowCandidate('#PersonNo#')">#IndexNo#</a></TD>				   
				   </cfif>
				   
				   <td style="padding-left:4px">#AccountMission#</td>
				   <TD style="padding-left:4px">
				   
				   <cfif eMailAddress neq "">
						 <a href="javascript:email('#eMailAddress#','','','','User','#Account#')">#eMailAddress#</font>
					<cfelse>
						 #eMailAddress#
				   </cfif>
				   
				   </TD>
				   <TD style="padding-left:3px;padding-right:5px">#AccountGroup#</TD>
				   <TD>
				       <cfif DateFormat(LastLogon, CLIENT.DateFormatShow) eq "">
					   <font color="FF0000">never</font><cfelse>#DateFormat(LastLogon, CLIENT.DateFormatShow)#</cfif>
				   </td>				      
				   <td align="right" style="height:20px;padding-right:5px">
				
					    <cfif AccessCount gte "1">
						
							 <cfset vIdAccount = replace(account," ","","ALL")>
							 <cfset vIdAccount = replace(vIdAccount,"/","","ALL")>
							 
							 <cfdiv id="#vIdAccount#">	 
							 
							 	<cfif disabled eq "1">
									
							   		 <img align="absmiddle"  height="16" width="16" style="cursor:pointer"
								    src="#client.virtualdir#/Images/light_red1.gif" 
									alt="Click to activate" onclick="setstatus('#account#','1')" 
									border="0">					
							 	
								<cfelse>
								
								   <img align="absmiddle"  height="16" width="16" style="cursor:pointer"
								      src="#client.virtualdir#/Images/light_green1.gif" 
									  alt="Click to deactivate" onclick="setstatus('#account#','0')"
									  border="0">
																	
								</cfif>
								
							 </cfdiv>
									 
						<cfelse>
								
							<cfif disabled is '1'>
								<img align="absmiddle" src="#client.virtualdir#/Images/light_red1.gif"  height="16" width="16" border="0">						
							<cfelse> 					
								<img align="absmiddle" src="#client.virtualdir#/Images/light_green1.gif"  height="16" width="16" border="0">						 
							</cfif>		
						
						</cfif> 
						 
				   </td>
				   
				   <td style="padding-right:8px">					            
					  
				   </td>
				   
				   <td style="padding-right:8px">	
				   
				   		<cfif AccessCount gte "1">
							   
						    <cfif AccountType eq "Group">
								 <img src="#client.virtualdir#/Images/copy4.gif"
								  alt="" 
								  name="clc#currrow#"
								  border="0" 
								  height="16" width="16"
								  align="absmiddle"
								  onclick="CopyAccess('#URLEncodedFormat(Account)#')"
							      onMouseOver="document.clc#currrow#.src='#CLIENT.virtualdir#/Images/button.jpg'"
							      onMouseOut="document.clc#currrow#.src='#client.virtualdir#/Images/copy4.gif'">
								</cfif>
					
						</cfif>
						  
				   </td>
						 
				   <td align="right" class="labelit" style="padding-right:6px">
				     							
					   <cfif Anonymous.AnonymousUserId eq Account>
					   
					   		<cf_UIToolTip  tooltip="Anonymous User">Sys</cf_UIToolTip>
					   	 
					   <cfelseif Manager eq "0"> 
					  					  				  
						   <cfif AccessCount gte "1" and Account neq SESSION.acc>								  			   
							   <input type="checkbox" name="Account" id="Account" value="'#Account#'" onClick="hl(this,this.checked)">				 
						   </cfif>
						   
					   <cfelse>
					   	
							<cf_UIToolTip  tooltip="Application Manager">AM</cf_UIToolTip>
					   
					   </cfif>		  
					   
				   </td>		        
				   </tr>
				     
				   <cfelse>
				   
				    <td height="20" colspan="12">
						<table width="100%">
						<td colspan="1" align="right" style="padding-top:4px">	
						
							<cfif SESSION.isAdministrator eq "No">	
							
								<!--- deactivate only --->
							
								<input type="button"
							       name="Purge"
								   id="Purge"
							       value="Clear"
							       class="button10g" style="width:140"
							       onClick="Process('clear')">
								   
						   <cfelse>
						   
							   <input type="button"
							       name="Purge"
								   id="Purge"
							       value="Remove"
							       class="button10g" style="width:140"
							       onClick="Process('remove')">
								   
						   </cfif>
						
						</td>
					   </table>		   
				       <cfabort>
				         
				   </cfif>
				  		  
				</cfoutput>
				   
				</CFOUTPUT>
				
				</table>
				</cf_divscroll>
				</td></tr>
								
				<td colspan="12" height="23">
					<table width="100%" align="right">
					<tr>
					<td colspan="1" align="right" height="35">
					    <input type="button" name="Purge" id="Purge" value="Remove" class="button10g" style="width:140;height:23" onClick="Process('remove')">		
					</td>
					</tr>		
					</table>
				
				</td>
				</tr>
					
				</TABLE>
			
			</td>
			</tr>
			
			</TABLE>
		
		</td>
		</tr>
		
		</table>
		
		</td>
		</tr>
		
	</table>		

</form>