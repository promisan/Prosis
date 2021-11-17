
<!--- Query returning search results --->
<cfparam name="URL.Mission" default="">
<cfparam name="URL.context" default="1">
<cfparam name="URL.ID4"     default="">
<cfparam name="URL.ID5"     default="">
<cfparam name="URL.ID0"     default="">
<cfparam name="URL.Source"  default="Manual">

<cfquery name="Role"
	datasource = "AppsOrganization" 
    username   = "#SESSION.login#" 
    password   = "#SESSION.dbpw#"> 
	   SELECT *
	   FROM   Ref_AuthorizationRole 
	   WHERE  Role = '#URL.ID4#'
</cfquery>

<cfif url.context eq "1">
	<cf_screentop height="100%" title="Granted Access #role.Description#" label="Authorizations for #role.Description#" band="No" jquery="Yes" scroll="yes" banner="gray" layout="webapp">
<cfelse>
	<cf_screentop height="100%" html="no" label="Authorizations for #role.Description#" line="no" band="No"  jquery="Yes" banner="gray" scroll="yes" layout="webapp">	
</cfif>	

<cf_dialoglookup>
 
<cfoutput>

<script>
	try {
		parent.ColdFusion.Layout.collapseArea('wfcontainer', 'right') } catch(e) {}
</script>

<script language="JavaScript">

function maximize(itm,icon){
	
	 se   = document.getElementById(itm)
	 icM  = document.getElementById(itm+"Min")
	 icE  = document.getElementById(itm+"Exp")
	 
	 if (se.className == "regular") {
	 se.className = "hide";
	 icM.className = "hide";
	 icE.className = "regular";
		
	 } else {
	 se.className = "regular";
	 icM.className = "regular";
	 icE.className = "hide";	
	 }
}  

function Process(action) {
	if (confirm("Do you want to " + action + " ALL access of the selected users for this role ?")) {	
	  Prosis.busy('yes') 	   
	  document.formresult.submit() 	 
	} else {
	return false
	}
}

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld,s){

     var count = 0
	 while (count < 5) {
	 count++
     ln = document.getElementById(itm+"_"+count)
     if (ln){
	 if (fld != false){ ln.className = "labelmedium highLight"+s; }
	 else { ln.className = "labelmedium"; }
	 }	 
	 }
  }

 function detail(rle,acc,row,src) {
		
	  se =  document.getElementById("result_"+row)
	  if (se.className == "hide") {
		  document.getElementById("result_"+row).className  = "regular";
		  url = "OrganizationListingMission.cfm?id5="+acc+"&id4="+rle+"&source="+src;	
		  ColdFusion.navigate(url,'iresult_'+row)		
		  document.getElementById(row+"tExp").className = "hide"		
		  document.getElementById(row+"tMin").className = "regular"		  		  	  
	  } else {
	      document.getElementById("result_"+row).className  = "hide";
		  document.getElementById(row+"tMin").className = "hide"		
		  document.getElementById(row+"tExp").className = "regular"		  	
	  } 	   
}	 
		  
  
function listing() {
    location = "OrganizationRoles.cfm"
}  

function reloadForm(role,acc,inh) {
    Prosis.busy('yes')
    if (inh == true) {
	  location = "OrganizationListing.cfm?context=#url.context#&ID4="+role+"&ID5="+acc+"&Source=All"
	} else {
	  location = "OrganizationListing.cfm?context=#url.context#&ID4="+role+"&ID5="+acc+"&Source=Manual"
	}  
}  
  
function process(acc) {        
	ProsisUI.createWindow('myaccess', 'Access', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,center:true})    				
	ptoken.navigate(root + '/System/Organization/Access/UserAccessView.cfm?ID1=global&ID=#URL.ID4#&Mission=#URL.Mission#&ACC=' + acc,'myaccess') 		
}
	
function group(bx,row) {
  	
	se   = document.getElementById(row);		
	url = "../Membership/RecordListingDetail.cfm?mode=limited&mod=" + bx +"&row=" + row
			 		 
	if (se.className == "hide") {
	    se.className = "regular"	   
	    ptoken.navigate(url,'i'+row)		
    } else {	   	 	
    	se.className  = "hide"
	}
		 		
  }

</script>	
</cfoutput>

<cfinvoke component = "Service.Access"  
	method          = "useradmin" 
	role            = "'AdminUser'"
	returnvariable  = "access">	

