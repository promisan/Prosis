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
<cf_tl id="Publication Groups" var="vTitle">
<cf_tl id="Here you can define your publication details" var="vOption">
<cfif len(url.drillid) lte 1>
	<cfset url.drillid = "00000000-0000-0000-0000-000000000000">
</cfif>

<cf_screentop height = "100%" 
              scroll = "Yes" 
			  layout = "webapp" 
			  label  = "#vTitle#" 
			  option = "#vOption#"
			  banner = "blue"
			  jQuery = "yes">			  
			  
<cfquery name="getPublication" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	Publication
		WHERE	PublicationId = '#url.drillId#'
</cfquery>

<cfquery name="getPublicationClusters" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	PublicationCluster
		WHERE	PublicationId = '#url.drillId#'
		ORDER BY ListingOrder ASC
</cfquery>
			
<cf_tl id="Do you want to remove this section and all of its details ?"     var="vConfirmClusterDelete">
<cf_tl id="Do you want to remove this publication and all of its details ?" var="vConfirmPublicationDelete">

<cfajaximport tags="cfform,cfmenu,cfdiv,cfwindow">
<cf_ActionListingScript>
<cf_FileLibraryScript>
<cf_layoutScript>
<cf_calendarScript>

<cfoutput>
	<script>
	
		function validateCluster(id,ret){
			var vClusterVal = $('input:radio[name=cluster]:checked').val();
				
			if (vClusterVal != '') { 
				$('##btnRemove').show(); 
				$('##btnEdit').show(); 
			}else {
				$('##btnRemove').hide(); 
				$('##btnEdit').hide(); 
			}

			ColdFusion.navigate('Cluster/ClusterList.cfm?publicationId='+id+'&autoselect='+ret,'divClusterList');
			selectCluster(id, ret);
		}
		function editCluster(id,code) {
			try { ColdFusion.Window.destroy('mydialog'); } catch(er){ }
			ColdFusion.Window.create('mydialog', 'Publication', '',{x:30,y:30,height:250,width:500,modal:true,center:true});    
			ColdFusion.Window.show('mydialog'); 				
			ColdFusion.navigate('Cluster/ClusterEdit.cfm?publicationId='+id+'&code='+code+'&ts='+new Date().getTime(),'mydialog');
		}
		
		function selectCluster(pubid,code,property,unsel,sel) {
			$('.clsClusterLabel').css(property,unsel);
			$('##clusterLabel_'+code).css(property,sel);
			ColdFusion.navigate('Cluster/ClusterView.cfm?publicationId='+pubid+'&code='+code,'divClusterDetail'); 
		}
		
		function removeCluster(id,code) {
			if (confirm('#vConfirmClusterDelete#')) {
				ColdFusion.navigate('Cluster/ClusterPurge.cfm?publicationId='+id+'&code='+code,'targetSubmitCluster');
			}
		}
		
		function editPublication(id) {
			try { ColdFusion.Window.destroy('mydialog'); } catch(er){ }
			ColdFusion.Window.create('mydialog', 'Publication', '',{x:30,y:30,height:400,width:500,modal:true,center:true});    
			ColdFusion.Window.show('mydialog'); 				
			ColdFusion.navigate('PublicationEdit.cfm?publicationId='+id+'&workOrderId=#getPublication.workOrderId#&ts='+new Date().getTime(),'mydialog');
		}
		
		function removePublication(id) {
			if (confirm('#vConfirmPublicationDelete#')) {
				ColdFusion.navigate('PublicationPurge.cfm?publicationId='+id+'&systemfunctionid=#url.systemfunctionid#&workorderid=#getPublication.workorderid#','targetSubmitPublication');
			}
		}
		
		function sendPublicationToZip(id) {
			ptoken.open('#session.root#/workorder/application/activity/publication/zipPublication.cfm?id='+id, '_blank', 'toolbar=no, scrollbars=no, resizable=no, top=500, left=500, width=10, height=10');
		}
		
		function submitPublishForm(wo,pub) {
			document.frmPublish.onsubmit() 
			if( _CF_error_messages.length == 0 ) {
				ColdFusion.navigate('#session.root#/workOrder/Application/Activity/Publication/PublicationSubmit.cfm?workOrderId='+wo+'&publicationId='+pub+'&systemfunctionid=#url.systemfunctionid#','processPublication','','','POST','frmPublish');
			}   
		}
		
		function submitClusterForm(pub,code) {
			document.frmCluster.onsubmit(); 
			if( _CF_error_messages.length == 0 ) {
				ColdFusion.navigate('#session.root#/workOrder/Application/Activity/Publication/Cluster/ClusterSubmit.cfm?publicationId='+pub+'&code='+code,'processCluster','','','POST','frmCluster');
			}   
		}
		
	</script>
