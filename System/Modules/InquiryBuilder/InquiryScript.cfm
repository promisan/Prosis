
<cfajaximport tags="cfwindow">

<cfoutput>
	
	<script language="JavaScript">
	
	function show(act) {
	
	 se = document.getElementsByName('detailfunction')
	 v = 0
	 while (se[v]) {
		   se[v].className = act  
		   v++
		 }
	 }  
		 
     function closeme(val) {  
	      document.getElementById("drilltemplate").value = val
    	  ColdFusion.Window.destroy('mydrill',true)		
    }
	 
	function toggle(fld,val) {
	
	  if (val == "") {
	  	document.getElementById(fld).disabled = true
	  } else {
	    document.getElementById(fld).disabled = false
	  }
	  
	}
	
	function fieldedit(fid,sid,ser) {		  		
		ProsisUI.createWindow('myfield', 'Field', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})    				
		ptoken.navigate('#SESSION.root#/system/modules/InquiryBuilder/FieldView.cfm?systemfunctionid='+sid+'&functionserialno='+ser+'&fieldid='+fid,'myfield') 					  
	}
	
	function fieldrefresh(sid,ser) {	
	    _cf_loadingtexthtml='';
	    ColdFusion.navigate('#SESSION.root#/System/Modules/InquiryBuilder/InquiryEditFields.cfm?systemfunctionid='+sid+'&functionserialno='+ser,'fields')	     				
	}
	 
	function selectdrilltemplate() {			   	
		ProsisUI.createWindow('mydrill', 'Drill', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})    				
		ptoken.navigate('#SESSION.root#/system/modules/inquirybuilder/DrillTemplate.cfm','mydrill') 	   
	} 
	 
	function preview(id) {	
		ptoken.open("#SESSION.root#/tools/listing/listing/Inquiry.cfm?idmenu="+id+"&height=500", "preview", "width=#client.width-100#,height=800,status=yes,resizable=yes");		
	} 
	
	function copy(id) {		
		ptoken.open("#SESSION.root#/system/modules/inquirybuilder/CopyInquiryQuery.cfm?id="+id,"copy","width=500,height=360,status=yes,resizable=no");						
	}
		
	function editpreparation(id,ser) {	
	    		
		ProsisUI.createWindow('myscript', 'Query', '',{x:100,y:100,height:document.body.clientHeight-90,width:document.body.clientWidth-90,modal:true,resizable:false,center:true})    						
		ColdFusion.navigate('#SESSION.root#/system/modules/inquirybuilder/PreparationEdit.cfm?ts='+new Date().getTime()+'&systemfunctionid='+id+'&functionserialno='+ser,'myscript') 
//		window.showxxxModalDialog("#SESSION.root#/system/modules/inquirybuilder/PreparationEdit.cfm?ts="+new Date().getTime()+"&systemfunctionid="+id+"&functionserialno="+ser, window, "unadorned:yes; edge:raised; status:yes; dialogHeight:770px; dialogWidth:970px; help:no; scroll:no; center:yes; resizable:yes");		
	}	
		
	function embedding(val) {	
	
	     se = document.getElementsByName("template")
		 i=0
		 if (val == "None" || val == "Default" || val == "Workflow") {
		    while (se[i]) {  se[i].className = "hide";i++  }
		 } else {
		   while (se[i]) {  se[i].className = "regular";i++ }		  
		 }
	 }	
		 	
	</script>
	
</cfoutput>