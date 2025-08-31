<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.mode" default="">

<cfoutput>

	<script language="JavaScript">
	
	    function reloadheader(acc) {				       
			   _cf_loadingtexthtml='';		
		       ptoken.navigate('#SESSION.root#/System/Access/User/UserDetailIdentification.cfm?id='+ acc,'userheader')	
			
		} 
	
		function UserEdit(account,script) {				     
			  ProsisUI.createWindow('mydialog', 'User', '',{x:100,y:100,height:document.body.clientHeight-120,width:document.body.clientWidth-120,modal:true,center:true})    			 				
			  ptoken.navigate('#SESSION.root#/System/Access/User/UserView.cfm?ID=' + account+'&script='+script,'mydialog') 				
		}		
	
	</script>
	
</cfoutput>

<cfquery name="User" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM   UserNames
    WHERE  Account = '#URL.ID#'
</cfquery>

<cfquery name="Last" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT LastConnection 
	FROM   skUserLastLogon 
	WHERE  Account = '#URL.ID#'
</cfquery>

<cfquery name="Mission" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   TOP 1 P.MissionOperational
    FROM     PersonAssignment A INNER JOIN Position P ON A.PositionNo = P.PositionNo
	WHERE    A.PersonNo     =   '#user.PersonNo#'
	AND      A.DateEffective <= '#dateformat(now(),client.dateSQL)#' 
	and      A.DateExpiration >= '#dateformat(now(),client.dateSQL)#'
	AND      A.AssignmentStatus IN ('0','1')
	AND      A.Incumbency > 0
	ORDER BY A.Created DESC
</cfquery>
<style>
    input.button10g:hover{
        background-color: #033F5D!important;
    }
