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
