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
<script language = "JavaScript">
	
	function addAccount(first,last,acc) {	
			
			var u = document.getElementsByName("user"); 
			if (u)
				for (i=0; i<u.length; i++){
					usr = u[i].value;
					if (acc == usr){
						alert(last+", "+first+" ("+acc+") "+"is already in the list.");
						return;
					}
				}
			
		    var newRow = document.getElementById("accTable").insertRow(0);

			newRow.insertCell(0).width="50px";
			
		    var oCell = newRow.insertCell(1);
			oCell.align     = "left";
			oCell.width		= "100%";
			oCell.height	= "20px";
			oCell.className = "labelit navigation_row"			
		    oCell.innerHTML = last+", "+first+" ("+acc+")  <input type='hidden' name='user' id='user' value='"+acc+"'>";
		    
		    oCell = newRow.insertCell(2);
		    oCell.innerHTML = "<img src='<cfoutput>#SESSION.root#</cfoutput>/images/delete5.gif' height='12' width='12' style='cursor:pointer' onclick='removeAccount(this);'/>";   
			
			var accInfoRow = document.getElementById("accTable").insertRow(1);
			accInfoRow.insertCell(0).width="50px";
			var detailsCell = accInfoRow.insertCell(1);
			detailsCell.id = acc+"_details";
			accInfoRow.insertCell(2);
			
			var sepRow  = document.getElementById("accTable").insertRow(2);
			var sepCell = sepRow.insertCell(0);
			var sepCell = sepRow.insertCell(1);
			sepCell.colSpan= "2";
			sepCell.className  = "linedotted";
			
			updateAccountDetails();
		
	}
	
	//deletes the specified row from the table
	function removeAccount(src)	{		
	    var oRow = src.parentNode.parentNode;  	     
		var index = oRow.rowIndex;
	    document.getElementById("accTable").deleteRow(index);
		//delete details 
		document.getElementById("accTable").deleteRow(index);  	
		//delete dotted line
		document.getElementById("accTable").deleteRow(index);  	
	}

	function updateAccountDetails(){

		var u = document.getElementsByName("user"); 
		if (u)
			for (i=0; i<u.length; i++){
				var acc = u[i].value;
				var cell = document.getElementById(acc+"_details");
				cell.innerHTML = "Updated";
				ColdFusion.navigate('getAccountDetails.cfm?acc='+acc,acc+'_details','','','POST','requestAccessForm');
			}
			
	}
	
	function initMissionRole(){
	    
		w  = document.getElementById("Workgroup");
		if (w){
			updateMission(w.value);
			updateRole(w.value);
		}
		
	}
	
	function initGroup(){

		m  = document.getElementById("Mission");
		w  = document.getElementById("Workgroup");

		if (m && w){
		
			updateGroup(m.value,w.value);
			
			t = document.getElementById("rowGroup");
			if (m.value == ""){
				t.className = "hide";
			}else{
				t.className = "regular";
			}
		
		}
		
	}
	
	function updateRole(workgroup){
	    _cf_loadingtexthtml='';	
		ptoken.navigate('AccessRequestRole.cfm?requestid=<cfoutput>#requestid#</cfoutput>&application='+workgroup,'irole')
	}
	
	function updateMission(workgroup){
	    _cf_loadingtexthtml='';	
		ptoken.navigate('AccessRequestMission.cfm?requestid=<cfoutput>#requestid#</cfoutput>&application='+workgroup,'div_mission');
	}
	
	function updateGroup(mission,workgroup) {	
		    
		rid  = document.getElementById('RequestId');
		if (rid){				    
			r  = rid.value			
			t = document.getElementById("rowGroup");
			if (mission == ""){
				t.className = "hide";
			}else{
				t.className = "regular";
			}			
			_cf_loadingtexthtml='';	
			ptoken.navigate('AccessRequestGroup.cfm?mission='+mission+'&application='+workgroup+'&requestid='+r,'igroup')			
		}
	}	

	function toggleDisplay(row,image){
		img     = document.getElementById(image);
		
		$('#'+row).toggle();
		if ($('#'+row).is(':visible')) {
			img.src= "<cfoutput>#SESSION.root#</cfoutput>/Images/arrowdown.gif";
		}else{
			img.src = "<cfoutput>#SESSION.root#</cfoutput>/Images/arrowright.gif";
		}
	}
	
	function toggleSystemModule(module){
	
		var content = document.getElementById(module+'_role');
		var icon = document.getElementById(module+'_icon');
		
		if (content.className == "hide"){
			content.className = "regular"
			icon.src = "<cfoutput>#SESSION.root#</cfoutput>/Images/arrowdown.gif";
		}else{
			content.className="hide"
			icon.src = "<cfoutput>#SESSION.root#</cfoutput>/Images/arrowright.gif";
		}

	}
	
	function hl(box,md) {
		   		
	    se  = document.getElementsByName(box)
		cnt = 0
			
		if (md == true) {	
		 		  
		   while (se[cnt]) {			     
		   se[cnt].className = "highlight"		  
		   cnt++ 
		   }		   		 	 
		
		} else {
		
		   while (se[cnt]) {
		   se[cnt].className = "regular"
		   cnt++ }	
		   
		}
	
	}
	
	function  submitForm(action){
	
		document.requestAccessForm.onsubmit() 
		if( _CF_error_messages.length == 0 ) {		
		
			var rows = document.getElementById('accTable').getElementsByTagName('tr');
			
			if (rows && rows.length > 0){
							
				r     = document.getElementsByName('SystemRole');
				roles = 0;
				if (r){
					for (i=0; i<r.length; i++)
						if (r[i] && r[i].type == "checkbox")
							if (r[i].checked) { roles = 1; break; }			
				}		
						
				g	   = document.getElementsByName('AccountGroup');
				groups = 0
				if (g){
					for (i=0; i<g.length; i++)
						if (g[i] && g[i].type == "checkbox")
							if (g[i].checked) { groups = 1; break; }
				}				
				
				p	   = document.getElementsByName('Portal');
				portal = 0;
				if (p){
					for(i=0; i<=p.length; i++){
						if (p[i] && p[i].type == "checkbox")
							if (p[i].checked) { portal = 1; break; }
					}
				}
				
				if (roles == 0 && groups==0 && portal ==0)
				{
					alert('Please select the access you want to request.');
					return false;
				}else{
				
				 	ptoken.navigate('DocumentEntrySubmit.cfm?action='+action,'detailsubmit','','','POST','requestAccessForm');
				}
					
			}else
				alert('Please associate one or more user accounts to this request');

		}
	}
	
</script>