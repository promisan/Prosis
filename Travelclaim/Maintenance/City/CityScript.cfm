
<cf_ajaxRequest>	

<cfoutput>

<SCRIPT LANGUAGE = "JavaScript">
   
    function hl(itm,fld) {
	
	 ie = document.all?1:0
	 ns4 = document.layers?1:0

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
			 	 	 		 	
	 if (fld == "1")
	      {itm.className = "highLight4";}
	 else 
	      {itm.className = "regular";}
	 }
    		   
	 var box = "999" ;
	 var cnt = 0;		
			 			   
	 function search() {
			
			se = document.getElementById("searching").className = "regular";
			se = document.getElementById("result").className = "hide";
			cit = document.getElementById("CitySelect")
			cde = document.getElementById("CityCodeSelect")
			cou = document.getElementById("CountrySelect")
			url = "RecordListing.cfm?ts="+new Date().getTime()+
			             "&CitySelect="+cit.value+
			             "&CityCodeSelect="+cde.value+
						 "&CountrySelect="+cou.value;						 
							 
			AjaxRequest.get({
        	'url':url,
	        'onSuccess':function(req){ 
					document.getElementById("searching").className = "hide";
					document.getElementById("result").innerHTML = req.responseText;
					document.getElementById("result").className = "regular";},
					
	        'onError':function(req) { 
					document.getElementById("searching").className = "hide";
					document.getElementById("result").innerHTML = req.responseText;
					document.getElementById("result").className = "regular";}	
		         }
			 );					 
 			
		} 
		
	function dsaNew(city,loc,mode) {			
		
		url = "CityDSAAdd.cfm?CountryCityId="+city+"&locationcode="+loc+"&mode="+mode
		box = "cityadd_"+city+"_"+loc	
		se = document.getElementById(box)
		se.className = "regular"
		AjaxRequest.get(
			{
        	'url':url,
	        'onSuccess':function(req){ 
					document.getElementById(box).innerHTML = req.responseText;},
					
            'onError':function(req) { 
					document.getElementById(box).innerHTML = req.responseText;}	
		         }
			 );						
		}	
		
	function dsaDel(city,code) {
		
		if (confirm("Do you want to delete this DSA code ?")) {
  		
		box = "city_"+city	
		url = "CityDSASubmit.cfm?ts="+new Date().getTime()+"&countrycityid="+city+"&code="+code+"&action=delete"		
		
		AjaxRequest.get({
        	'url':url,
	        'onSuccess':function(req){ 
					document.getElementById(box).innerHTML = req.responseText;},
					
            'onError':function(req) { 
					document.getElementById(box).innerHTML = req.responseText;}	
		         }
			 );		
		
		} else {return false}
		
		}
					
	function dsaEdit(city,code,mode,action)	{
	
	    if (action == "delete") {
		    if (confirm("Do you want to delete this DSA code ?")) {
		
				box = "city_"+city			
				url = "CityDSASubmit.cfm?ts="+new Date().getTime()+"&countrycityid="+city+"&code="+code+"&mode="+mode+"&action="+action		
			
				AjaxRequest.get({
		        	'url':url,
			        'onSuccess':function(req){ 
							document.getElementById(box).innerHTML = req.responseText;},
							
		            'onError':function(req) { 
							document.getElementById(box).innerHTML = req.responseText;}	
				         }
					 );			
			 }	 
			} else {
			
			box = "city_"+city			
				url = "CityDSASubmit.cfm?ts="+new Date().getTime()+"&countrycityid="+city+"&code="+code+"&mode="+mode+"&action="+action		
			
				AjaxRequest.get({
		        	'url':url,
			        'onSuccess':function(req){ 
							document.getElementById(box).innerHTML = req.responseText;},
							
		            'onError':function(req) { 
							document.getElementById(box).innerHTML = req.responseText;}	
				         }
					 );			
			
			} 	
		}		
		
	function dsaHide(city,loc) {
		se = document.getElementById("cityadd_"+city+"_"+loc)
		se.className = "hide"
		}		 	 
															
	function dsasave(city,loc) {
					
		code  = document.getElementById(city+"_"+loc+"_LocationCode");
		date  = document.getElementById(city+"_"+loc+"_DateEffective");
		expi  = document.getElementById(city+"_"+loc+"_DateExpiration");
		def   = document.getElementsByName(city+"_"+loc+"_LocationDefault");
		url = "CityDSASubmit.cfm?ts="+new Date().getTime()+
				"&countrycityid="+city+"&LocationCode="+code.value+"&DateEffective="+date.value+"&DateExpiration="+expi.value+"&LocationDefault="+def[1].checked
		box = "city_"+city	
		
		AjaxRequest.get(
			{
        	'url':url,
	        'onSuccess':function(req){ 
					document.getElementById(box).innerHTML = req.responseText;},
					
            'onError':function(req) { 
					document.getElementById(box).innerHTML = req.responseText;}	
		         }
			 );		
			 
		}	
			
</script>	

</cfoutput>	