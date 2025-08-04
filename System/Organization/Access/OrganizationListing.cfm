<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cf_screentop html="No" jQuery="Yes">

<!--- bugs that we are aware of

1. Imagine you delete inherited access, so it moves to denied table, then you grant access manually for the same, effectively
revoking the deletion. The record remains in deleted (denied) it should technically be restored I believe 

2. Imagine you lower/denie on a unit level globally assigned access (unit = NULL), 
this will revert the global access  (and brings up the revert on the global level for group inherited). 

This is not how it intended, solution prevent check box if this was inherited by global access 

--->

<cfparam name="URL.ID1" default=""> <!--- orgunit --->
<cfparam name="URL.ID2" default=""> <!--- mission --->
<cfparam name="URL.Mission" default="#URL.ID2#">
<cfparam name="URL.ID3" default=""> <!--- mandate --->
<cfparam name="URL.ID4" default=""> <!--- role    --->
<cfparam name="URL.ID5" default="">

<cfif url.mission eq "">
	<cfset url.mission = url.id2>
</cfif>

<!--- provision for mandate selection --->

<cfif url.id1 eq "" and url.id3 neq "">

	<cfquery name="orgunit"
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT OrgUnit 			
		FROM   Organization 
		WHERE  Mission    = '#url.Mission#'
		AND    MandateNo  = '#url.id3#' 
		ORDER BY HierarchyCode
	</cfquery>	
			
	<cfset orgunit = orgunit.orgunit>	
	
<cfelse>
	
	<cfset orgunit = url.id1>	
		
</cfif>

<cfinclude template="OrganizationListingScript.cfm">
 
<input type="hidden" name="mission" id="mission" value="<cfoutput>#URL.Mission#</cfoutput>">

<cfquery name="Organization"
	datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#"> 
     SELECT  *
     FROM    Organization 
     WHERE   OrgUnit = '#url.id1#' 
</cfquery>

<cfquery name="Role"
	datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#"> 
     SELECT  *
     FROM    Ref_AuthorizationRole 
     WHERE   Role = '#URL.ID4#' 
	 ORDER BY ListingOrder
</cfquery>


<!--- 10/10/2010 tuning for cleaning if role has a parameter remove the access for users granted to default --->

<cfquery name="RoleSelect"
	datasource="AppsOrganization" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#"> 
	   SELECT   R.*, S.Description as ModuleName
	   FROM     Ref_AuthorizationRole R, 
	            System.dbo.Ref_SystemModule S
	   WHERE    R.SystemModule = S.SystemModule
	   AND      S.Operational = '1'
	   <cfif Role.OrgUnitLevel eq "Warehouse">
	   AND      R.OrgUnitLevel IN ('Warehouse') 
	   <cfelse>
	   AND      R.OrgUnitLevel IN ('Global','Parent','Tree','All') 
	   </cfif>
	   <cfif SESSION.isAdministrator eq "No">
	   AND     (R.RoleOwner IN (SELECT ClassParameter 
			                    FROM   OrganizationAuthorization
								WHERE  Role = 'AdminUser'
								AND    UserAccount = '#SESSION.acc#')
					OR R.RoleOwner is NULL)		
	   </cfif>
	   AND      R.OrgUnitLevel NOT IN ('Global','Fly')
	   AND      R.SystemModule = '#Role.SystemModule#'
	   ORDER BY R.Area, R.SystemModule, R.ListingOrder, R.SystemFunction
