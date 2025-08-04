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

<cfoutput>

<script language="JavaScript">

function selectmenu(option) {

	or = document.getElementById('orgunit').value
	
	document.getElementById("budget").className   = "hide"
	document.getElementById("service").className  = "hide"
	<!--- document.getElementById("staffing").className = "hide"  --->
		
	try {	
	document.getElementById(option).className="regular"	} catch(e) {}
	
	if (option == "budget") {		
	    ColdFusion.navigate('BudgetViewAction.cfm?portal=1&id=budget&period=#URL.Period#&edition=#url.edition#&mode=#URL.mode#&ID1='+or+'&mission=#URL.mission#','menucontent');
	}
	if (option == "service") {
	    ColdFusion.navigate('BudgetViewCustomer.cfm?dsn=appsworkorder&org='+or,'menucontent')
	}
	if (option == "staffing") {
	    ColdFusion.navigate('BudgetViewStaffing.cfm?org='+or,'menucontent')
	}
		
}

function init() {    
     or = document.getElementById('orgunit').value	 	
	 ColdFusion.navigate('BudgetViewActionInit.cfm?portal=1&id=budget&period=#URL.Period#&edition=#url.edition#&mode=#URL.mode#&ID1='+or+'&mission=#URL.mission#','content');
}

function toggle(option,topic)  {
					
	or = document.getElementById('orgunit').value
	
	if (option == "budget") {
				
		if (topic == "chart") {						
		   document.getElementById(option+topic).className="hide"			   
		   document.getElementById(option+"list").className="regular"
		   ColdFusion.navigate('BudgetViewGraph.cfm?period=#url.period#&edition=#url.edition#&id1='+or,'menucontent')		
		} else {
		   document.getElementById(option+topic).className="hide"			  
		   document.getElementById(option+"chart").className="regular"
	       ColdFusion.navigate('BudgetViewAction.cfm?portal=1&id=budget&period=#URL.Period#&edition=#url.edition#&mode=#URL.mode#&ID1='+or+'&mission=#URL.mission#','menucontent');	
		}
		
	} else {
	
			if (topic == "chart") {
				 
				   document.getElementById(option+topic).className="hide"			   
				   document.getElementById(option+"list").className="regular"
				   alert("pending")
			
			} else {
								  
				   document.getElementById(option+topic).className="regular"			  
				   document.getElementById(option+"chart").className="hide"
				   ColdFusion.navigate('BudgetViewCustomer.cfm?org='+or,'portalcontent')
			
			}
	
		}	
	}
	

function search() {
	
	 if (window.event.keyCode == "13")
		{	document.getElementById("findlocate").click() }
						
}

function reloadBudget(page) {       	  

	   vw  = document.getElementById("view").value	 
	   la  = document.getElementById("layout").value	 		  
	   fd  = document.getElementById("find").value    
	   or  = document.getElementById("orgunit").value 	   	  
	   ed  = document.getElementById("editionselect").value  
	   ColdFusion.navigate('#SESSION.root#/ProgramREM/Application/Budget/AllotmentView/AllotmentViewDetail.cfm?portal=1&id=budget&find='+fd+'&ProgramGroup=all&period=#URL.Period#&edition='+ed+'&mode=#URL.mode#&ID1='+or+'&page=' + page + '&view=' + vw + '&lay=' + la + '&mission=#URL.mission#','content');
}
								
</script>


</cfoutput>