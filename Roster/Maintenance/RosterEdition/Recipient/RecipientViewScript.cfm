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

<cfoutput>

<!--- --------------------- --->
<!--- load scripts for ajax --->
<!--- --------------------- --->

<cfajaximport tags="cfprogressbar">

<cf_dialogOrganization>

<script language="JavaScript">

function recipient(op,id,org) {    
 	ptoken.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientViewDetailSet.cfm?op='+op+'&id='+id+'&org='+org, 'recipientprocess');
}

function recipientremoveall(id) {
	$(':checkbox:visible:checked').each(function() {
		var id = $(this).attr('id');
		$(this).attr('checked',false); }
	);			
 	ptoken.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientViewDetailSet.cfm?op=removeall&id='+id, 'recipients');		
	// set selected 
	$('##lrecipients').html('<b>Recipients (0)</b>');
}

function recipientselectall(id) {
	$(':checkbox:visible').each(function() {
		var id = $(this).attr('id');
		$(this).attr('checked',true); }
	);			
 	ptoken.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientViewDetailSet.cfm?op=selectall&id='+id, 'recipients');	
}

function recipienttype(op,id,at) {
	_cf_loadingtexthtml="";		
 	ptoken.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientAddressTypeSet.cfm?op='+op+'&id='+id+'&at='+at, 'types');
	_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";	
}

function reloadAddressDetail(edition){
	ptoken.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientViewDetail.cfm?submissionedition='+edition, 'recipients');
}

function getUnitAddress(id, edition){
	ptoken.open('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientViewUnit.cfm?systemfunctionid=&ID='+id+'&closeAction=parent.ColdFusion.Window.hide(\'UnitWindow\'); parent.reloadAddressDetail(\''+edition+'\');',"UnitWindow", "status=yes, height=850px, width=920px, scrollbars=no, toolbar=no, resizable=no")
}

function doSend(edition,actionid) {	
	var sp = $('##_sourcepath').val();
	if (sp!=''){
		_cf_loadingtexthtml="";
		document.getElementById('Send').style.display='none';
		ColdFusion.ProgressBar.start('pBar');
		ptoken.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/prepareBroadcast.cfm?submissionedition='+edition+'&actionid='+actionid+'&readonly=yes&sourcepath='+sp,'preparation')
	}
}

function broadcast(edition,mode) {
     ptoken.open("#SESSION.root#/Tools/Mail/Broadcast/BroadCastEdition.cfm?mode="+mode+"&submissionedition="+edition, "broadcast", "status=yes, height=850px, width=920px, scrollbars=no, toolbar=no, resizable=no");
}

</script>

			
			
<!--- --------------------- --->

</cfoutput>
	