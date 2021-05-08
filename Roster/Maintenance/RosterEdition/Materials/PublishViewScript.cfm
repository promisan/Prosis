
<cfoutput>

<cfajaximport tags="cfprogressbar">

<!--- --------------------- --->
<!--- load scripts for ajax --->
<!--- --------------------- --->

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

function getUnitAddress(id,edition) {
	
	ProsisUI.createWindow('UnitWindow', 'Edit unit address', '',{x:100,y:100,height:850,width:1050,modal:true,center:true});    					
	ptoken.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientViewUnit.cfm?systemfunctionid=&ID='+id+'&closeAction=parent.ColdFusion.Window.hide(\'UnitWindow\'); parent.reloadAddressDetail(\''+edition+'\');',"UnitWindow")
}

function doSend(edition) {	
	var sp = $('##_sourcepath').val();
	if (id!='' && sp!='')
		ptoken.open("#SESSION.root#/Tools/Mail/Broadcast/BroadCastEdition.cfm?submissionedition="+edition+"&readonly=yes&sourcepath="+sp,"broadcast","status=no,height=850px,width=920px,scrollbars=no,toolbar=no,resizable=no");		
}

function doPrepare(edition,actionid) {		
	_cf_loadingtexthtml="";		
	document.getElementById('Send').style.display='none';
	ColdFusion.ProgressBar.start('pBar') ;
 	ptoken.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Materials/prepareDocument.cfm?submissionedition='+edition+'&actionid='+actionid, 'setdocument');
}

</script>

<!--- --------------------- --->

</cfoutput>
	