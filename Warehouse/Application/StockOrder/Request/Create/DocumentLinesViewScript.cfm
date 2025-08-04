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

<cfparam name="Object.ObjectKeyValue4"  default="">

<!--- set url.id values based on the context --->
<cfif Object.ObjectKeyValue4 neq "">
		
	<cfquery name="Parameter" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM  Ref_ParameterMission
		WHERE Mission = '#Object.Mission#'
	</cfquery>
	
</cfif>

<cfoutput>

<cf_dialogProcurement>

<script language="JavaScript">
		
	function mail2(mode,id) {
		  window.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id="+mode+"&ID1="+id+"&ID0=#Parameter.RequisitionTemplate#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	}	

	function mail2multiple(mode,id,target) {
		  window.open("#SESSION.root#/Tools/Mail/MailPrepareOpen.cfm?id="+mode+"&ID1="+id+"&ID0=#Parameter.RequisitionTemplateMultiple#",target, "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
	}	
		 
	function hl(itm,fld){  
	          while (itm.tagName!="TR")
	          {itm=itm.parentElement;
	     }     		 	 		 	
		 if (fld != false){			
			 itm.className = "highLight2";
		 } else {		
			 itm.className = "regular";		
		 }	 
	}
	
	function task(id) {
	 	  
	 try { ColdFusion.Window.destroy('mydialog',true) } catch(e) {}
	 ColdFusion.Window.create('mytask', 'Task', '',{x:100,y:100,height:document.body.clientHeight-80,width:document.body.clientWidth-80,modal:true,resizable:false,center:true})    					
	 ColdFusion.navigate(root + '/Warehouse/Application/StockOrder/Task/Tasking/Task.cfm?requestid=' + id,'mytask') 		
	 	
	}
	
	function taskrefresh(id) {
	   ColdFusion.navigate('#SESSION.root#/Warehouse/Application/StockOrder/Request/Create/DocumentLinesTask.cfm?requestid='+id,'tc'+id)
	}
	  
	function requestdetail(id) {
	
		url = "#SESSION.root#/Warehouse/Portal/Requester/ItemView.cfm?id="+id
		se = document.getElementById("b"+id)
		e = document.getElementById(id+"Exp")
		m = document.getElementById(id+"Min")
		if (se.className == "regular") {
			   se.className = "hide"
			   e.className = "regular"
			   m.className = "hide"
		     }
	    else {
		se.className = "regular"
		e.className = "hide"
		m.className = "regular"
		ColdFusion.navigate(url,'i'+id)	
	    }
	
	}  

</script>

</cfoutput>