</cfoutput> 

<cfset vActionImagesStyle = "cursor:pointer; height:24px;">

<table width="99%" height="100%" align="center">
	<tr>
		<td valign="top">
			<table width="100%" height="100%" align="center">
				<cfoutput>
				<tr><td height="5"></td></tr>
				<tr>
				    <!---
					<td width="8%" class="labelmedium" style="padding-left:7px"><cf_tl id="Publication">:</td>
					--->
					<td class="labelmedium">
						<table>
							<tr>
								<td>
									<cfdiv id="divPublicationInfo" bind="url:getPublicationInfo.cfm?publicationId=#url.drillId#">
								</td>
								<cfif getPublication.ActionStatus neq "3">
									<td style="padding-left:5px;">
										<cf_tl id="Edit Publication" var="1">
										<img src="#session.root#/Images/edit_blueSquare.png" id="btnEditPublication" style="#vActionImagesStyle#" title="#lt_text#" onclick="editPublication('#url.drillId#');">
									</td>
									<td style="padding-left:2px;">
										<cf_tl id="Remove Publication" var="1">
										<img src="#session.root#/Images/delete_blueSquare.png" id="btnRemovePublication" style="#vActionImagesStyle#" title="#lt_text#" onclick="removePublication('#url.drillId#');">
									</td>
									<td style="padding-left:5px;" id="targetSubmitPublication"></td>
								</cfif>
							</tr>
						</table>
					</td>
					<cfif url.drillid neq "">
					<td align="right" style="padding-right:15px;">
						<cf_tl id="Download in a zip file" var="1">
						<img src="#session.root#/images/zip_gray.png" title="#lt_text#" style="height:30px; cursor:pointer;" onclick="sendPublicationToZip('#url.drillId#');">
					</td>
					</cfif>
				</tr>				

				<tr>				
				
				<td colspan="2" width="80%" style="border:0px solid silver;border-radius:1px;padding-left:6px;padding-bottom:3px;padding-right:6px">
				
					<cfset wflnk = "PublicationWorkflow.cfm">
	   
				    <input type="hidden" 
				          id="workflowlink_#url.drillId#" 
			          value="#wflnk#"> 
	 
				    <cfdiv id="#url.drillId#"  bind="url:#wflnk#?ajaxid=#url.drillId#"/>			
				
				</td>
				</tr>
				</cfoutput>
				
				<tr>
				    <!---
					<td class="labelmedium" style="padding-left:7px"><cf_tl id="Sections">:</td>
					--->
					<td style="padding-left:10px">
						<table>
							<tr>
								<td>
									<cfoutput>
										<table>
											<tr>
												<td>
													<cfdiv id="divClusterList" bind="url:Cluster/ClusterList.cfm?publicationId=#url.drillId#&autoselect=">
												</td>
												<cfif getPublication.ActionStatus neq "3">
													<td>
														<cf_tl id="Add Section" var="1">
														<img src="#session.root#/Images/add_blueSquare.png" style="#vActionImagesStyle#" title="#lt_text#" onclick="editCluster('#url.drillId#','');">
													</td>
													<cfset vDisplayActionsCluster = "">
													<cfif getPublicationClusters.recordCount eq 0>
														<cfset vDisplayActionsCluster = "display:none;">
													</cfif>
													<td style="padding-left:3px;">
														<cf_tl id="Edit Section" var="1">
														<img src="#session.root#/Images/edit_blueSquare.png" id="btnEdit" style="#vActionImagesStyle# #vDisplayActionsCluster#" title="#lt_text#" onclick="editCluster('#url.drillId#',$('input:radio[name=cluster]:checked').val());">
													</td>
													<td style="padding-left:3px;">	
														<cf_tl id="Remove Section" var="1">
														<img src="#session.root#/Images/delete_blueSquare.png" id="btnRemove" style="#vActionImagesStyle# #vDisplayActionsCluster#" title="#lt_text#" onclick="removeCluster('#url.drillId#',$('input:radio[name=cluster]:checked').val());">
													</td>
													<td style="padding-left:5px;" id="targetSubmitCluster"></td>
												</cfif>
											</tr>
										</table>
									</cfoutput>
								</td>
							</tr>							
						</table>
						
					</td>
				</tr>
				<tr><td height="5"></td></tr>
				<tr><td colspan="3" class="line"></td></tr>
				<tr><td height="5"></td></tr>
				<tr>
					<td colspan="3" height="99%">
						<cfdiv style="height:100%;" id="divClusterDetail" bind="url:Cluster/ClusterView.cfm?publicationId=#url.drillId#&code=#getPublicationClusters.code#">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>