
<cf_screentop
     layout="webapp" html="no" scroll="No" jquery="Yes">

<cf_dialogStaffing>
<cf_Listingscript>
 
<cfoutput>
	<script>
		function detail(id,id1,id2,itm) {	 
		     Prosis.busy('yes')
			_cf_loadingtexthtml='';	        
			ptoken.navigate('RecapItem.cfm?ID='+id+'&ID1='+id1+'&ID2='+id2+'&ID3='+itm+'&systemfunctionid=#url.systemfunctionid#','mainContainer')	
		}

		function listing(id,id1,id2,id3,itm) {	
		    Prosis.busy('yes')
			_cf_loadingtexthtml='';	   
			ptoken.navigate('RecapListingContent.cfm?ID='+id+'&ID1='+id1+'&ID2='+id2+'&ID3='+id3+'&ID4='+itm+'&systemfunctionid=#url.systemfunctionid#','listingcontent')	
		}
	</script>	
</cfoutput>
			
<table style="height:100%" width="99%" align="center">
<tr><td id="content" valign="top">
    <cfif url.id3 neq "">
	   <cfinclude template="RecapListing.cfm">		
	<cfelseif url.id eq "Year">   
	    <cfinclude template="RecapYear.cfm">
	<cfelse>	
	   <cfinclude template="RecapNode.cfm">
	</cfif>   
</td></tr>
</table>
				
	