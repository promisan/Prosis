
<cfquery name="Module" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ModuleControl
		WHERE    SystemModule  = 'Procurement'
		AND      FunctionClass = 'Application'
		AND      FunctionName  = 'Requisition Management'
</cfquery>		

<cfoutput>


<script language="JavaScript">

    w = #CLIENT.width# - 58;
	h = #CLIENT.height# - 115;
	
	function doRefresh(eg,miss,owner,me) {	
	    Prosis.busy('yes')		
		ptoken.open('#SESSION.root#/System/EntityAction/EntityView/MyClearances.cfm?EntityGroup='+eg+'&Mission='+miss+'&Owner='+owner+'&me='+me,'portalright');					
	}
	
	function more(bx,act,me) {
	  	
		icM  = document.getElementById(bx+"Min")
	    icE  = document.getElementById(bx+"Exp")					

		eg   = document.getElementById("sEntityGroup").value
		 
		if (icM.className == "hide"	) {
		   	 icM.className = "regular";
			 icE.className = "hide";			 
			 se = document.getElementsByName(bx)	
			 count = 0
			 while (se[count]) {
			   se[count].className = "regular"
			   count++
			 }  			
			 ptoken.navigate('#SESSION.root#/system/entityaction/entityview/MyClearancesEntity.cfm?entitycode='+bx+'&entitygroup='+eg+'&me='+me,'c'+bx)
		 } else {
		     icM.className = "hide";
		     icE.className = "regular";
			  se = document.getElementsByName(bx)	
			 count = 0
			 while (se[count]) {
			   se[count].className = "hide"
			   count++
			 }  
		}	
		
	  }		
	  
	function clearno() { document.getElementById("find").value = "" }
	
	function search() {
	
		se = document.getElementById("find")
		 
		 if (window.event.keyCode == "13")
			{	document.getElementById("locate").click() }
							
	    }
	
	function process(id) {
	   ptoken.open("#SESSION.root#/ActionView.cfm?id=" + id, id);	   
	}
	
	function entity() {
       ptoken.open("#SESSION.root#/system/entityaction/entityview/EntityView.cfm", "entity");
    }
	
	function searching(val)  {	    
		ptoken.navigate('#SESSION.root#/system/entityaction/entityview/MyClearancesSearch.cfm?val=' + val,'result')	
	}		
			
	function procbatch(mis,per,role,template) {
		ptoken.open("#SESSION.root#/Procurement/Application/Requisition/Process/"+template+".cfm?role="+role+"&header=1&mission=" + mis + "&Period=" + per, role, "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");	
	}
	
	function procbuyer(mis,per,role) {	
		ptoken.open("#SESSION.root#/Procurement/Application/Requisition/RequisitionView/RequisitionView.cfm?systemfunctionid=#Module.SystemFunctionId#&role=procbuyer&mission=" + mis + "&Period=" + per, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=yes");																		
	}	
	
	function doSummary() {
	  _cf_loadingtexthtml='';	  
	  ptoken.navigate('#SESSION.root#/System/EntityAction/EntityView/setSummary.cfm?mode=batch&overall='+document.getElementById('batchtotal').value,'batch')	
	  	 
	}
			
</script>	
</cfoutput>