<cf_ajaxRequest>

<cfoutput>

<script language="JavaScript">

function usage(id) {
		w = #CLIENT.width# - 40;
	    h = #CLIENT.height# - 70;
        ptoken.open("Distribution.cfm?Controlid=" + id, "Usage");
}

function toggleP(bx) {
     
	se = document.getElementById("criteria")
	se.className = "hide"
	
	se = document.getElementById(bx)
	if (se) { 
	
	se.className = "";
	se.className = "regular";
	
	}	
}

function check() {
var screen = "";
count = 1;
pass = document.getElementById("pass")
pass.value = ""
while (count<5) {
	se = document.getElementById(count)
	if (se) {
		if (se.className == "regular") {
		pass.value = pass.value+count
		}
	}
	count++
}	
}

function secsave(fld,val) {
    ptoken.navigate('RecordEditFieldsSecuritySave.cfm?id=#url.id#&field='+fld+'&value='+val,'securitysave')
}	

function about(id) {
    w = #CLIENT.width# - 100;
    h = #CLIENT.height# - 110;
	ptoken.open("RecordEditMemo.cfm?id=#URL.ID#","memo","left=15, top=15, width=" + w + ", height= " + h + ", toolbar=no, status=no, scrollbars=yes, resizable=yes");
}

function schedule(id,ui) {
    w = #CLIENT.width# - 50;
    h = #CLIENT.height# - 30;
	ptoken.open("#SESSION.root#/tools/cfreport/SubmenuReportView.cfm?source=library&id=" + id + "&option=none&interface="+ui, id);
}

function purge() {
	if (confirm("Do you want to remove this report and all its subscriptions completely ?")) {
	return true 
	}
	return false	
}	
	
function outputpurge(rl) {
	if (confirm("Do you want to remove this report layout from this report ?"))	{
	    ptoken.navigate('../ReportOutput/LayoutPurge.cfm?Status=#op#&ID=#URL.ID#&ID1='+rl,'contentbox6')	
	}	    
}
		
function outputedit(val) {	
	ProsisUI.createWindow('mydialog', 'Edit', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,center:true})    			
	ptoken.navigate('../ReportOutput/LayoutView.cfm?Status=#op#&ID=#URL.ID#&ID1='+val,'mydialog') 		
} 
								
function extractadd() {		        	
	ProsisUI.createWindow('myexcel', 'Extract', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,resizable:false,center:true})    			
	ptoken.navigate('../ReportOutput/ExcelView.cfm?Mode=new&ID=#URL.ID#&ID1=','myexcel') 		
} 
			
function extractedit(id1) {    
	ProsisUI.createWindow('myexcel', 'Extract', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,resizable:false,center:true})    			
	ptoken.navigate('../ReportOutput/ExcelView.cfm?Mode=edit&ID=#URL.ID#&ID1=' + id1,'myexcel') 				
} 	
	
function outputrefresh() {		      
    _cf_loadingtexthtml='';			
  	ptoken.navigate('RecordEditFieldsLayout.cfm?id=#URL.ID#&status=#op#','contentbox6')	
}		

function showsql(opt) {
	 se = document.getElementById("sql0")
	 if (opt == "External" || opt == "") { 
	   se.className = "hide"
	 } else {
	  se.className = "regular"
	 }
} 

function sql(id) { 
    ptoken.open("SQLOpen.cfm?id="+id, "_blank", "status=yes, toolbar=no, menubar=yes, scrollbars=yes, resizable=yes") 
}

function syncreport(id) {

	if (confirm("Do you want to synchronize this report with the local production sites ?")) {		
		url = "ReportSync.cfm?controlid="+id
		ptoken.navigate(url,'sync')	 	
	}
}

</script>

</cfoutput>