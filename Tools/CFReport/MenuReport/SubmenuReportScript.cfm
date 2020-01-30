
<cf_calendarscript>

<cfoutput>

<script language="JavaScript">

ie = document.all?1:0
ns4 = document.layers?1:0


function reportedit(id1) {
     ptoken.open("#SESSION.root#/System/Modules/Reports/RecordEdit.cfm?ID=" + id1, "Edit"+id1);
}

function hl(itm,fld,name){
		 
     if (ie){
          while (itm.tagName!="TABLE")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TABLE")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 itm.className = "rpthighLight";
	 itm.style.cursor = "pointer";
	 self.status = name;
	 }else{
		
     itm.className = "rptnormal";		
	 itm.style.cursor = "";
	 self.status = name;
	 }
  }
  
function load(id,cls,ctx,scope) {

    if (cls == "System") {
	
	 //ret = window.showModalDialog("#SESSION.root#/Tools/CFReport/SubmenuReportView.cfm?ts="+new Date().getTime()+"&Context=report&controlid=" + id+"&portal="+scope, window, "unadorned:yes; edge:raised; status:yes; dialogHeight:700px; dialogWidth:800px; help:no; scroll:no; center:yes; resizable:no");
	 //history.go()
	 
	 if ($.trim($('##tdSystemVars').html()) == '') {
			ColdFusion.navigate('#SESSION.root#/Tools/CFReport/SubmenuReportView.cfm?ts='+new Date().getTime()+'&Context=report&controlid='+id+'&portal='+scope, 'tdSystemVars');
		}else {
			$('##tdSystemVars').html('');
		}
	 
	} else {
		
	if (ctx == "Application") {
		  w = screen.availWidth-90
	      h = screen.availHeight-128
		  ptoken.open("#SESSION.root#/Tools/CFReport/Analysis/SelectSource.cfm?height="+h+"&controlid="+id+"&dataset=1", "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", menubar=no, toolbar=no, status=yes, scrollbars=no, resizable=yes"); 
	    } else {		  
		  w = "#client.width-20#"
		  h = screen.availHeight-92		  
		  ptoken.open("#SESSION.root#/Tools/CFReport/SubmenuReportView.cfm?height="+h+"&Context=report&controlid=" + id+"&portal="+scope, id); 
		  // ptoken.open("#SESSION.root#/Tools/CFReport/SubmenuReportView.cfm?height="+h+"&Context=report&controlid=" + id+"&portal="+scope, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", <cfif #CLIENT.interface# eq "HTML" and #Parameter.ReportingFullScreen# eq '1'>fullscreen=yes,</cfif> menubar=no, toolbar=no, status=yes, scrollbars=no, resizable=yes"); 
		}		
	}
}

function verifycont(id,nme,add,del,nmeid) {

	try {   
   	se = document.getElementById(nme).value	
	} catch(e) {
	se = document.getElementsByName(nme)[0].value	
	}				
	url = "#SESSION.root#/Tools/CFReport/SelectInputVerify.cfm?del="+del+"&add="+add+"&Controlid="+id+"&CriteriaName="+nme+"&val="+se;		
	ColdFusion.navigate(url,'verify'+nme)	
	try {   	
	document.getElementById(nmeid).value = ''		
	document.getElementById(nmeid).focus()		   			
	} catch(e) { }
	
}	

function addOnEnter(event,id,nme,add,del,nmeid) { 
	var keycode = (event.keyCode ? event.keyCode : event.which);
    if(keycode == '13'){
		verifycont(id,nme,add,del,nmeid);
    }
}

</script>

</cfoutput>  
