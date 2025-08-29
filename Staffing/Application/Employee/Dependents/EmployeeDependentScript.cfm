<!--
    Copyright © 2025 Promisan B.V.

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
<cfoutput>

<script language="JavaScript">
		
	function dependent(persno,mode,contractid) {
		
		if (contractid==undefined){
			contractid = '';
		}
				
		ProsisUI.createWindow('mydependent', 'Dependent', '',{x:100,y:100,height:parent.document.body.clientHeight-120,width:parent.document.body.clientWidth-320,modal:true,resizable:true,center:true})    					
		ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Dependents/DependentView.cfm?contractid='+contractid+'&action='+mode+'&ID='+persno,'mydependent') 		
	}	
	
	function dependentrefresh(personno,contractid,mode) {   	 		
		_cf_loadingtexthtml='';
	    ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Dependents/EmployeeDependentDetail.cfm?id='+personno+'&action='+mode+'&contractid='+contractid,'contentdependent')	
	}
	
	function dependentedit(persno,depid,mode,ctr) {
	
		if (mode == "contract") {	    
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
		     ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Dependents/EmployeeDependentWorkflow.cfm?ajaxid='+key,key)		   
			 
		} else { 		
			 se.className = "hide"
		     ex.className = "regular"
		   	 co.className = "hide" 			 
	    } 		
	}	

</script>

</cfoutput>