</cfquery>

 <cfquery name="SearchResult" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   
   <cfif orgunit neq "">
	   SELECT *, '0. Mission global' as Type
	   FROM OrganizationAuthorization A, System.dbo.UserNames B
	   WHERE A.UserAccount	= B.Account
	   AND   A.Role  		= '#URL.ID4#'
	   AND   A.Mission = '#URL.Mission#'
	   AND   A.OrgUnit is NULL
	   AND   A.AccessLevel < '8'
	   AND   A.Source = 'Manual' 
	   
	   <cfif URL.ID5 neq "">
	   AND   Account = '#URL.ID5#'
	   </cfif>
	   
	   UNION   
	   </cfif>
	   
	   SELECT  *, '1. Manual' as Type
	   FROM    OrganizationAuthorization A, System.dbo.UserNames B
	   WHERE   A.UserAccount	= B.Account
	   AND     A.Role  		= '#URL.ID4#'
	   <cfif orgunit eq "">
		   AND   (A.Mission = '#URL.Mission#' <cfif roleselect.orgunitlevel eq "Global"> or A.Mission is NULL </cfif>)
		   AND   A.OrgUnit is NULL
	   <cfelse>
		   AND   A.OrgUnit = '#orgunit#'
	   </cfif>
	   AND     A.AccessLevel < '8'
	   AND     A.Source = 'Manual' 
	   <cfif   URL.ID5 neq "">
	   AND     Account = '#URL.ID5#'
	   </cfif>
	   
	   UNION
	   
	   SELECT *, '2. Inherited' as Type
	   FROM OrganizationAuthorization A, System.dbo.UserNames B
	   WHERE A.UserAccount	= B.Account
	   AND   A.Role  		= '#URL.ID4#'
	   <cfif orgunit eq "">
		   AND   (A.Mission = '#URL.Mission#' <cfif roleselect.orgunitlevel eq "Global"> or A.Mission is NULL </cfif>)
		   AND   A.OrgUnit is NULL
	   <cfelse>
		   AND   A.OrgUnit = '#orgunit#'
	   </cfif>
	   AND   A.AccessLevel < '8'
	   AND   A.Source != 'Manual'
	   <cfif URL.ID5 neq "">
	   AND   Account = '#URL.ID5#'
	   </cfif>
	   
	   UNION
	   
	   SELECT *, '3. Denied' as Type
	   FROM   OrganizationAuthorizationDeny A, 
	          System.dbo.UserNames B
	   WHERE A.UserAccount	= B.Account
	   AND   A.Role  		= '#URL.ID4#'
	   <cfif orgunit eq "">
		   AND   (A.Mission = '#URL.Mission#' <cfif roleselect.orgunitlevel eq "Global"> or A.Mission is NULL </cfif>)
		   AND   A.OrgUnit is NULL
	   <cfelse>
		   AND   A.OrgUnit = '#orgunit#'
	   </cfif>
	   <cfif URL.ID5 neq "">
	   AND   Account = '#URL.ID5#'
	   </cfif>
	   ORDER BY AccountType, 
	            Type, 
				B.LastName, 
				B.FirstName, 
				A.UserAccount 
				
				
</cfquery>

<cfquery name="userSelect" 
   datasource="AppsOrganization" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT DISTINCT LastName, 
                   FirstName, 
				   Account
   FROM    OrganizationAuthorization A, System.dbo.UserNames B
   WHERE   A.UserAccount	= B.Account   		 
   <cfif orgunit eq "">
	   AND   A.Mission = '#URL.Mission#'
	   AND   A.OrgUnit is NULL
   <cfelse>
	   AND   A.OrgUnit = '#orgunit#'
   </cfif>
   AND   A.AccessLevel < '8'
   ORDER BY LastName, FirstName, Account     
</cfquery>

<cf_dialogOrganization>

<HTML><HEAD>
    <TITLE>Search - Search Result</TITLE>

</HEAD>

<body leftmargin="0" onLoad="javascript:document.forms.result.selectrole.focus()">

<cf_divscroll overflowx="auto">

<cfform action="ControlBatch.cfm?ID=#orgunit#&Mission=#URL.Mission#&ID1=#orgunit#&ID2=#URL.ID2#&ID4=#URL.ID4#" method="post" name="formresult" id="formresult">