<cfquery name="RoleSelect"
	datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#"> 
	   SELECT  R.*, S.Description as ModuleName
	   FROM    Ref_AuthorizationRole R, System.dbo.Ref_SystemModule S
	   WHERE   R.SystemModule = S.SystemModule
	   AND     S.Operational = '1'
	   <cfif access eq "EDIT" or access eq "ALL">
	   AND     R.OrgUnitLevel IN ('Global','Tree','Parent','All')
	   <cfelse>
	   AND     R.OrgUnitLevel IN ('Tree','Parent','All')
	   </cfif>
	   <cfif SESSION.isAdministrator eq "No">
	   AND     (R.RoleOwner IN (SELECT ClassParameter 
	                        FROM OrganizationAuthorization
							WHERE Role = 'AdminUser'
							AND  UserAccount = '#SESSION.acc#')
				OR R.RoleOwner is NULL)			
	   AND     R.SystemModule != 'System'	
	  				
	   </cfif>
	   AND R.SystemModule = '#Role.SystemModule#'
	   ORDER BY R.Area, R.SystemModule
</cfquery>

<cfset FileNo = round(Rand()*20)>

<CF_DropTable dbName="AppsQuery" 
              tblName="Access#SESSION.acc#_#fileNo#"> 	
 	
<cfquery name="SearchResult" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT DISTINCT 
          UserAccount as UserAccount, 
		  <cfif Role.Parameter eq "Entity">	
		  'NA' as ClassParameter, 
		  <cfelse>
		  ClassParameter,
		  </cfif>
		  ClassIsAction, 
		  Source,
		  MAX(Mission) as Mission, 		 
		  AccessLevel,
		  'Access' as Type 
   INTO  userQuery.dbo.Access#SESSION.acc#_#fileNo#		  
   FROM  OrganizationAuthorization
   WHERE Role  	   = '#URL.ID4#'
   AND   AccessLevel < '8'
   <cfif url.source eq "Manual">
   AND   Source = 'Manual'
   </cfif>
   AND   OrgUnit is NULL  
   <cfif URL.ID5 neq "">
    AND   UserAccount IN (SELECT Account FROM System.dbo.UserNames
						 WHERE (UserAccount LIKE '%#URL.ID5#%' OR Lastname LIKE '%#URL.ID5#%' OR FirstName LIKE '%#URL.ID5#%')
						 )
   </cfif>    
  
   GROUP BY  UserAccount, ClassIsAction,  <cfif Role.Parameter neq "Entity">ClassParameter,</cfif> AccessLevel, Source 
     
   UNION ALL
   
   SELECT DISTINCT 
          UserAccount as UserAccount, 
		  <cfif Role.Parameter eq "Entity">	
		  'NA' as ClassParameter, 
		  <cfelse>
		  ClassParameter,
		  </cfif>
		  ClassIsAction, 
		  Source,
		  Max(Mission) as Mission, 		 
		  AccessLevel,
		  'Access' as Type 
   FROM  OrganizationAuthorizationDeny
   WHERE Role  	   = '#URL.ID4#'
   AND   AccessLevel < '8'
   <cfif url.source eq "Manual">
   AND   Source = 'Manual'
   </cfif>
   AND   OrgUnit is NULL   
   <cfif URL.ID5 neq "">
   AND   UserAccount IN (SELECT Account FROM System.dbo.UserNames
						 WHERE (UserAccount LIKE '%#URL.ID5#%' or Lastname LIKE '%#URL.ID5#%' OR FirstName LIKE '%#URL.ID5#%')
						 )  
   </cfif>  
   GROUP BY  UserAccount, ClassIsAction, <cfif Role.Parameter neq "Entity">ClassParameter,</cfif> AccessLevel, Source 
 
</cfquery>

<cfquery name="SearchResult" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT   U.Account,
	            U.FirstName, 
	            U.LastName, 
			    U.AccountType, 
			    U.AccountGroup, 
				U.Disabled,
			    A.*, 
			    LastConnection as LastLogon
	   FROM     System.dbo.UserNames U INNER JOIN
	            userQuery.dbo.Access#SESSION.acc#_#fileNo# A ON U.Account = A.UserAccount LEFT OUTER JOIN
	            System.dbo.skUserLastLogon L ON A.UserAccount = L.Account 
	   WHERE    U.AccountType != 'Group' OR (U.AccountType = 'Group' 
	                                         and U.AccountMission IN (SELECT Mission FROM Ref_Mission WHERE Operational = 1))			
	   <!--- WHERE    U.Disabled = '0'  --->
	   ORDER BY U.AccountType,    			
	            U.LastName, 
				U.FirstName, 
				U.Account, 
				A.Source, 
				U.AccountGroup, 
				A.AccessLevel DESC 
