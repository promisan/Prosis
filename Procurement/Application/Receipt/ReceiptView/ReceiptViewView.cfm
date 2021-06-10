
<cf_screentop html="no" jquery="Yes">

<!--- prevent caching --->
<script language="JavaScript">
	javascript:window.history.forward(1);
</script> 

<cfajaximport tags="cfwindow">
<cf_dialogProcurement>
<cf_dialogMaterial>
<cf_systemscript>

<cfparam name="url.period" default="">
<cfparam name="URL.warehouse"  default="">

<cfoutput>
		
	<script language="JavaScript">
	
		function more(box,id,act,mode) {
				
			icM  = document.getElementById(box+"Min")
		    icE  = document.getElementById(box+"Exp")
			se   = document.getElementById(box);
					 		 
			if (act=="show") {	 
		     	 icM.className = "regular";
			     icE.className = "hide";
		    	 se.className  = "regular";
				 ColdFusion.navigate('../ReceiptEntry/ReceiptDetail.cfm?box=i'+id+'&Rctid='+id+'&mode='+mode+'&id1=#URL.ID1#','i'+id)
			 } else {
			   	 icM.className = "hide";
			     icE.className = "regular";
		     	 se.className  = "hide"
			 }
				 		
		  }
		  
		function reloadForm(page) { 
		      Prosis.busy('yes')
			  _cf_loadingtexthtml='';	
		      ptoken.navigate("ReceiptViewListing.cfm?mission=#URL.Mission#&warehouse=#url.warehouse#&period=#url.period#&id=#url.id#&id1=#url.id1#&page="+page,'detail');	
		}  
				
				
		function filter() {
			document.formlocate.onsubmit() 
			if( _CF_error_messages.length == 0 ) {
			    Prosis.busy('yes')
				_cf_loadingtexthtml='';	
				ptoken.navigate('ReceiptViewListingPrepare.cfm?Period=#URL.Period#&ID=#URL.ID#&ID1=#URL.ID1#&Mission=#URL.Mission#','detail','','','POST','formlocate')
			 }   
		}	 
	
	</script>
	
	</cfoutput>

<table width="99%" border="0" align="center" height="100%">
    <cfif url.id1 eq "Locate">
		<tr><td style="height:10px"><cfinclude template="ReceiptViewLocate.cfm"></td></tr>
		<tr><td height="100%" valign="top"><cfdiv id="detail" style="height:100%"></td></tr>
	<cfelse>
	<tr><td height="100%">
	    <cfdiv id="detail" style="height:100%">
		  <cfinclude template="ReceiptViewListing.cfm">
		</cfdiv>   
		</td>
	</tr>	
	</cfif>
</table>
