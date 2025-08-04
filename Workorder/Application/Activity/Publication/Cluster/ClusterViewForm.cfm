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
<cf_screentop height="100%" scroll="Yes" html="no" JQuery="yes">

<cf_layoutScript>

<cf_tl id="You will lose all your selected pictures. Do you want to continue ?" var="vMsgSelectAllConfirm">

<script>

	_cf_loadingtexthtml='';
	
	function selectOrgUnit(pub,code,orgunit){
		ColdFusion.navigate('../WorkAction/ActionsView.cfm?publicationId='+pub+'&code='+code+'&orgUnit='+orgunit,'actionsContainer');
		$('#selectedOrgUnit').val(orgunit);
		$('.clsOrgUnit').css('background-color','').css('border-style','none');
		$('#orgUnit_'+orgunit).css('background-color','#FAD88F').css('border','1px dotted #C0C0C0');
		collapseArea('clusterLayout','right'); 
	}
	
	function viewPictures(pub,aid,pubId,cluster,orgunit) {
		ColdFusion.navigate('../Picture/PictureView.cfm?PublicationElementId='+pub+'&workActionId='+aid+'&publicationId='+pubId+'&cluster='+cluster+'&orgUnit='+orgunit,'picturesContainer');
		collapseArea('clusterLayout','left'); 
		expandArea('clusterLayout','right');
		
		//focus on row
		var vId = aid.replace(/-/gi, '');
		$('.clsActionDetail td').css('font-weight','normal');
		$('.clsActionDetail td').css('font-size','100%');
		$('.clsActionbox_'+vId+' td').css('font-weight','bold');
		$('.clsActionbox_'+vId+' td').css('font-size','110%');
	}	
	
	function selectAction(cAction,hlClass,pub,pubelement,cluster,orgunit,grp) {
		var vWOAction = cAction.value;
		var vId = vWOAction.replace(/-/gi, '');
		
		if (!!cAction.checked) {		   
			$('.clsActionbox_'+vId).addClass(hlClass);
		}else{
			$('.clsActionbox_'+vId).removeClass(hlClass);
		}
		
		ColdFusion.navigate('../WorkAction/setAction.cfm?action='+cAction.checked+'&publicationid='+pub+'&publicationElementId='+pubelement+'&workActionId='+vWOAction+'&cluster='+cluster+'&orgunit='+orgunit,'action_'+grp);
	}	
	
	function selectAllActions(c,hlClass,pub,pubelement,cluster,orgunit) {
		if (confirm('<cfoutput>#vMsgSelectAllConfirm#</cfoutput>')) {
			$('.clsActionDetail').css('display','');
			$('.clsActionCB').each(function(e){
				if (c.checked) {
					$(this).prop('checked', true);
				}else{
					$(this).prop('checked', false);
				}
				var grp = $('#groupAction_'+$(this).val().replace(/-/gi, '')).val();
				selectAction(this,hlClass,pub,pubelement,cluster,orgunit,grp);
			});
			viewPictures(pubelement,$('.clsActionCB').first().val(),pub,cluster,orgunit);
		}else{
			c.checked = !c.checked;
		}
	}
	
	function viewPicture(id) {
		ptoken.open('../Picture/PictureViewOpen.cfm?attachmentid='+id, '_blank', 'left=20,top=20,width=800,height=700,status=no,toolbar=no,scrollbars=no,resizable=yes');
	}
	
	function selectPicture(c,pub,aid,att,target,currentrow) {	   
		ColdFusion.navigate('<cfoutput>#session.root#</cfoutput>/WorkOrder/Application/Activity/Publication/Picture/setAttachment.cfm?publicationelementid='+pub+'&workactionid='+aid+'&attachmentId='+att+'&action='+c.checked+'&currentrow='+currentrow,target);
	}
	
	function rotatePicture(id,pubaid){
		ColdFusion.navigate('<cfoutput>#session.root#</cfoutput>/WorkOrder/Application/Activity/Publication/Picture/rotatePicture.cfm?&attachmentId='+id+'&PublicationActionId='+pubaid,'pictureContainer_'+id);
	}
	
	function toggleActionGroup(g) {
		if($('.clsActionGroup_'+g).first().is(':visible')) {
			$('.clsActionGroup_'+g).css('display','none');
			$('#twistie_'+g).attr('src','<cfoutput>#session.root#/images/arrowright.gif</cfoutput>');
		}else{
			$('.clsActionGroup_'+g).css('display','');
			$('#twistie_'+g).attr('src','<cfoutput>#session.root#/images/arrowdown3.gif</cfoutput>');
		}
	}
	
</script>

<cf_tl id="Locations" var="vLocation">
<cf_tl id="Actions"   var="vActions">
<cf_tl id="Pictures"  var="vPictures">

<cfform name="frmClusterDetail" 
		style="height:98%; min-height:98%;" 
		action="ClusterViewSubmit.cfm?publicationId=#url.publicationId#&code=#url.code#">
	
	<input type="Hidden" id="selectedOrgUnit" name="selectedOrgUnit" value="">
	
	<table height="100%" width="100%">
		<tr>
			<td height="100%">
			
				<cf_layout type="border" id="clusterLayout" style="height:99.9%; min-height:99.9%; width:100%; border-top:1px solid ##EDEDED; border-bottom:1px solid ##EDEDED; border-right:1px solid ##EDEDED;">
	
					<cf_layoutArea 
						name="left" 
						position="left" 						
						size="250" 
						collapsible="true" 
						onshow="collapseArea('clusterLayout','right');">
						
						<cf_divScroll>
							<table width="100%" height="100%">
								<tr>
									<td id="orgUnitsContainer">
										<cfinclude template="getOrgUnit.cfm">
									</td>
								</tr>
							</table>
						</cf_divScroll>
						
					</cf_layoutArea>
					
					<cf_layoutArea 
						name="center" 
						position="center" 						
						size="100%">
							<cf_divScroll>
								<table width="100%" height="100%">
									<tr>
										<td id="actionsContainer"></td>
									</tr>
								</table>
							</cf_divScroll>
					</cf_layoutArea>
					
					<cf_layoutArea 
						name="right" 
						position="right" 						
						size="450" 
						collapsible="true"
						initcollapsed="true">
						
						<cf_divScroll>
							<table width="100%" height="100%">
								<tr>
									<td id="picturesContainer" style="padding-left:10px"></td>
								</tr>
							</table>
						</cf_divScroll>
						
					</cf_layoutArea>
					
				</cf_layout>
			</td>
		</tr>
		
	</table>
</cfform>

<cfif url.preselOrgUnit neq "">
	<cfoutput>
		<script>
			selectOrgUnit('#url.publicationId#','#url.code#','#url.preselOrgUnit#');
		</script>
	</cfoutput>
</cfif>

