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

<cfparam name="Form.Page"           default="1">
<cfparam name="Form.Group"          default="LastName">
<cfparam name="URL.Page"            default="#Form.Page#">
<cfparam name="URL.IDSorting"       default="#Form.Group#">
<cfparam name="CLIENT.UserQueryString"  default="">

<cfoutput>
	
	<script>
	
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
	
	    
		try { ColdFusion.Window.destroy('mydialog',true) } catch(e) {}
		ColdFusion.Window.create('mydialog', 'Receipt', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})    						
		ColdFusion.navigate('#SESSION.root#/System/Access/User/CopyView.cfm?group='+grp,'mydialog') 	
	}
	
	function reloadForm(group,page) {
	    Prosis.busy('yes');
	    ptoken.location("UserResult.cfm?idmenu=#URL.idmenu#&ID=1&IDSorting=" + group + "&Page=" + page);
	}
	
	function locate() {
	    ptoken.location("UserSearch.cfm?idmenu=#URL.Idmenu#")
	}
	
	function newuser(grp) { 
	    ptoken.open("UserEntry.cfm?mode=&ID="+grp,"user","left=20, top=20, width=770, height=730, status=yes, toolbar=no, scrollbars=no, resizable=no");			
	}		
	  
	function UserEdit(Account) {
	    ptoken.open("UserEdit.cfm?ID=" + Account,"user","left=100,top=40,width=800,height=700,status=yes,toolbar=no,scrollbars=no,resizable=no");		
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
			 itm.className = "labelit highlight2";
		 }else{
			 itm.className = "labelit";		
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
		SELECT  rTrim(U.Account) as Account, 
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
				
				(SELECT LastConnection 
				    FROM   skUserLastLogon 
					WHERE  Account = U.Account) as LastLogon,		
					
				(SELECT count(*) 
				    FROM    Ref_Application
					WHERE   OfficerManager = U.Account) as Manager,
				
				<cfif AdminAccess eq "NONE">	
				
				 <!--- check if access to this person is granted --->
					(
					 SELECT count(*)
					 FROM   Organization.dbo.OrganizationAuthorization
					 WHERE  UserAccount = '#session.acc#'
					 AND    Mission     = U.AccountMission
					 AND    Role        = 'OrgUnitManager'
					 AND    AccessLevel IN ('2','3')
					 ) as AccessCount, 	
				 
				<cfelse> 
				
				 1 as AccessCount,
				
				</cfif>
					
						  
			     U.disabled
		FROM     UserNames U
		WHERE    1=1 
		<cfif len(Client.UserQueryString) gte "2">
		#PreserveSingleQuotes(Client.UserQueryString)# 
		</cfif>
		<cfif url.idsorting neq "" and url.idsorting neq "AccountType">
		ORDER BY U.#URL.IDSorting#, AccountType
		<cfelse>
		ORDER BY AccountType 
		</cfif>
	</cfquery>

<cf_dialogStaffing>

<body leftmargin="0" topmargin="0" rightmargin="0">

<form action="UserBatch.cfm?idmenu=<cfoutput>#URL.IDMenu#</cfoutput>" method="post" name="result" id="result">

<input type="hidden" name="operation" id="operation" value="">
	
<table width="96%" align="center" border="0" cellspacing="0" cellpadding="0">
  <tr><td height="6"></td></tr>
  <tr class="line">
      <td style="height:50;font-size:30px;padding-top:4px;padding-left:6px;font-weight:200" class="labellarge">
		<cfoutput>#SESSION.welcome#</cfoutput> User Accounts
	</td>
	<td align="right">
    </td>
  </tr>
   
  <tr>

<td width="100%" colspan="2">

		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
		
		<TR>
		
		<td colspan="2">
		
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			
			<script language="JavaScript">
			
			function todays(enforce) {
			
			  se = document.getElementById("itoday")
			  e  = document.getElementById("todayExp")
			  m  = document.getElementById("todayMin")
			
			  if (se.className == "hide" || enforce == "yes") {
					  
				  se.className = "regular"
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
					     U.OfficerLastName,
					     U.OfficerFirstName,
					     U.Created
				FROM     UserNames U
				WHERE    U.OfficerUserid = '#SESSION.acc#'
				AND      U.Created > getDate()-7
				ORDER BY U.Created
			</cfquery>
			
				<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table" navigationhover="#e4e4e4" navigationselected="yellow">
				
				<cfif today.recordcount gte "0">
					
					<tr bgcolor="white">
					    
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
						<td width="99%" colspan="8" class="labelit" style="padding-left:5px">
						<a href="javascript:todays()"><font color="0080C0">Click here to hide/show user accounts that were added by me recently</font></a></td>
						</cfoutput>
						
					</tr>
					
					<tr id="itoday" class="hide">
					    <td colspan="12" id="todaybox" style="border:0px solid silver">
					</td>
					</tr>
				
					
				</cfif>	
					
				<tr bgcolor="white">
				
				<td colspan="12" align="right">
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
						</SELECT> 
						
						</td>
						
						<cfinclude template="../../../Tools/PageCount.cfm">	
						
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
								
				<tr class="labelmedium line">
					<td height="22" width="30"></td>
					<td width="25%"><cf_tl id="Name"></td>
					<td width="100"><cf_tl id="Account"></td>
					<td width="130"><cf_tl id="Network"></td>
					<td width="100"><cf_tl id="IndexNo"></td>
					<td width="100"><cf_tl id="Managed"></td>
					<td width="20%"><cf_tl id="eMail"></td>
					<td width="100"><cf_tl id="Group"></td>
					<td width="110"><cf_tl id="Last logon"></td>
					<td width="20"></td>
					<td width="20"></td>
					<td width="20"></td>
				</tr>
								
				<cfset currrow = 0>
				
				<CFOUTPUT query="SearchResult" group="#URL.IDSorting#" startrow="#first#">
				
				   <cfif currrow lt No>
				      
					   <cfswitch expression="#URL.IDSorting#">
					   
					     <cfcase value = "AccountGroup">
					      <tr><td colspan="12" height="23" bgcolor="white" class="labelmedium">#AccountGroup#</td></tr>
						  <tr><td height="1" colspan="12" bgcolor="E5E5E5"></td></tr>
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
				   
				   <TR bgcolor="#IIf(disabled eq '1', DE('FFFFcF'), DE('FFFFFF'))#" class="labelmedium navigation_row line">
				        
				   <td width="60" align="center">
				   
					   <table cellspacing="0" cellpadding="0">
					   <tr>
					   	   
						    <cfif AccountType eq "Group">
							
						         <td style="width:24;padding-left:6px;padding:1px">
								 
								     <img src="#client.virtualdir#/Images/group.png"
										 class="navigation_action" 
									     alt="Usergroup profile"
									     name="cl#currrow#"
									     id="cl#currrow#"
									     width="14"
									     height="14"
									     border="0"
									     align="absmiddle"
									     style="cursor: pointer;"
									     onClick="ShowUser('#URLEncodedFormat(Account)#')"
									     onMouseOver="document.cl#currrow#.src='#CLIENT.virtualdir#/Images/button.jpg'"
									     onMouseOut="document.cl#currrow#.src='#client.virtualdir#/Images/group.png'">
									 
								</td>
								
						   <cfelse>
						   
						        <td style="width:24;padding-left:6px;padding-top:2px" class="navigation_action" onclick="ShowUser('#URLEncodedFormat(Account)#')">				
									<cf_img icon="select">							   				 
								 </td>    	 
								 
						   </cfif>	 
						   
					  	  
							
					   		</tr>
						</table>
					
				   </td>
				
				   <TD><a href="javascript:ShowUser('#URLEncodedFormat(Account)#')">#LastName#, #FirstName#</a></td> 
				   <TD>#Account#</TD>  
				   <TD style="padding-right:5px">#MailServerDomain#/#MailServerAccount#</TD> 
				   <TD><A HREF="javascript:EditPerson('#PersonNo#')">#IndexNo#</a></TD>   
				   <td style="padding-left:4px">#AccountMission#</td>
				   <TD style="padding-left:4px">
				   
				   <cfif eMailAddress neq "">
						 <a href="javascript:email('#eMailAddress#','','','','User','#Account#')">#eMailAddress#</font>
					<cfelse>
						 #eMailAddress#
				   </cfif>
				   
				   </TD>
				   <TD style="padding-left:3px">#AccountGroup#</TD>
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
									
							   		 <img align="absmiddle"  height="13" width="13" style="cursor:pointer"
								    src="#client.virtualdir#/Images/light_red1.gif" 
									alt="Click to activate" onclick="javascript:setstatus('#account#','1')" 
									border="0">					
							 	
								<cfelse>
								
								   <img align="absmiddle"  height="13" width="13" style="cursor:pointer"
								      src="#client.virtualdir#/Images/light_green1.gif" 
									  alt="Click to deactivate" onclick="javascript:setstatus('#account#','0')"
									  border="0">
																	
								</cfif>
								
							 </cfdiv>
									 
						<cfelse>
								
							<cfif disabled is '1'>
								<img align="absmiddle" src="#client.virtualdir#/Images/light_red1.gif"  height="13" width="13" border="0">						
							<cfelse> 					
								<img align="absmiddle" src="#client.virtualdir#/Images/light_green1.gif"  height="13" width="13" border="0">						 
							</cfif>		
						
						</cfif> 
						 
				   </td>
				   
				    <td style="padding-right:8px">					            
							    <cfif AccessCount gte "1">
								 <cf_img icon="edit" onclick="UserEdit('#Account#')">				   
								</cfif>  
					   		</td>
				   
				   <td style="padding-right:8px">	
				   
				   <cfif AccessCount gte "1">
						   
						    <cfif AccountType eq "Group">
								 <img src="#client.virtualdir#/Images/copy4.gif"
								  alt="" 
								  name="clc#currrow#"
								  border="0" 
								  height="13" width="13"
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
					  
						   <cfif AccessCount gte "1" and OfficerUserid neq SESSION.acc>
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
				
				<td colspan="12" height="23">
					<table width="100%" align="right" border="0" cellspacing="0" cellpadding="0">
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

</form>