</cfquery>
 
<cf_dialogOrganization>

<cfform style="height:98%" action="ControlBatch.cfm?context=#url.context#&ID=#URL.ID0#&ID4=#URL.ID4#" method="post" name="formresult" id="formresult">
  
<table width="97%" height="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">

  <tr>
  
  <td colspan="1" height="20" style="height:40px;padding-left:4px">
  
  <table><tr>
   
  <cfif url.context eq "0">
  
  	<cfoutput>
	  <input type="hidden" name="selectrole" id="selectrole" value="#URL.ID4#">
	</cfoutput>
  
  <cfelse>
  
  <td>
  <select class="regularxl" name="selectrole" id="selectrole" onChange="javascript: reloadForm(this.value,selectuser.value,inherited.checked)">
  	<cfoutput query="RoleSelect">
	  <option value="#Role#" <cfif URL.ID4 eq Role>selected</cfif>>#Description# [#Role#]</option>
	</cfoutput>
  </select>
  </td>
  
  </cfif>
    
 <cfquery name="userSelect" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	   SELECT   DISTINCT B.LastName, 
			    B.FirstName, 
	            B.Account 
	   FROM     OrganizationAuthorization A, 
	            System.dbo.UserNames B
	   WHERE    A.UserAccount = B.Account
	   AND      A.Role  	   = '#URL.ID4#' 
	   AND      A.AccessLevel < '8'
	   AND      A.OrgUnit is NULL    
	   ORDER BY LastName, FirstName
 </cfquery>
 
 <cfoutput>
 
 <td style="padding-left:4px">
 <input type="text" 
	   name="selectuser"
	   id="selectuser" 
	   class="regularxl"	
	   style="height:25" 
	   value="#url.id5#" 	 
	   size="20" 
	   maxlength="20">
</td>	   
	  
 </cfoutput>
   
   <td style="padding-left:4px">
	  <input type="checkbox" 
		name="inherited" id="inherited" <cfif url.source eq "All">checked</cfif>
		value="1" 
		onclick="reloadForm(selectrole.value,selectuser.value,this.checked)"></td><td style="padding-left:4px" class="labelit">Show Inherited</td>
	
	<td style="padding-left:4px">
		
	   <cfoutput>
	   <button type="button"
	       name="Find"
           id="Find"
	       value="Find"
	       class="button10g" style="width:80;height24"
	       onClick="reloadForm(selectrole.value,selectuser.value,inherited.checked)">
		   <img src="#SESSION.root#/Images/locate.gif" height="12" width="12" alt="Role" border="0" align="absmiddle">&nbsp;Find
		 </button>  
		</cfoutput>	
		
		</td>
	</tr>
	</table>	
  
  </td>
  
  <td height="32" align="right" colspan="1">
  
  	     <table class="formspacing"><tr>
		 <td>	
	   <cfoutput>
	  
	       <button type="button" name="Officer" id="Officer"
		   onMouseOver="this.className='Button10g'"
		   class="button10g" style="width:120;height:27"
	       onMouseOut="this.className='Button10g'"
		   onClick="userlocateN('access','#URL.ID4#','Global','','')">
		      <img src="#SESSION.root#/Images/insert.gif" alt="Role" border="0" align="absmiddle"><cf_tl id="Add User">
		   </button>
        </cfoutput>		
		</td>
		
		<cfif SearchResult.recordcount gt "0" and (access eq "EDIT" or access eq "ALL")>
		  
		  <td>
			  <input type  = "submit"
		       name        = "Purge"
			   id          = "Purge"
		       value       = "Revoke"
		       class       = "button10g" 
			   style       = "width:120;height:27"
		       onClick     = "javascript: return Process('remove')"
		       onMouseOver = "this.className='Button10g'"
		       onMouseOut  = "this.className='Button10g'">
		  </td> 
	   
	   </cfif>
	   
	   </tr>
	   </table>
	 
  </td>
  
  </tr>
    
  <cfif Role.RoleMemo neq "">
  
  <tr><td colspan="2" height="20" style="padding:2px">
  <table width="100%" cellspacing="0" cellpadding="0"> 
  <tr class="line">
    <td style="height:45px;font-size:21px;;border:0px silver solid;padding-left:7px" class="labellarge">
	<h1 style="padding-left:5px;font-size:25px;font-weight:200;">
	<cfoutput>#Role.RoleMemo#</cfoutput>
	</h1>
	</td>
  </tr>
  </table>
  </td></tr>
     
  </cfif>
  	  
  <tr>
  
  <td width="100%" colspan="2" valign="top" style="padding-top:0px;padding-bottom:5px">
    	
	  <cf_divscroll>
		
		<table width="98%" align="center" class="navigation_table">
		
		<tr><td colspan="11"></td></tr>
		
		<TR class="labelmedium2 line fixrow fixlengthlist">
		    <td width="10"></td>
			<TD><cf_tl id="Name"></TD>
			<td></td>
			<TD><cf_tl id="Account"></TD>
			<TD><cf_tl id="Class"></TD>
			<td><cf_tl id="Logon"></td>
			<TD><cf_tl id="Source"></TD>
			<TD width="7%"><cf_tl id="Level"></TD>
			<TD><cf_tl id="<cfoutput>#Role.Parameter#</cfoutput>"></TD>
			<td></td>
			<td height="20">&nbsp;</td>		
		</TR>
		
		<cfif searchresult.recordcount eq "0">		