<table style="width:99%" align="left" class="formpadding">
        
  <tr>
  <td colspan="2" align="left" style="height:42" class="labellarge">
    
	<table width="100%" border="0">
	<tr>
	
	<td class="fixlength labellarge" style="font-size:29px;padding-left:10px">
  	<cfoutput>
	      #URL.Mission#	  
	      <cfif URL.ID3 neq ""><font style="font-size:18px">[#URL.ID3#]</cfif>		  
		  <cfif URL.ID1 neq ""><font style="font-size:22px"><br>#Organization.OrgUnitCode# #Organization.OrgUnitName#</b>
		  <cfelse>&nbsp;
		  <img src="#SESSION.root#/Images/Logos/System/Tree.png" height="25" alt="" align="absmiddle" border="0">						  
		  </cfif>
	  </cfoutput>
	 </td> 
	 
	 <td align="right" valign="top" style="padding-right:8px">
	 
		 <table>
		 <tr>
		 		 		 
		 <td align="right" valign="top" style="padding-top:3px;min-width:200px">
			  
			    <cfselect name="selectrole" 
				   id="selectrole" 
				   query="RoleSelect" 
				   value="Role" 
				   display="Description" 
				   selected="#url.id4#" 
				   style="height:28px;font-size:18px;border:0px;background-color:AAD5FF"
				   class="regularxl" 
				   group="SystemFunction" 
				   onChange="reloadForm(this.value,selectuser.value)"/>		    
				
			   </td>
			   
			   <td>	
			  
			  </td>
			</tr>
			</table>  
	 
	  </td>
	 	 
	 </tr>
	 </table>
	 
  </td>      
  </tr>  
  
 
  
<tr>
   
<td width="100%" colspan="2" style="padding-left:10px;padding-right:10px">

<table width="100%" align="center" class="navigation_table">

  <tr class="labelmedium2 fixlengthlist">
      <td colspan="9" align="center" style="border:1px solid silver;background-color:ffffaf">
      The highest granted access level will dominate, unless user group access is reverted
	  </td>
  </tr>	

 <tr>
  
  <td colspan="9" height="34">
  
	  <table>
	  
	  <tr>	  
	  
	  <td colspan="2" align="left"> 
	  
		  <table>
		  <tr>
		  
		  <!---
		  <td class="labelit">Filter user:</td>
		  --->
		  
		  <td style="padding-left:0px">
		  
		    <select name="selectuser" id="selectuser" style="width:300px" class="regularxl" onChange="reloadView(selectrole.value,this.value)">
			  <option value="">Any</option>
			  <cfoutput query="UserSelect">
			  <option value="#Account#" <cfif URL.ID5 eq Account>selected</cfif>>#LastName#, #FirstName# [#Account#]</option>
			  </cfoutput>
		  </select>  
		  
		  </td>
		  
		  
		  </tr>
		  </table>
	  
	  </td>
	  </tr>
	  
	  </table>
  
  </td>
   
</tr>
 
<TR class="labelmedium2 line fixlengthlist" height="20">
   
	<td colspan="2" style="width:20px;padding-left:1px;padding-right:4px">
	   <cfoutput>
	   
	      <cfif URL.Mission neq "">
		  
	       <input type  = "button"  
	  	      name      = "Officer" 
			  id        = "Officer"
		      value     = "Add" 
			  style     = "height:20px;width:60;font-size:11px"
		      class     = "button10g" 
		      onClick   = "userlocateN('access','#URL.ID4#','Tree','#URL.ID1#','#URL.Mission#','#URL.ID3#')">
		  </cfif>
	   </cfoutput>
	
	</td>
    <TD><cf_tl id="Name"></TD>
	<td height="15">&nbsp;</td>
	<TD><cf_tl id="Account"></TD>	
	<TD><cfoutput>#Role.Parameter#</cfoutput></TD>   
	<td></td>
	<TD><cf_tl id="Created"></TD>
	<td height="15"></td>
</TR>

  
<cfset user = "">
<cfset showaccount = "">

<cfoutput query="SearchResult" group="AccountType">

 <tr class="labelmedium fixrow" style="background-color:white">
    <td colspan="9" style="padding-left:5px;height:40px;font-size:21px;background-color:white">
	<cfif accounttype eq "Group"><cf_tl id="User Group"><cfelse><cf_tl id="Individual User Account"></cfif>
	</td>
 </tr>

<cfset box = 0>
   
<cfoutput group="Type">  

   <cfset box = box+1> 
   	
    <tr class="labelmedium line fixlengthlist">
	
      <td colspan="9" class="labelmedium" style="font-weight:bold;font-size:19px;height:35px">
	  
		  <cfif type eq "1. Manual">
		  
			Recorded / Amended</h2>
			
		  <cfelseif type eq "2. Inherited">
			
			Inherited access through user group(s)</h2>
           			
		  <cfelseif Type eq "3. Denied">
	    	
			<span color="808080">Denied</span>
		    One or more rights inherited from a usergroup were revoked on the individual user level</h2>
	 	 
		  <cfelseif left(type,1) eq "0">
			
			Inherited through Global #url.mission# access</h2>
		  			
		  </cfif>
	  
	  </td>
	  
    </tr>  
	          
<cfoutput group="LastName">

	<cfoutput group="FirstName">
	
		<cfoutput group="UserAccount">
		
				<cfif not find(":#useraccount#",showaccount) or type eq "3. Denied">
				
				<cfif type neq "1. Manual">			
					    <cfset showaccount = "#showaccount#:#useraccount#">				
				</cfif>
				
				<cfif AccountType eq "Group">
				
				<tr bgcolor="ffffff" class="navigation_row labelmedium2 line fixlengthlist" style="height:22px">		
				  <td width="30" align="center" style="padding-top:3px">		 
				 	 <cf_img icon="open" navigation="Yes" onclick="process('#URLEncodedFormat(Account)#')">			    
				   </td>			  	   
				   <td style="width:20px"></td>
				   
				<cfelseif left(type,1) eq "3" >
				
				 <!--- 3. denied --->
				 <tr bgcolor="F39E89" class="navigation_row labelmedium line fixlengthlist" style="height:22px">
				
				 <td width="30" align="center"></td>	
				 <td></td>
				   
				<cfelseif left(type,1) eq "2">
				
				<!--- inherited --->
				
				<tr bgcolor="ECF5FF" class="navigation_row labelmedium line fixlengthlist" style="height:22px">
				
				 <td align="center" style="width:30px;padding-top:1px">	 
				     <cf_img icon="open" navigation="Yes" onclick="process('#URLEncodedFormat(Account)#')">			   
				 </td>	
				 
				 <td style="width:30px;padding-top:8px">		
					 <cf_img icon="expand" toggle="Yes" onclick="drilldown('#account#','#box#_#account#','tree','#url.mission#','','#url.id4#','#orgunit#')">	      
				 </td>
					   
				<cfelseif left(type,1) eq "0"> 
				
					<!--- inherited from entity --->  
				
					 <tr bgcolor="ffffdf" class="navigation_row labelmedium2 line fixlengthlist" style="height:22px">
				
					 <td align="center"></td>	
					 <td></td>	
				   
				<cfelse>
				
					<tr class="navigation_row labelmedium2 line fixlengthlist">
					
					<td align="center" style="padding-top:1px">
					
					   <cf_img icon="edit" navigation="Yes" onclick="process('#URLEncodedFormat(Account)#')">
						   
				    </td>	
				   
				    <td style="padding-top:3px">
					
					  <cf_img icon="expand" toggle="Yes" onclick="drilldown('#account#','#box#_#account#','tree','#url.mission#','','#url.id4#','#orgunit#')">
				      
				    </td>
					
				</cfif>
			   
				<td>
				   <a title="Access User Profile"  href="javascript:ShowUser('#URLEncodedFormat(Account)#')">#LastName#, #FirstName#</a>
			    </td>
				
				<cfif AccountType eq "Group">
				
				 	 <td align="right">
					
				    	<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
							name="#currentrow#Exp" id="#currentrow#Exp" 
							border="0" 
							height="11"
							align="absmiddle" class="regular" style="cursor: pointer;" 
							onClick="more('#Account#','#currentRow#')">
							 
						<img src="#SESSION.root#/Images/arrowdown.gif" 
							name="#currentrow#Min" id="#currentrow#Min" alt="" border="0"  height="11"
							align="absmiddle" class="hide" style="cursor: pointer;" 
							onClick="more('#Account#','#currentRow#')">
					 </td>
					 
					  <TD>
					  <a href="javascript:more('#Account#','#currentRow#')">#account#</a>
					  </TD>
				 <cfelse>
				 
				  <td></td>   
				  <TD>#account#</TD>
					  	  		
			     </cfif>	
				
				 <cfif ClassParameter eq "Default" and Role.Parameter eq "">
				 
				 	 <TD>#ClassParameter#</TD>
					 <TD>
				      
						  <cfset lbl = ListToArray(Role.AccessLevelLabelList)>
						  <cftry>
						  #lbl[accesslevel+1]#
						  <cfcatch>#accesslevel#</cfcatch>
						  </cftry>
				  	  	 	
				 	</TD>
				 
				 <cfelse>
				 
					 <td colspan="2">
					 <cfif Type neq "3. Denied">
					      
					      <a class="navigation_action" href="javascript:process('#URLEncodedFormat(Account)#')">Set multiple</a> 
			 
					 </cfif>
					 </td>
					 
				 </cfif>
				 
				 <TD>#DateFormat(Created, CLIENT.DateFormatShow)#&nbsp;</TD>	
				 
				 <td style="padding-top:3px" align="center">	 
				     <cfif Type neq "3. Denied">
				     	<input type="checkbox" name="Account" id="Account" value="'#Account#'" onClick="hl(this,this.checked,'1')">&nbsp;
					 </cfif>
			     </td>
				 
				 </tr>
					 	
				<tr id="row_#box#_#account#" class="hide">	
					<td colspan="9" id="#box#_#account#"></td>
				</tr>
				 	
				<tr id="#CurrentRow#" class="hide">
					<td></td>
					<td colspan="8" id="i#CurrentRow#"></td>
				</tr>
				
				<cfif Type eq "3. Denied">
				
					<cfquery name="Denied"
					datasource="AppsOrganization"> 
						 SELECT *
					     FROM   OrganizationAuthorizationDeny A
					     WHERE  A.UserAccount	= '#UserAccount#'
					     AND    A.Role  		= '#URL.ID4#'
					     <cfif orgunit eq "">
						 AND    A.Mission = '#URL.Mission#'
						 AND    A.OrgUnit is NULL
					     <cfelse>
						 AND    A.OrgUnit = '#orgunit#'
					     </cfif>    
					</cfquery>
					<tr>
					<td></td>
					<td colspan="7">
					<table width="100%">
						<cfloop query="Denied">
						<tr class="labelmedium2">
						<td><a href="javascript:reinstate('#url.id4#','#url.id5#','#accessid#')"><cf_tl id="Reinstate"></a></td>
						<td>#ClassParameter#</td>
						<td>#GroupParameter#</td>
						<td>
						<cfif AccessLevel eq "0">Read</cfif>
						<cfif AccessLevel eq "1">Edit</cfif>
						<cfif AccessLevel eq "2">All</cfif>
						</td>
						<td>#Source#</td>
						<td>#dateformat(created,CLIENT.DateFormatShow)#</td>
						</tr>
						</cfloop> 
					</table>
				
				</cfif>
				
			</cfif>
		
		</cfoutput>
	</cfoutput>
</cfoutput>
</cfoutput>
</cfoutput>
	
	<cfif SearchResult.recordcount gt "0">
	
	  <tr><td height="5"></td></tr>
	  <tr>
	  <td colspan="9" align="center" height="30">
	  
	  <cfoutput>
	  
		  <input  type    = "button" 
		          name    = "Broadcast" 
				  id      = "Broadcast" 
				  value   = "Broadcast" 
				  class   = "button10g" 
				  style   = "width:140px;height:25px" 
				  onClick = "broadcast('#URL.ID4#','#URL.Mission#')">
				
		  <input  type    = "submit" 
			      name    = "Purge" 
				  id      = "Purge" 
				  value   = "Revoke" 
				  class   = "button10g" 
				  style   = "width:140px;height:25px" 
				  onClick = "return Process('remove')">
		  
	  </cfoutput>
	  
	  </td>
	  </tr>
		   
	</cfif>	
	
	</table>
	
	</td></tr>
	
	</table>

</cfform>

</cf_divscroll>

<script>
	Prosis.busy('no')
</script>

<cfset AjaxOnLoad("doHighlight")>
