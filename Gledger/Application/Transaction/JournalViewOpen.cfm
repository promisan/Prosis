<!--- passtru template --->

<cf_screentop height="100%" scroll="Yes" html="No">

<cfoutput>

<cfif URL.ID eq "LOC">

	  <script language="JavaScript">
  		  ptoken.open('../Inquiry/TransactionView.cfm?Mission=#URL.Mission#&Period=' + parent.Period.value,'_self') 
	  </script>  

<cfelseif URL.ID eq "EVE">

	  <script language="JavaScript">
  		  ptoken.open('../Event/EventListing.cfm?systemfunctionid=#url.systemfunctionid#&Mission=#URL.Mission#&Period=' + parent.Period.value,'_self') 
	  </script>  

<cfelseif URL.ID eq "JOU">
		
	  <script language="JavaScript">	  
	     ptoken.open('Listing/ListingHeader.cfm?systemfunctionid=#url.systemfunctionid#&Mission=#URL.Mission#&OrgUnit=#URL.ID1#&Journal=#URL.ID2#&Period=' + parent.Period.value,'_self') 		
	  </script>
	  
<cfelseif URL.ID eq "PEN">
		
	  <script language="JavaScript">	  
	     ptoken.open('Journal.cfm?Mission=#URL.Mission#&OrgUnit=#URL.ID1#&Journal=#URL.ID2#&idstatus=Pending&Period=' + parent.Period.value,'_self') 		
	  </script>	  
	  
	  
<cfelseif URL.ID eq "PEW">

      <script language="JavaScript">	  
	     ptoken.open('Listing/ListingHeader.cfm?systemfunctionid=#url.systemfunctionid#&Mission=#URL.Mission#&OrgUnit=#URL.ID1#&Journal=#URL.ID2#&idstatus=Pending&Period=' + parent.Period.value,'_self') 		
	  </script>	 
		  
	  
<cfelseif URL.ID eq "OPE">
		
	  <script language="JavaScript">	  
	     ptoken.open('Listing/ListingHeader.cfm?systemfunctionid=#url.systemfunctionid#&Mission=#URL.Mission#&OrgUnit=#URL.ID1#&Journal=#URL.ID2#&idstatus=Outstanding&Period=' + parent.Period.value,'_self') 		
	  </script>	  	  
	  
<cfelseif URL.ID eq "TRA">	

	 <script language="JavaScript">
	     ptoken.open('Listing/ListingLine.cfm?systemfunctionid=#url.systemfunctionid#&Mission=#URL.Mission#&OrgUnit=#URL.ID1#&Journal=#URL.ID2#&Period=' + parent.Period.value,'_self') 
	  </script>  
	
</cfif>	

</cfoutput>