`			<tr class="labelmedium line" style="height:40px"><td align="center" colspan="11">
			<cf_tl id="There are no records to show in this view"></td>
		    </tr>
		</cfif>
					
		<cfset user = "">
			   
		<cfoutput query="SearchResult" group="AccountType">
	
			<tr class="line labelmedium2 fixrow2 fixlengthlist">
			   <td width="10%" colspan="11" style="padding-left:4px;height:50px">
			      <table>
				  <tr>
				  <td>
				  <cfif accounttype eq "Group">
				  <img src="#SESSION.root#/Images/group.png" height="36" alt="" border="0">
				  <cfelse>
				  <img src="#SESSION.root#/Images/user3.png" height="36" alt="" border="0">
				  </cfif>
				  </td>
				  <td class="labellarge" style="padding-top:10px;padding-left:6px">#AccountType#</td>
				  </tr>
				  </table>
			</tr>
				
				<cfoutput group="LastName">
				<cfoutput group="FirstName">
				<cfoutput group="Account">	
				<cfoutput group="Source">
					
			    <cfif Type eq "Denied">
					<tr bgcolor="F39E89" id="#account#_1" class="navigation_row labelmedium fixlengthlist">
				<cfelseif AccountType eq "group">
		    		<tr id="#account#_1" class="navigation_row labelmedium fixlengthlist">
				<cfelse>
					<tr id="#account#_1" class="navigation_row labelmedium fixlengthlist">
				</cfif> 
				
				<td height="20" align="center" style="padding-top:3px"> 
				     <cfif user neq Account>			 
					    <cf_img icon="open" tooltip="manager authorization" onclick="process('#Account#')" navigation="Yes">					       				
					  </cfif>
				</td>	
				
				<td align="left" style="padding-right:10px;padding-top:9px">
				
				 <cfif AccountType eq "Group">	 
		 		   <cf_img icon="expand" tooltip="members" toggle="yes" onclick="group('#Account#','#currentRow#')">			
				  </cfif>	
				  
		        </td>				   			
							  
				<td>
				
				     <cfif AccountType eq "Group">
					 
					 	 <cfif user neq Account>					 	 
						 	#LastName#					
						 </cfif>
						 
					 <cfelse>
					    
					 	<cfif user neq Account>										 
						 #LastName#, #FirstName#					
						 </cfif>
						 
					 </cfif>
				</td>	
			 
				<TD><cfif user neq Account>#account#</cfif></TD>
				<TD><cfif user neq Account>#accountgroup#</cfif></TD>	 
				<td>					
						
					<cfif disabled eq "1">				
				     	 <font color="red">disabled</font>						 
					<cfelseif user neq Account>								
						 <cfif DateFormat(LastLogon, CLIENT.DateFormatShow) eq "">			  		    
							 <font color="FF0000">never</font>						 
						 <cfelse>					 
						     #DateFormat(LastLogon, CLIENT.DateFormatShow)#						 
						 </cfif>				 
					</cfif>			
				 
				</td> 
				<TD>			
				<cfif source neq "manual">
					<img src="#SESSION.root#/Images/group1.gif" align="absmiddle" alt="Inherited" border="0">&nbsp;#source#&nbsp;
				<cfelse>Manual</cfif>
				</TD>				
				<TD>
				
					<cfif Role.AccessLevels eq "2">
					
						<cfset lbl = ListToArray(Role.AccessLevelLabelList)>
						<cftry>
							    #lbl[accesslevel]#
						<cfcatch>#accesslevel#</cfcatch>
						</cftry>
					
					<cfelse>
				
						<cfset lbl = ListToArray(Role.AccessLevelLabelList)>
						<cftry>
							    #lbl[accesslevel+1]#
						<cfcatch>#accesslevel#</cfcatch>
						</cftry>
					</cfif>	
			 	
				</TD>
				<td>
				
					<div style="width:120px;height:15;overflow-y: auto;">				
					<table width="100%">					 				
					
					    <cfif ClassIsAction neq "1">		
						  
						    <cfoutput group="classparameter">
							<tr class="labelmedium" style="height:15px"><td>#ClassParameter#</td></tr>
							</cfoutput>
							
						<cfelse>					
						<!--- hide entries, it is too much 23/7/05 
						
						 <cfquery name="Entity" 
					   datasource="AppsOrganization" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
					   SELECT *
					   FROM   Ref_EntityAction
					   WHERE  ActionCode IN ('dummy'<cfoutput>,'#ClassParameter#'</cfoutput>)
					   ORDER BY EntityCode, ListingOrder
					  </cfquery>
					  
					  	<table width="100%">
					    <cfloop query="Entity">
							<tr><td>#ListingOrder#</td>
							    <td>#ActionCode#</td>
							    <td>#ActionDescription#</td>
							</tr>
						</cfloop>
						</table>
						
						--->
									   	
						</cfif>
													
					</table>
					</div>		
								
				 </td>
				 <td align="center">
				 
				  <cfif Mission neq "">
				  					 
						<img src="#SESSION.root#/Images/tree3.gif" alt="" height="14" width="12"
							id="#currentrow#tExp" border="0" class="show" 
							align="absmiddle" style="cursor: pointer;" 
							onClick="javascript:detail('#URL.ID4#','#account#','#currentrow#','#source#')">
							
						<img src="#SESSION.root#/Images/icon_collapse.gif" 
							id="#currentrow#tMin" alt="" border="0" 
							align="absmiddle" class="hide" style="cursor: pointer;" 
							onClick="javascript:detail('#URL.ID4#','#account#','#currentrow#','#source#')"> 
						   
				  </cfif> 
				  
				 </td>			 
						 
				 <td align="center">
				 
				    <cfif access eq "EDIT" or access eq "ALL">
					
					    <cfif user neq Account>
					     <input type="checkbox" name="Account" id="Account" value="'#Account#'" onClick="hl('#account#',this.checked,'2')">
						</cfif>
					
					</cfif>
					
			     </td>
				
				 <cfset user = Account>
				 
					 <!---
					 
					 <cfif ClassParameter neq "Default">		 	
					 
					 <tr id="#account#_3">
					 <td colspan="1" bgcolor="white">
					 <td colspan="8" align="left" bgcolor="E8FFFF">
					    <cfif ClassIsAction neq "1">
						    <cfoutput group="classparameter">&nbsp;#ClassParameter#&nbsp;|&nbsp;</cfoutput>
						<cfelse>
						
						<!--- hide entries, it is too much 23/7/05 
						
						 <cfquery name="Entity" 
					   datasource="AppsOrganization" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
					   SELECT *
					   FROM   Ref_EntityAction
					   WHERE  ActionCode IN ('dummy'<cfoutput>,'#ClassParameter#'</cfoutput>)
					   ORDER BY EntityCode, ListingOrder
					  </cfquery>
					  
					  	<table width="100%">
					    <cfloop query="Entity">
							<tr><td>#ListingOrder#</td>
							    <td>#ActionCode#</td>
							    <td>#ActionDescription#</td>
							</tr>
						</cfloop>
						</table>
						
						--->
									   	
						</cfif>
											    
				     </td>
					 </tr>
					 </cfif>
					 
					 --->
						  
				  <cfif Mission neq "">
						   
				    <tr class="hide" id="result_#currentrow#">		    
					 <td></td>
				     <td bgcolor="ffffcf" colspan="10" id="iresult_#currentrow#"></td>
					 <td></td>
					</tr>
								  		  
				  </cfif>
				  
				  <cfif AccountType eq "Group">
				  
				  <tr id="#CurrentRow#" class="hide"><td></td>
					  <td colspan="8" id="i#CurrentRow#"></td>
					  <td></td>
					  <td></td>		  
				  </tr>
				  			 
				  </cfif>	 
				  				 
			</CFOUTPUT>	 
					
			<tr><td class="line" colspan="11"></td></tr>
			
			</cfoutput> 	     
				
			</cfoutput>				
			</cfoutput>
			
		</cfoutput>
			
		</table>
		
	</cf_divscroll>
		
	</td></tr>

</table>	

</cfform>
	
<cfif url.context eq "1">
	<cf_screenbottom layout="webapp">
</cfif>	

<cfset ajaxonload("doHighlight")>
