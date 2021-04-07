
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
		
		function formvalidate(id) {
			document.userfunction.onsubmit() 
			if( _CF_error_messages.length == 0 ) {       
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
		
	</script>

</cfoutput>

<cf_menuScript>
<cf_layoutScript>
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

