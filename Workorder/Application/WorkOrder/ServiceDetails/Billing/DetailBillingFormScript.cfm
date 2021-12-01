
<cfoutput>
	
	<cfparam name="url.context" default="Backoffice">
	
	<script language="JavaScript">
	
	  function provisionload(mis,wid,wol,itm,req,bid,org,date,context,mode) {
	    _cf_loadingtexthtml="";	
	    ColdFusion.navigate('#SESSION.root#/workorder/application/workorder/servicedetails/billing/DetailBillingFormEntry.cfm?mission='+mis+'&serviceitem='+itm+'&mode='+mode+'&requestid='+req+'&workorderid='+wid+'&workorderline='+wol+'&billingid='+bid+'&date='+date+'&orgunitowner='+org,'boxprovision')		
	  }
	
	  function toggle(cl,val,show) {
	  
		  if (val == true) {
		   
		    try {
			document.getElementById(cl+'_unit').className         = "regular" } catch(e) {}
			
			if (show != '0') {
			
		  	document.getElementById(cl+'_frequency').className      = "regular"		
			document.getElementById(cl+'_quantity').className       = "regular"		
			document.getElementById(cl+'_quantity').value           = "1"	
			<cfif url.context neq "portal">			
			document.getElementById(cl+'_currency').className       = "regular"
			document.getElementById(cl+'_price').className          = "regular"		
			document.getElementById(cl+'_stdprice').className       = "regular"				
			document.getElementById(cl+'_charged').className        = "regular"		
			document.getElementById(cl+'_total').className          = "regular"		
			</cfif>			
			document.getElementById(cl+'_specification').className  = "regular"				
			} else {
			document.getElementById(cl+'_quantity').value           = "1"				
			}
		  
		  } else {
		  
		    try {
			document.getElementById(cl+'_unit').className         = "hide" } catch(e) {}
			
		    document.getElementById(cl+'_frequency').className      = "hide"		
			document.getElementById(cl+'_quantity').className       = "hide"	
			document.getElementById(cl+'_quantity').value           = "0"		
			<cfif url.context neq "portal">
			document.getElementById(cl+'_currency').className       = "hide"
			document.getElementById(cl+'_price').className          = "hide"	
			document.getElementById(cl+'_stdprice').className       = "hide"			
			document.getElementById(cl+'_charged').className        = "hide"	
			document.getElementById(cl+'_total').className          = "hide"			
			</cfif>
			document.getElementById(cl+'_specification').className  = "hide"	
			
		  }
		  
	  }
	
	  function toggledetail(cl,val,show) {	  
	     	     
		  if (val == true) {
		   document.getElementById('features_'+cl).className = "regular"
		  } else {
		   document.getElementById('features_'+cl).className = "hide"
		  }
		 
		  toggle(cl,val,show)		 
		  
		  cnt = 1
		  while (cnt <= 20) {
			   se = document.getElementsByName("box_"+cl)
			  
			   rw = 0
			   while (se[rw]) {				     
			      if (val == true) {					
				  se[rw].className = "regular fixlengthlist"
				  } else {					 
			      se[rw].className = "hide"
				  }		
				  rw++  
		       } 	  
		     cnt++	
		}	 	  
	  }		
	  
	  function selectunit(unitclass,row,qty,rate,sel) {
	  	     
		  if (sel == true) {
		    calc(unitclass,row,qty,rate)
			try {
			document.getElementById('reference_'+unitclass+'_'+row).className = "regular"			
			} catch(e) {}
			
			document.getElementById('qty_'+unitclass+'_'+row).className     = "regular"
			document.getElementById('freq_'+unitclass+'_'+row).className    = "regular"
			<cfif url.context neq "portal">			    
			    document.getElementById('cost_'+unitclass+'_'+row).className    = "regular"
				
				document.getElementById('curr_'+unitclass+'_'+row).className    = "regular"
				document.getElementById('price_'+unitclass+'_'+row).className   = "regular"
				document.getElementById('charge_'+unitclass+'_'+row).className  = "regular"
				document.getElementById('total_'+unitclass+'_'+row).className   = "regular"		
			</cfif>
	
		  } else {
		    calc(unitclass,row,0,rate)
			try {
			document.getElementById('reference_'+unitclass+'_'+row).className = "hide"
			} catch(e) {}
			document.getElementById('qty_'+unitclass+'_'+row).className     = "hide"
			document.getElementById('freq_'+unitclass+'_'+row).className    = "hide"	
			<cfif url.context neq "portal">
			document.getElementById('cost_'+unitclass+'_'+row).className    = "hide"					
			document.getElementById('curr_'+unitclass+'_'+row).className    = "hide"
			document.getElementById('price_'+unitclass+'_'+row).className   = "hide"
			document.getElementById('charge_'+unitclass+'_'+row).className  = "hide"			
			document.getElementById('total_'+unitclass+'_'+row).className   = "hide"	
			</cfif>
		  }	  
	  }  
	  
	  function calc(unitclass,row,qty,rate) {
	      _cf_loadingtexthtml="";	
	      ptoken.navigate('#SESSION.root#/workorder/application/workorder/servicedetails/billing/DetailBillingTotal.cfm?quantity='+qty+'&rate='+rate,'total_'+unitclass+'_'+row)
		  _cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";
	  }
	  
	  function unitshow(unitclass,costid,qty) {
	      _cf_loadingtexthtml="";			 
	      ptoken.navigate('#SESSION.root#/workorder/application/workorder/servicedetails/billing/getUnit.cfm?unitclass='+unitclass+'&costid='+costid+'&quantity='+qty,'ajaxbox')
 	  }
	  
	  function showfeature(unitclass,costid,wid,wol,req,mode,bid,org,date) {
	       _cf_loadingtexthtml="";			 		  		 
	      // ptoken.navigate('#SESSION.root#/workorder/application/workorder/servicedetails/billing/DetailBillingFormEntryRegularAjax.cfm?mode='+mode+'&requestid='+req+'&workorderid='+wid+'&workorderline='+wol+'&billingid='+bid+'&date='+date+'&costid='+costid+'&unitclass='+unitclass+'&orgunitowner='+org,'features_'+unitclass)	
	  }   

	
	</script>
	
</cfoutput>