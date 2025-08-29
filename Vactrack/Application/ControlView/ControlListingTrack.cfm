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
<cfparam name="URL.Mission"           default="">
<cfparam name="URL.HierarchyRootUnit" default="">
<cfparam name="URL.Actor"             default="">
<cfparam name="URL.HierarchyCode"     default="">
<cfparam name="URL.OrgUnitName"       default="">
<cfparam name="URL.Status"            default="0">
<cfparam name="URL.Parent"            default="All">
<cfparam name="URL.Mode"              default="Control">
<cfparam name="URL.Entity"            default="">

<cfparam name="URL.Status" default="0">

<!--- correction Dev 24/10 as sometimes the widget has abother ' --->
<cfif findNoCase("portal",url.mode)>
	<cfset url.mode = "portal">
</cfif>	

<cfif url.mode eq "Control">
	
		<cf_screentop html="No" jQuery="Yes">
	
		<!--- load script stuff --->
	
		<cfajaximport tags="cfform,cfdiv">
		<cf_dialogPosition>
		<cf_calendarscript>
		<cfinclude template="../Document/Dialog.cfm">
		<cf_listingscript>
		
		<cfoutput>
						
		<script language="JavaScript">
		
		 Prosis.busy('yes')
		
		 function printme() {
		    w = 990;
		    h = #CLIENT.height# - 180;
			ptoken.open('ControlListingTrack.cfm?#cgi.query_string#&mode=print', '_blank', 'left=30, top=30, width=' + w + ', height= ' + h + ', menu=no,toolbar=no,status=no, scrollbars=no, resizable=yes'); 
		 }
		
		 function show_box_search() {
			element = document.getElementById('img_search');
			element_row = document.getElementById('dBox');
			if (element_row.className == 'hide') {
				element_row.className = 'normal';
				element.src = '#SESSION.root#/images/arrow-up.gif';
			} else	{
				element_row.className = 'hide';
				element.src = '#SESSION.root#/images/arrow-down.gif';
			}
		
		 }
		 
		 function do_restrict (e) {
		    Prosis.busy('yes')
			_cf_loadingtexthtml='';	
			ptoken.navigate('ControlListingTrackCriteria.cfm?Entity=#URL.Entity#&Mission=#URL.Mission#&HierarchyRootUnit=#URL.HierarchyRootUnit#&HierarchyCode=#URL.HierarchyCode#&Mode=#URL.Mode#&Status=#URL.Status#&Parent=#URL.Parent#&EntityCode='+e,'dCriteria'); 
		 }
		 
		 function do_search () {
		 	document.fCriteria.onsubmit();
			if( _CF_error_messages.length == 0 ) {
			    _cf_loadingtexthtml='';	
				Prosis.busy('yes')	
				ptoken.navigate('ControlListingTrackResult.cfm?systemfunctionid=#url.systemfunctionid#&Criteria=Yes&Entity=#URL.Entity#&Mission=#URL.Mission#&HierarchyRootUnit=#URL.HierarchyRootUnit#&HierarchyCode=#URL.HierarchyCode#&Mode=#URL.Mode#&Status=#URL.Status#&Parent=#URL.Parent#&actor=#url.actor#','dDetails','','','POST','fCriteria');
			}	
		 
		 }
		 
		 function doResult() {		   
		    ptoken.navigate('#session.root#/vactrack/application/ControlView/ControlListingTrackView.cfm','tracklistingcontent')		 
		 }
				
	    function tracklisting(sid,mde,con,fil) {			      
		    ptoken.navigate('#session.root#/Vactrack/Application/ControlView/ControlListingTrackContent.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&mode='+mde+'&condition='+con+'&filter='+fil,'tracklistingcontent') 			 
		}
		
		function details(id) {
	      ptoken.open("#SESSION.root#/Roster/RosterSpecial/CandidateView/FunctionViewLoop.cfm?IDFunction=" + id + "&status=1", id);
    	}
		
		</script>
	
	</cfoutput>
	
</cfif>

<cfif url.mode neq "Portal" and url.mode neq "Print">
	<div class="screen">
<cfelseif url.mode eq "Print">
  <cf_screentop html="No" jQuery="Yes" scroll="Yes">
  <title>Recruitment Tracks printable version</title>  	
</cfif>

<cfparam name="CLIENT.FileNo" default="">

<cfif CLIENT.FileNo eq "">
	<cfset CLIENT.FileNo = round(rand()*1020) >
</cfif>
	
<!--- we can move this portion up into the topic --->
	
<cfoutput>

<cfif url.mode eq "Portal">

	 <table height="100%" width="100%" align="center">
	  
		 <tr>
			<td colspan="2" valign="top" id="dDetails" style="height:100%">				
			<cfinclude template="ControlListingTrackResult.cfm">				
			</td>
		 </tr>
		 
		 <tr>
			<td colspan="2" valign="top" style="height:100%" id="tracklistingcontent">	
			 <cfinclude template="ControlListingResultStep.cfm"> 
			<td>
		 </tr>
		
	 </table>

<cfelse>

	<cf_layoutscript>	
	
	<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	
		
	<cf_layout attributeCollection="#attrib#">	
	
	    <cf_layoutarea  position="header" name="box11" collapsible = "false">
		
		   <table height="100%" width="100%" align="center">
				
			<tr>		
			    <td style="height:10px">		
				    <table width="100%">
					
						<tr>
					    <td align="left" class="labellarge" style="padding-left:20px;height:40px;font-size:34px;padding-top:4px">
									
							<cfif url.mode neq "Print">
								<a href="javascript:show_box_search()">#URL.Mission# <img id="img_search" src="#SESSION.root#/images/arrow-down.gif" alt="" border="0" align="top"></a>													
							<cfelse>
								#URL.Mission#
							</cfif>			
								
						<td align="right" class="fixlength" style="padding-left:20px;height:30px;font-size:26px;padding-top:4px">#url.orgunitname#</td>																		    				
						</tr>						
										
					</table>			
			    </td>			
			</tr>	
			
			<tr id="dBox" class="hide">		
				<td width="100%" colspan="3" id="dCriteria">	 
                    <cfinclude template="ControlListingTrackGet.cfm">
					<cfinclude template="ControlListingTrackCriteria.cfm">
				</td>			
			</tr>	
			
			</table>
		
		</cf_layoutarea>
			
		<cf_layoutarea  position="top" name="box" collapsible = "true">
		
		    <table height="100%" width="100%" align="center">			
			<tr>
				<td colspan="3" valign="top" id="dDetails" style="height:100%">									
				   <cfinclude template = "ControlListingTrackResult.cfm">					
				</td>
			</tr>
					
			</table>					
				
		</cf_layoutarea>
		
		<cf_layoutarea  position="center" name="centerbox">		
		    
			  <cfif url.parent eq "All" and url.status eq "0">
		      <table height="100%" width="100%">					  
				<tr>
					<td colspan="2" valign="top" id="tracklistingcontent" style="padding-top:4px;height:100%">					
						<cfoutput>#session.trackcontent#</cfoutput>					
					</td>
				</tr>				
			  </table>	
			  <cfelse>
			  <table height="100%" width="100%"><td><td style="padding-left:10px;padding-right:10px">
			  <table height="100%" width="100%" class="formpadding formspacing">					  
				<tr>
					<td colspan="2" valign="top" id="tracklistingcontent" style="padding:6px;border:1px solid silver;background-color:f1f1f1;height:100%"></td>
				</tr>				
			  </table>		
			  </td></td></table>	  
			  </cfif>		       			
		
		</cf_layoutarea>			
			
	</cf_layout>	
	

</cfif>

</cfoutput>
