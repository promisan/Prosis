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
	
	function ask() {
		if (confirm("Do you want to remove this record ?")) {	
		return true 	
		}	
		return false	
	}	
	
	function selectall(no,chk) {
	var count=0
	while (count < 9999) {    
		 if (ie){
	          itm=no[count].parentElement;  
	          itm=itm.parentElement; }
	     else{
	          itm=no[count].parentNode;  
	          itm=itm.parentNode; }
	    
		if (chk == true)
		    {itm.className = "highLight";
			 no[count].checked = true;
			}		
		else {      
		   itm.className = "regular";
		   no[count].checked = false; }	
	    count++;
	   }	
	}
	
	function ShowUser(account,content) {
	
	        w = #CLIENT.width# - 60;
	        h = #CLIENT.height# - 100;
			ptoken.open("#session.root#/System/Access/User/UserDetail.cfm?Content="+content+"&ID=" + account + "&ID1=" + h + "&ID2=" + w, "_blank");		
		}
		
	function setaddress(id,context,contextid) {
	   	ProsisUI.createWindow('address', 'Address', '',{x:100,y:100,height:600,width:700,modal:true,resizable:false,center:true})    						
		ptoken.navigate('#SESSION.root#/System/Address/AddressView.cfm?context=' + context + '&contextid=' + contextid+ '&addressid=' + id,'address') 			  
	}	
	
	function saveaddress(id,context,contextid) {
		document.theaddress.onsubmit() 
		if( _CF_error_messages.length == 0 ) {           		 
			ptoken.navigate('#session.root#/System/Address/AddressSave.cfm?context=' + context + '&contextid=' + contextid+ '&addressid=' + id,'addressprocess','','','POST','theaddress')
		 }   
	}	 

</script>

</cfoutput>
