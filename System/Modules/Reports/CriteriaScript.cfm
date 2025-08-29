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

function viewscript(val) {

	 if (val == "Table") {
		   document.getElementById("viewscript").className = "hide"
	 } else {
		   document.getElementById("viewscript").className = "regular"
	 }
}  

function copy(crit,mod) {
    ptoken.navigate('CriteriaBorrow.cfm?status=#url.status#&id=#URL.ID#&id1='+crit+'&id2='+mod,'fields')
}

function doCreateView(id,status,id1,mul) {	
	ptoken.navigate('CriteriaEditViewCreate.cfm?id='+id+'&Status='+status+'&ID1='+id1+'&multiple='+mul,'viewresult','','','POST','dialog');		
}

function today(val) {
	
	if (val) {
	  se = document.getElementById("defaultDate")
	  se.value = "today"
	  se.className = "hide"
	  se = document.getElementById("criteriadaterelative") 
	  se.disabled = false
	  } else {  
	  se = document.getElementById("defaultDate")
	  se.value = ""
	  se.className = "regular"
	  se = document.getElementById("criteriadaterelative")
	  se.checked = false
	  se.disabled = true
	  }
  
}

function show(mde,old) {
    if (old != "")
	    if (confirm("Changing the criteria type will save your settings. Continue ?")) {
    	save(mde)
		} else {
		document.getElementById("criteriatype").selectedIndex = document.getElementById("criteriatypeold").value
		}
	else {
		 save(mde)
	}	
	}

function check(nm,des) {
se = document.getElementById("criteriatype")
if ((nm == "") || (des == "")) { 
	   se.disabled = true }
else { se.disabled = false }
}  
 
function ask() {
	if (confirm("Do you want to remove this parameter ?")) {
	return true 
	}	
	return false	
}	

function showtable(id1,table,mul,ds) {

   ptoken.open("CriteriaEditField.cfm?ts="+new Date().getTime()+"&ID=#URL.ID#&ID1="+id1+"&ID2="+table+"&ds="+ds, "ifield"); 
   
   try {
   if (mul == true) {
     ptoken.open("CriteriaSubField.cfm?ts="+new Date().getTime()+"&Status=#URL.Status#&ID=#URL.ID#&ID1="+id1+"&ID3="+table+"&multiple=0&ds="+ds, "isubfield");  			
   } else {
     ptoken.open("CriteriaSubField.cfm?ts="+new Date().getTime()+"&Status=#URL.Status#&ID=#URL.ID#&ID1="+id1+"&ID3="+table+"&multiple=1&ds="+ds, "isubfield");  			
   } } catch(e) {}
}
  
function extended(id1,table,mul,ds,fld) {    
   ptoken.navigate('CriteriaSubField.cfm?Status=#URL.Status#&ID=#URL.ID#&ID1='+id1+'&table='+table+'&multiple='+mul+'&ds='+ds+'&keyfld='+fld,'isubfield');		
}

function save(val) {
	document.dialog.onsubmit();	
	if( _CF_error_messages.length == 0 ) {	  	
	    Prosis.busy('yes')    
		ptoken.navigate('CriteriaEditSubmit.cfm?id1=#url.id1#&status=#URL.status#&option='+val,'fields','','','POST','dialog')
	 }   
}	 
 
function regex(val) {
 if (val == "regex") { 
     document.getElementById("b21").className = "regular";
     document.getElementById("b22").className = "regular";
 } else {
     document.getElementById("b21").className = "hide";
     document.getElementById("b22").className = "hide";
 }  
 }
 
function checklookup(name,sel,display,sorting,table,ds) {		
     ptoken.open("SQLCheck.cfm?ts="+new Date().getTime()+"&Id=#URL.ID#&ID1=#URL.ID1#&ds="+ds+"&name="+name+"&table="+table+"&sel="+sel+"&display="+display+"&sorting="+sorting, "checkcrit", "left=15, top=15, width=600, height=500, toolbar=no, status=no, scrollbars=yes, resizable=yes");			
}  

</script>


</cfoutput>