</style>
<table width="95%" align="center">
  <tr class="labemedium2 line fixlengthlist">
    <cfoutput>	
    <td align="left" valign="middle" style="height:58px;padding-top:6px;">
	
        <table>
		<tr>
		<td valign="top" style="padding-right:5px">		
		
		<cfif user.accounttype eq "Group">
			<img style="position: relative;left:2px;" src="#SESSION.root#/Images/User-Group.png" height="79" width="79" alt="" border="0">
		<cfelse>
			<img style="position: relative;top:6px;left:2px;" src="#SESSION.root#/Images/User.png" height="56" width="56" alt="" border="0">
		</cfif>
		
		</td>
		
		<td style="min-width:300px">		
           <span style="font-size:34px;"> <cfif User.AccountType eq "Individual">#User.FirstName# </cfif> #User.LastName#</span><br><span style="padding-left:10px;font-size: 16px;position: relative;top:-6px;">- #User.Account# -</span></h2>			
		</td>
		</tr>
		</table> 		
		
	</cfoutput>
    </td>
	<td colspan="2" height="24" align="right" valign="middle">
		
	<cfinvoke component   = "Service.Access"  
		   method         = "useradmin" 		   
		   treeaccess     = "yes"
		   mission        = "#user.accountmission#"
		   returnvariable = "Access">
		 				  
	<cfif Access eq "EDIT" or Access eq "ALL">
  
		<cfoutput>
			<input type="button" 
			name="Edit" 
			id="Edit"
			value="User Settings" 
			class="button10g" style="font-size:14px;line-height: 18px; width:140;height:40;background-color: ##3498db;color: ##ffffff;border:##3498db;position: relative;top: -2px;"
			onClick="UserEdit('#URLEncodedFormat(User.Account)#','reloadheader')">
		</cfoutput>		
	
	</cfif>
	  
    </td>
   </tr> 	
  
   <tr>
     
    <td colspan="1" valign="top" style="padding-left:10px">
	
	    <table width="99%">
	
		 <cfoutput query="User">	
		 
		    <tr><td height="5"></td></tr>		 
	
	        <tr class="labelmedium2 fixlengthlist" style="height:20px">	       
			    <td ><cf_tl id="Account">:</td>
			    <td colspan="2" >#User.Account# [#User.Source#]</td>
			    <td ><cf_tl id="Operational Entity">:</td>
			    <td colspan="2" >#AccountMission#&nbsp;				
				<cfif Mission.recordcount gte "1" and Mission.MissionOperational neq AccountMission>				
				[<cf_tl id="Assignment"> :#Mission.MissionOperational#]				
				</cfif>
				
				</td>					
		   </tr>		
		  
		   <cfif User.AccountType eq "Individual">
		  					
		      <tr class="labelmedium2 fixlengthlist" style="height:20px">
	    	    <td><cf_tl id="Name">:</td>
	        	<td colspan="2" >#FirstName# #LastName#</td>
				
				<td ><cf_tl id="LDAP"><cf_tl id="Name">:</td>
				<td  colspan="2"><cfif MailServerAccount eq ""><font color="FF0000"><cf_tl id="not set"><cfelse>#MailServerAccount#</cfif> <cfif EnforceLDAP eq "1"><font color="gray">[enforced]</font></cfif>
		     	</td>	
				
			  </tr>
			  
		      <tr class="labelmedium2  fixlengthlist" style="height:20px">
		        <td><cf_tl id="IndexNo">:</td>
				<td  colspan="2"><cfif IndexNo neq ""><A HREF ="javascript:EditPerson('#IndexNo#')">#IndexNo#</a>
				<cfelse><font color="FF0000">Not defined</font>
				</cfif>
		     	</td>	
				
				 <td><cf_tl id="Last Logon">:</td>
				 <td  colspan="2"><cfif Last.LastConnection eq ""><font color="FF0000"><b><cf_tl id="Never"></b>
				<cfelse>#DateFormat(Last.LastConnection, CLIENT.DateFormatShow)# at #TimeFormat(Last.LastConnection, "HH:mm")#
				</cfif>
				 </td>	
					
					
		      </tr>
			  		  
		   <cfelse>
		  							
		      <tr class="labelmedium2 fixlengthlist" style="height:20px">
	    	    <td><cf_tl id="Name">:</td>
		        <td  colspan="2">#LastName#</td>
				<td  colspan="2">
					<cfif Last.LastConnection eq ""><font color="FF0000"><b><cf_tl id="Never">
					<cfelse>#DateFormat(Last.LastConnection, CLIENT.DateFormatShow)# at #TimeFormat(Last.LastConnection, "HH:mm")#
					</cfif>
				 </td>
			  </tr>
			 	  		  	  
		   </cfif>	  
		  				  
		   <tr class="labelmedium2 fixlengthlist" style="height:20px">
	        <td><cf_tl id="Group">:</td>
	        <td colspan="2" >#AccountGroup#</td>
			<td ><cf_tl id="Account Owner">:</td>
	        <td colspan="2">
			
				<cfquery name="Owner" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_AuthorizationRoleOwner
					WHERE Code = '#AccountOwner#'	
				</cfquery>
				
				<cfif AccountOwner neq "">#Owner.Description#<cfelse><font color="gray">Not defined</font></cfif>
			
			</td>
	       </tr>
		  			  
		   <tr class="labelmedium2 fixlengthlist" style="height:20px">
	        <td><cf_tl id="eMail">:</td>
	       	<td colspan="2" ><cfif eMailAddress neq "">
			    <a href="javascript:email('#eMailAddress#','','','','User','#Account#')">#eMailAddress#
			 <cfelse>
				<font color="FF0000">n/a</font>
			 </cfif>
			 </td>
			 
			 <td><cf_tl id="eMail2">:</td>
	       	 <td colspan="2"><cfif eMailAddressExternal neq "">
			    <a href="javascript:email('#eMailAddressExternal#','','','','User','#Account#')">#eMailAddressExternal#
			 <cfelse>
			 	<font color="ff0000">n/a</font>
			 </cfif>
			 </td>			
	      </tr>
		  			  
		  <tr class="labelmedium2 fixlengthlist" style="height:20px">
	        <td><cf_tl id="IP">:</td>
	        <td colspan="2"><cfif NodeIP neq "">#NodeIP#<cfelse><font color="gray"><cf_tl id="Not determined"></font></cfif></td>
	      </tr>
		 
		  <tr class="labelmedium2 fixlengthlist" style="height:20px">
	        <td><cf_tl id="Account Status">:</td>
	        <td colspan="2" style="font-size:14px;cursor:pointer">
						
			<cfif Access eq "EDIT" or Access eq "ALL">
			
				<cfdiv id="userstatus">		    
					<cfif Disabled eq "0">					
					<a style="font-size:14px" title="Press to disable" href="javascript:ptoken.navigate('UserStatus.cfm?account=#url.id#&status=1','userstatus')">
					<font color="green"><cf_tl id="Active"></a>
					<cfelse>
					<a style="font-size:14px" title="Press to activate" href="javascript:ptoken.navigate('UserStatus.cfm?account=#url.id#&status=0','userstatus')">
					<font color="FF0000"><cf_tl id="Disabled"></font>
					</a><font color="gray">
						 <cf_UIToolTip tooltip="This applies for Backoffice only. User might still access a Portal.">( Backoffice only )</cf_UIToolTip></font>
					</cfif>
				</cfdiv>
			
			<cfelse>
			
				<cfif Disabled eq "0">
					<font color="green"><cf_tl id="Active">
				<cfelse>
					<font color="FF0000"><cf_tl id="Disabled"></font>
				</cfif>
			
			</cfif>
			
			</td>			
			<td><cf_tl id="Source">:</td>
			<td>#Source#</td>
			
	      </tr>
		  		  		 	    	   
	    </table>
    </td>
	
	</cfoutput>
	 
	<cfoutput query="User"> 
	  
		<td  style="padding-top:4px" valign="top" align="right">			
			<cf_tl id="Change user picture" var="1">
			<cf_userProfilePicture acc="#URL.ID#" height="130px" width="auto" title="#lt_text#">
			   
		 </td>
		  					
	 </cfoutput>	
	
  </tr>  
  
  <cfoutput>
 	 <cfif url.mode eq "Menu">
		  <tr><td colspan="3" height="1" class="line"></td></tr>  
		  <tr><td colspan="3" height="30" align="center">
		    <a href="../../Organization/Access/UserAccessListing.cfm?ID=#URL.ID#"><cf_tl id="Authorization Profile"></a></td></tr>
		  <tr><td colspan="3" height="1" class="line"></td></tr>  
	  </cfif> 
  </cfoutput>
    
</table>


