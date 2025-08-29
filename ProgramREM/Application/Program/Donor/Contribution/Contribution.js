/*
 * Copyright © 2025 Promisan B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
function dosave(mis,id1,id2,act){   
	ColdFusion.navigate('ContributionSubmit.cfm?mission='+mis+'&id1='+id1+'&contributionid='+id2+'&action='+act,'result','','','POST','form_contribution');
}	

function expand(cls) {	
	if ($('.'+cls).is(':visible'))	{	   
		$('.'+cls).hide()		
	} else {
		$('.'+cls).show()			
	}		
}

function expand_earmark(id) {
	if ($('#r_'+id).is(':visible'))	{
		$('#r_'+id).fadeOut();
	} else {
		$('#r_'+id).fadeIn();	
		ColdFusion.navigate('ContributionLineEarmark.cfm?lineid='+id,'r_'+id);	
	}		
}

function expand_log(id) {
	if ($('#r_'+id).is(':visible'))	{
		$('#r_'+id).fadeOut();
	} else {
		$('#r_'+id).fadeIn();	
		ColdFusion.navigate('ContributionLineLog.cfm?lineid='+id,'r_'+id);	
	}		
}

function expand_attachments(id,mode) {
	if ($('#r_'+id).is(':visible'))	{
		$('#r_'+id).fadeOut();
	} else {
		$('#r_'+id).fadeIn();	
		ColdFusion.navigate('ContributionLineAttachment.cfm?mode='+mode+'&lineid='+id,'r_'+id);	
	}		
}

function delete_contribution(id) {
	if (confirm("Are you sure to remove the contribution from the system?"))
		ptoken.navigate('ContributionDelete.cfm?contributionid='+id,'result')
}

function addrow(idmenu,id) {
	$('.clsDetails').css({'display':'none'});		
	$('.clsAdd').fadeIn();		
	ptoken.navigate('ContributionLine.cfm?systemFunctionId='+idmenu+'&contributionid='+id,'r_addrow');				
}

function setearmark(val) {   
	if (val == "0") {	
	  document.getElementById('earmarkbox').className = "hide"
	} else {
	  document.getElementById('earmarkbox').className = "regular"
	}
}

function earmarkpledge(pid,id){
	ptoken.navigate('ContributionProgramSubmit.cfm?scope='+id+'&programid='+pid,'r_'+id);						
}

function removepledgeprogram(p,id) {
	ptoken.navigate('ContributionRemoveProgramSubmit.cfm?ProgramCode='+p+'&ContributionId='+id,'pl_'+p+'_'+id);		
}

function processprogram(pid,id){
	ptoken.navigate('ContributionLineProgramSubmit.cfm?scope='+id+'&programid='+pid,'r_'+id);						
}

function processloc(location,id){
	ptoken.navigate('ContributionLineLocationSubmit.cfm?LineId='+id+'&locationcode='+location,'r_'+id);						
}

function saverow(idmenu,id){
	ptoken.navigate('ContributionLineSubmit.cfm?systemFunctionId='+idmenu+'&ContributionId='+id,'r_addrow','','','POST','form_contribution_line');		
}

function saveeditrow(idmenu,id1,id2) {
	ptoken.navigate('ContributionLineUpdateSubmit.cfm?contributionId='+id1+'&ContributionLineId='+id2,'e_'+id2,'','','POST','form_contribution_line');		
	$('.fcontribution_workflow').css({'display':'block'});				
}

function remove(id) {
	if (confirm('Are you sure you want to remove this contribution line?')){
		ptoken.navigate('ContributionLineRemoveSubmit.cfm?ContributionLineId='+id,'e_'+id);		
	}	
}



function removeprogram(p,id) {
	ptoken.navigate('ContributionLineRemoveProgramSubmit.cfm?ProgramCode='+p+'&LineId='+id,'pl_'+p+'_'+id);		
}

function removelocation(p,id) {
	ptoken.navigate('ContributionLineRemoveLocationSubmit.cfm?LocationCode='+p+'&LineId='+id,'pl_'+p+'_'+id);		
}

function editRowDialog(idmenu, cid, clid) {

	try { ColdFusion.Window.destroy('mydialog',true) } catch(e) {}
	ColdFusion.Window.create('mydialog', 'Contribution', '',{x:100,y:100,height:document.body.clientHeight-100,width:document.body.clientWidth-100,modal:true,resizable:false,center:true})    					
	ptoken.navigate('ContributionLineView.cfm?systemFunctionId='+idmenu+'&contributionId='+cid+'&contributionlineid='+clid,'mydialog') 		
}

function editRowRefresh(idmenu,cid) {
    ptoken.navigate('ContributionLines.cfm?systemFunctionId='+idmenu+'&contributionId='+cid,'dlines');
}

function contributionlineaction(id) {
	if (confirm("Do you want to issue a reporting action?")) {
		ptoken.navigate('../Allocation/RequirementListingWorkflow.cfm?ajaxid='+id,id)	
		document.getElementById('workflow_'+id).className = "hide"			
	}			
}

