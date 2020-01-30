
<cfoutput>

<!--- --------------------- --->
<!--- load scripts for ajax --->
<!--- --------------------- --->

<cfajaximport tags="cfprogressbar">

<cf_dialogOrganization>

<script type="text/javascript" src="#SESSION.root#/Scripts/jQuery/jquery.js"></script>

<script language="JavaScript">

function recipient(op,id,org) {    
 	ColdFusion.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientViewDetailSet.cfm?op='+op+'&id='+id+'&org='+org, 'recipientprocess');
}

function recipientremoveall(id) {
	$(':checkbox:visible:checked').each(function() {
		var id = $(this).attr('id');
		$(this).attr('checked',false); }
	);			
 	ColdFusion.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientViewDetailSet.cfm?op=removeall&id='+id, 'recipients');		
	// set selected 
	$('##lrecipients').html('<b>Recipients (0)</b>');
}

function recipientselectall(id) {
	$(':checkbox:visible').each(function() {
		var id = $(this).attr('id');
		$(this).attr('checked',true); }
	);			
 	ColdFusion.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientViewDetailSet.cfm?op=selectall&id='+id, 'recipients');	
}

function recipienttype(op,id,at) {
	_cf_loadingtexthtml="";		
 	ColdFusion.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientAddressTypeSet.cfm?op='+op+'&id='+id+'&at='+at, 'types');
	_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";	
}

function reloadAddressDetail(edition){
	ptoken.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientViewDetail.cfm?submissionedition='+edition, 'recipients');
}

function getUnitAddress(id, edition){
	ColdFusion.Window.create('UnitWindow', 'Edit unit address', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,center:true});    
	ColdFusion.Window.show('UnitWindow'); 					
	ptoken.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/RecipientViewUnit.cfm?systemfunctionid=&ID='+id+'&closeAction=parent.ColdFusion.Window.hide(\'UnitWindow\'); parent.reloadAddressDetail(\''+edition+'\');',"UnitWindow")
}

function doSend(edition,actionid) {	
	var sp = $('##_sourcepath').val();
	if (sp!=''){
		_cf_loadingtexthtml="";
		document.getElementById('Send').style.display='none';
		ColdFusion.ProgressBar.start('pBar');
		ColdFusion.navigate('#SESSION.root#/Roster/Maintenance/RosterEdition/Recipient/prepareBroadcast.cfm?submissionedition='+edition+'&actionid='+actionid+'&readonly=yes&sourcepath='+sp,'preparation')
	}
}

function broadcast(edition,mode) {
     window.open("#SESSION.root#/Tools/Mail/Broadcast/BroadCastEdition.cfm?mode="+mode+"&submissionedition="+edition, "broadcast", "status=yes, height=850px, width=920px, scrollbars=no, toolbar=no, resizable=no");
}

</script>

			
			
<!--- --------------------- --->

</cfoutput>
	