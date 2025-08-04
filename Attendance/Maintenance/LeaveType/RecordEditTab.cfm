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

<cfajaximport tags="cfform,cfdiv">

<cf_menuscript>

<cfoutput>

	<script>
	
		function addClass() {
		   ColdFusion.navigate('LeaveTypeClass/RecordListingDetail.cfm?id1=#url.id1#&code=new','listing')
		}
		
		function saveClass(code) {
		
		   document.mysection.onsubmit() 
			if( _CF_error_messages.length == 0 ) {
		       	ColdFusion.navigate('LeaveTypeClass/RecordListingSubmit.cfm?id1=#url.id1#&code='+code,'listing','','','POST','mysection')
			 }  
			 
		 } 
		 
		 function hlMission(mis,cl) {
			var control = document.getElementById('mission_'+mis);
			if (control.checked) {
				document.getElementById('td_'+mis).style.backgroundColor = cl;
			}else{
				document.getElementById('td_'+mis).style.backgroundColor = '';
			}
		}
	 
	</script> 

</cfoutput>

<cfparam name="url.idmenu" default="">

<cf_screentop layout="webapp" 
			  height="100%" 
			  label="Edit Leave type" 
			  scroll="no" 
			  banner="blue"
			  jquery="Yes"
			  bannerforce="Yes"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<cfoutput>
<tr><td height="34" style="padding:0px">

		<!--- top menu --->
				
		<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">		  		
									
			<cfset ht = "54">
			<cfset wd = "54">			
			
			<tr>		
						
					<cfset itm = 0>
					
					<cfset itm = itm+1>													
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Workorder/General.png" 
								targetitem = "1"
								padding    = "3"
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								name       = "Leave Type"
								class      = "highlight1"
								source 	   = "RecordEdit.cfm?idmenu=#url.idmenu#&id1=#url.id1#">													
					
					<cfset itm = itm+1>											
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Workorder/Request.png" 
								targetitem = "2"
								padding    = "3"
								iconwidth  = "#wd#" 								
								iconheight = "#ht#" 
								name       = "Class"
								source 	   = "LeaveTypeClass/RecordListing.cfm?id1=#url.id1#">
								
					<cfset itm = itm+1>											
					<cf_menutab item       = "#itm#" 
					            iconsrc    = "Logos/Casefile/NextOfKin.png" 
								targetitem = "2"
								padding    = "3"
								iconwidth  = "#wd#" 								
								iconheight = "#ht#" 
								name       = "Entities"
								source 	   = "LeaveTypeMission/RecordMission.cfm?code=#url.id1#">
						
													 		
				</tr>
		</table>

	</td>
 </tr>
 </cfoutput>
 

<tr><td height="99%">
	
	<table width="100%" 
	      border="0"
		  height="100%"
		  cellspacing="0" 
		  cellpadding="0">
			
			<cf_menucontainer item="1" class="regular">
				<cfinclude template="RecordEdit.cfm">
			</cf_menucontainer>							
			
			<cf_menucontainer item="2" class="hide"/>					
														
	</table>

</td></tr>

</table>

