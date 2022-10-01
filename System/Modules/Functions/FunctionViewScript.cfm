<cfoutput>
	
<script language="JavaScript">

function refreshrole(id) {
	ptoken.navigate('RecordListingRole.cfm?id='+id,'role'+id) 
}

function refreshstatus(id) {
	ptoken.navigate('RecordListingStatus.cfm?id='+id,'status'+id)  
}

function addportal(mod,mn,cls,fnd) {       
    ptoken.open("#SESSION.root#/system/Modules/PortalBuilder/RecordEdit.cfm?systemmodule="+mod+"&functionclass=" + cls, "addportal");		
}

function addmanual(mod,mn,cls,fnd) {
    ptoken.open("FunctionManuals/ManualAdd.cfm?systemmodule="+mod+"&functionclass=" + cls, "addmanual");		
}

function add(mod,mn,cls,fnd) {
	ptoken.open("#SESSION.root#/system/Modules/InquiryBuilder/InquiryEdit.cfm?systemmodule="+mod+"&functionclass=" + cls, "inquiry");	
}

// function maintaintopics(mod,mn,cls,fnd) {
//	window.showModalDialog("TopicListing.cfm?systemmodule="+mod+"&functionclass=" + cls + "&ts="+new Date().getTime(), window, "unadorned:yes; edge:raised; status:no; dialogHeight:525px; dialogWidth:800px; help:no; scroll:no; center:yes; resizable:no");	
//	more(mod,mn,cls,fnd)
//}

function more(mod,mn,cls,fnd) {   
    ptoken.navigate('RecordListingDetail.cfm?module='+mod+'&main='+mn+'&functionclass='+cls+'&find=' + fnd,'right')
}

function editfunction(mod) {    
    ptoken.navigate('FunctionEdit.cfm?module='+mod,'right')
}

function help(mod,cls) {    
    ptoken.navigate('../HelpBuilder/RecordListing.cfm?module='+mod+'&class='+cls,'right')
}

function helpedit(mod,cde,cls,id) {
    w = #CLIENT.width# - 200;
    h = #CLIENT.height# - 120;    
    ptoken.open("../helpBuilder/RecordEdit.cfm?module="+mod+"&code="+cde+"&class="+cls+"&id="+id,id)   
}
    
function functionedit(id1,scope) {
	w = #CLIENT.width# - 200;
	h = #CLIENT.height# - 120;    
    ptoken.open("RecordEdit.cfm?ID=" + id1 + "&scope=" + scope, "_blank")
}
	
function functionrefresh(id1) {
	_cf_loadingtexthtml='';	
	refreshrole(id1)
	refreshstatus(id1)
}	
    
function portaledit(id1,module,functionClass) {
	ptoken.open("../PortalBuilder/RecordEdit.cfm?ID=" + id1 + "&systemmodule=" + module + "&functionClass=" + functionClass, "portal");
	// more('selfservice',1,'selfservice','')	
}

function showrole(role) {
	w = #CLIENT.width# - 200;
	h = #CLIENT.height# - 250;
	ptoken.open("#SESSION.root#/System/Access/Global/OrganizationRolesView.cfm?Class=" + role, "_blank", "left=40, top=40, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=no")
}  
  
function clearno() { document.getElementById("find").value = "" }

function search() {

	se = document.getElementById("find")
    if (window.event.keyCode == "13")
		{	document.getElementById("locate").click() }
				
    }	
	
</script>

</cfoutput>

