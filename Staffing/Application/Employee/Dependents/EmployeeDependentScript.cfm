
<cfoutput>

<script language="JavaScript">
		
	function dependent(persno,mode,contractid) {
		
		if (contractid==undefined){
			contractid = '';
		}
		
		try { parent.ColdFusion.Window.destroy('mydependent',true) } catch(e) {}
		parent.ColdFusion.Window.create('mydependent', 'Dependent', '',{x:100,y:100,height:parent.document.body.clientHeight-80,width:parent.document.body.clientWidth-80,modal:true,resizable:false,center:true})    					
		parent.ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Dependents/DependentView.cfm?contractid='+contractid+'&action='+mode+'&ID='+persno,'mydependent') 		
	}	
	
	function dependentrefresh(personno,contractid,mode) {   	 		
		_cf_loadingtexthtml='';
	    ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Dependents/EmployeeDependentDetail.cfm?id='+personno+'&action='+mode+'&contractid='+contractid,'contentdependent')	
	}
	
	function dependentedit(persno,depid,mode,ctr) {
	
		if (mode == "contract") {
		    
//			try { parent.ColdFusion.Window.destroy('mydependent',true) } catch(e) {}
			parent.ProsisUI.createWindow('mydependent', 'Maintain Dependent', '',{x:100,y:100,height:parent.document.body.clientHeight-120,width:parent.document.body.clientWidth-120,modal:true,resizable:false,center:true})    					
			parent.ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Dependents/DependentView.cfm?contractid='+ctr+'&action='+mode+'&ID='+persno+'&ID1='+depid,'mydependent') 		
		
		} else {
		
			ptoken.location("#SESSION.root#/Staffing/Application/Employee/Dependents/DependentView.cfm?contractid="+ctr+"&action="+mode+"&ID="+persno+"&ID1="+depid)		
					
		}
	}	
		
	function dependentshow(id,status,action) {		    
	    ptoken.location("#SESSION.root#/staffing/application/employee/dependents/EmployeeDependent.cfm?id="+id+"&status="+status+"&action="+action)			  
	}
	
	function workflowdrilldependent(key,box) {
			
	    se = document.getElementById(box)		
		ex = document.getElementById("exp"+key)		
		co = document.getElementById("col"+key)
					
		if (se.className == "hide") {		
		
		     se.className = "regular" 		   
		     co.className = "regular"
		     ex.className = "hide"		   
		     ColdFusion.navigate('#SESSION.root#/Staffing/Application/Employee/Dependents/EmployeeDependentWorkflow.cfm?ajaxid='+key,key)		   
			 
		} else { 		
			 se.className = "hide"
		     ex.className = "regular"
		   	 co.className = "hide" 			 
	    } 		
	}	

</script>

</cfoutput>
