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

<script>

  function changeDate() {  
	   ptoken.navigate('../Travel/setDays.cfm?id=#url.id#&field=date','travelservice','','','POST','trvedit')	   	   
	 }
	
	function travelitem(field,value,attr1,attr2) {   	
	    qty = document.getElementById('quantity').value		
		prc = document.getElementById('UoMPercentage').value		     
	    ptoken.navigate('../Travel/setDays.cfm?id=#url.id#&field='+field+'&value='+value+'&attr1='+attr1+'&attr2='+attr2+'&percent='+prc+'&quantity='+qty,'travelservice')
	    }			
	
	function travelvalidate(ac) {
	
		document.trvedit.onsubmit() 
		if(  _CF_error_messages.length == 0 ) {
		     _cf_loadingtexthtml='';	
	         ColdFusion.navigate('../Travel/TravelItemSubmit.cfm?ID=#URL.ID#&ID2='+ac,'iservice','','','POST','trvedit')
			 }   	 
		}
	
	function selectcity(field,id) {
		   ProsisUI.createWindow('city', 'City Search', '',{x:100,y:100,minheight:510,height:510,minwidth:490,width:490,modal:true,center:true})
		   ptoken.navigate('#SESSION.root#/travelclaim/application/Inquiry/Lookup/City/CitySearch.cfm?field='+field+'&id='+id, 'city');
		}  
		
	function citysearch(field,id) {
			
		cit = document.getElementById("CitySelect")	
		cde = document.getElementById("CityCodeSelect")	
		cou = document.getElementById("CountrySelect")
			
		ColdFusion.navigate('#SESSION.root#/travelclaim/application/Inquiry/Lookup/City/CitySearchResult.cfm?id='+id+'&field='+field+		
		             '&CitySelect='+cit.value+
		             '&CityCodeSelect='+cde.value+
					 '&CountrySelect='+cou.value,'cityresult')				
		}	
			
	function cityselect(field,id,city) { 
	
		ProsisUI.closeWindow('city')		  			    		
		ptoken.navigate('../Travel/ItineraryEditCity.cfm?field='+field+'&cityid='+city,field)		
		}			 		
	
	function itinvalidate() {
	
		document.itinedit.onsubmit() 
		
		try {
			per = document.getElementById("personno").value
		} catch(e) { per = "" }
		
		if( _CF_error_messages.length == 0 ) {	
	        ptoken.navigate('#SESSION.root#/Procurement/Application/Requisition/Travel/ItinerarySubmit.cfm?scope=purchase&pers='+per+'&ID=#URL.ID#','iservice','','','POST','itinedit')
		 }   
	}
	
	function addleg(act,no,next) {
		se = document.getElementsByName("dest"+no)
		count = 0
		if (act == "show") {
		   document.getElementById("destadd"+no).className = "hide"
		   try {
		   document.getElementById("destadd"+next).className = "regular"
		   } catch(e) {}
		   while (se[count]) {
			   se[count].className = "regular"
			   count++
			  } 
		} else {
		   document.getElementById("destadd"+no).className = "regular"
		   try {  document.getElementById("destadd"+next).className = "hide" } catch(e) {}
		   try {
		   document.getElementById("locationcity"+no).value = ""
		   document.getElementById("city"+no+"id").value = ""
		   } catch(e) {}
			while (se[count]) {
			   se[count].className = "hide"
			   count++
			  } 
		}
	}
	
</script>

</cfoutput>