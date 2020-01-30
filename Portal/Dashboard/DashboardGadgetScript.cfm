
<cfoutput>

<script>

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight3";
	 }else{
		
     itm.className = "regular";		
	 }
  }

</script>
 
<script>

	<!--- select content for a box --->
	function item(frm,loc,id) {	   
	    ColdFusion.Window.create('selecttpc', 'Select Dashboard Topic','',{x:100,y:100,height:600,width:700,resizable:false,modal:true,center:true})					
		ColdFusion.Window.show('selecttpc')
		ColdFusion.navigate('DashboardSelect.cfm?frm='+frm+'&loc='+loc+'&id='+id,'selecttpc',mycallBack,myerrorhandler)		
	}
	
	<!--- load content for a box --->					
	function selectnew(frm,loc,id,cls) {
	    ColdFusion.Window.hide('selecttpc')			
		ColdFusion.navigate('DashboardItemSave.cfm?type='+cls+'&frm='+frm+'&id='+id+'&loc='+loc,loc,mycallBack,myerrorhandler)			
	}
	
	<!--- load report settings --->				
	function schedule(id) {
   		w = #CLIENT.width# - 16;
	    h = #CLIENT.height# - 78;
		window.open("#SESSION.root#/tools/cfreport/SubmenuReportView.cfm?id=" + id + "&context=subscription", "_blank", "left=0, top=0, width=" + w + ", height= " + h + ", menubar=no, toolbar=no, status=yes, scrollbars=yes, resizable=yes");
	}
	
	<!--- edit the settings of the topic --->
	function edit(frm,loc,id) {
	    ColdFusion.navigate('#SESSION.root#/portal/dashboard/TopicEdit.cfm?id=' + id + '&context=subscription','box_'+loc)
	}
		
	<!--- drill down on the topic --->		
	function zoom(id) {  
    window.open("DashBoardZoom.cfm?id="+id, "zoom","width=900, height=700, status=yes, toolbar=no, scrollbars=yes, resizable=yes")
	}			
	
	
	function drill(lnk) {
		window.open("#SESSION.root#/" + lnk + "?ts="+new Date().getTime(), "drill", "unadorned:yes; edge:raised; status:yes; dialogHeight:760px; dialogWidth:850px; help:no; scroll:no; center:yes; resizable:no");
    	<!--- window.open("#SESSION.root#/" + lnk,"drill", "width=825, height=730, status=yes, scrollbars=yes, resizable=yes"); --->
	}
	
	<!--- open the report --->	
	function report(id){
    w = #CLIENT.width# - 16;
    h = #CLIENT.height# - 127;
	window.open("#SESSION.root#/tools/cfreport/ReportLinkOpen.cfm?reportid=" + id, "_blank", "left=0, top=0, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");
	}		
	
	function mycallBack(text) { }
		
	var myerrorhandler = function(errorCode,errorMessage){
			alert("[In Error Handler]" + "\n\n" + "Error Code: " + errorCode + "\n\n" + "Error Message: " + errorMessage);
	}	
	
	function submitForm(frm,url) {
		ColdFusion.Ajax.submitForm(frm, url, mycallBack,myerrorhandler);
		history.go()
	}
	
	<!--- not needed ---> 
	function maintain() {
    window.open("../Preferences/UserEditDashboard.cfm", "Edit", "left=40, top=15, width=760, height=538, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
		
</script>


</cfoutput>