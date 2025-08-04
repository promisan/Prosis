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

<cfparam name="url.content" default="roles">

<cfquery name="User" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
	    FROM UserNames
	    WHERE Account = '#URL.ID#'
</cfquery>

<cf_screenTop line="No" height="100%" label="#User.FirstName# #User.LastName#"
	systemmodule  = "System"
	functionclass = "Window"
	functionName  = "UserDialog"
	html          = "yes" 
	scroll        = "yes" 
	layout        = "webapp" 
	banner        = "gray" 
	bannerforce   = "Yes"
	menuaccess    = "context" 
	jquery        = "Yes">
	
<cfajaximport tags="cfdiv,cfchart,cfform">

<cfoutput>

	<script>
	
	    function broadcast(grp) {	     
		  ptoken.open("#SESSION.root#/Tools/Mail/Broadcast/BroadCastUsergroup.cfm?group="+grp, "broadcast", "status=yes, height=850px, width=920px, center=yes, scrollbars=no, toolbar=no, resizable=no");
		}
		
		function syncgroup(grp,row) {
	  		Prosis.busy('yes')			
		    document.getElementById("sync"+grp).disabled = true 	
			ptoken.navigate('#session.root#/system/access/Membership/MemberSynchronize.cfm?reload=0&role=' + grp ,'a'+grp)
			document.getElementById("sync"+grp).disabled = false			
      	}  	
		
		function formvalidate(id) {
			document.userfunction.onsubmit() 
			if( _CF_error_messages.length == 0 ) {     
			   
			    Prosis.busy('yes')  
				ptoken.navigate('#session.root#/system/access/entity/UserFunctionSubmit.cfm?id='+id,'process','','','POST','userfunction')
			 }   
		}	 
	
		function showusergroup(chk,id,row,acc) {
		
			if (chk == false) {			  			 
			   document.getElementById('detail'+row).innerHTML = ""
			  
			} else {			  
  			   _cf_loadingtexthtml='';	
			   ptoken.navigate('#session.root#/system/access/entity/getAccountGroup.cfm?profileid='+id+'&useraccount='+acc,'detail'+row)
			}		
					
		}	
		
		function clearMessage(){
			ptoken.navigate('UserPortalSubmit.cfm?id=&value=&account=','divUserPortalSubmit');
		}
		
		function submitChange(account, id, value){
			ptoken.navigate('UserPortalSubmit.cfm?id='+id+'&value='+value+'&account='+account,'divUserPortalSubmit');
			setTimeout("clearMessage()", 3000);
		}
		
		function submitInitUserPortal(account, id, value){
			ptoken.navigate('UserPortalSubmit.cfm?id='+id+'&value='+value+'&account='+account,'tdInitUserPortalSubmit');
		}
		
		function purgemember(grp,acc,row) {
			if (confirm("Do you want to remove this member ?")) {	
				Prosis.busy('yes')				
				_cf_loadingtexthtml = '';				
				ptoken.navigate('../Membership/MemberPurge.cfm?row='+row+'&mode=user&id1='+grp+'&acc=' + acc,'contentbox')		
				_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";	
			}
	     }	
		
	</script>

</cfoutput>

<cf_menuScript>
<cf_layoutScript>
<cf_dialogStaffing>
<cf_pictureProfileStyle>

<table width="100%" height="100%" class="hide">
	<!--- Used to initialize access for portal users --->	
	<tr><td id="tdInitUserPortalSubmit" ></td></tr>
</table>

<cf_layout type="border" id="layoutUserDetail">

	<cf_layoutArea position="left" id="left" size="200" maxsize="250" minsize="200" collapsible="true">
		<table width="100%" height="100%" cellspacing="0" cellpadding="0">
			<tr>
				<td style="padding-left:3px; padding-right:3px;">
					<cf_divscroll>
						<cfinclude template="UserDetailMenu.cfm">
					</cf_divscroll>
				</td>
			</tr>
		</table>
	</cf_layoutArea>
	
	<cf_layoutArea position="center" id="center">
	
		<table width="100%" height="100%" align="center">
											
			<tr><td height="1" id="userheader">
				<cfinclude template="../../Access/User/UserDetailIdentification.cfm">						
			</td></tr>
						
			<cf_menuScript>
						
			<!--- from screen that tracks usage of the system --->
					
			<tr>
				<td height="75%" valign="top" width="100%" style="padding-left:5px;padding-right:5px">		
								    					
						<cfif url.content eq "Audit">	
						
							<cf_divscroll id="contentbox" style="height:99%;width:100%">									
							<!--- from screen that tracks usage of the system --->
							<cfinclude template="Audit/UserAuditView.cfm">				
							</cf_divscroll>
								
						<cfelse>		
							<cf_divscroll id="contentbox" style="height:99%;width:100%">		
							<cfinclude template="../../Organization/Access/UserAccessListing.cfm">															
							</cf_divscroll>
						</cfif>					
					
				</td>
			</tr>
							
		</table>				
	</cf_layoutArea>
	
</cf_layout>

<cf_screenbottom layout="webapp">

