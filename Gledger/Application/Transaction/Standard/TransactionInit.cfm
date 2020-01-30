<!--- create temp tables --->

<cf_screentop 
   height       = "100%" 
   band         = "No"    
   banner       = "blue" 
   bannerforce  = "Yes"
   html         = "yes" 
   jquery       = "Yes"
   line         = "no"
   label        = "#url.mission# Ledger Transaction" 
   systemmodule = "Accounting" 
   layout       = "webapp" 
   scroll       = "no">
   
<cfoutput>

<iframe src="TransactionPrepare.cfm?#CGI.QUERY_STRING#" 
     name="transactionbox" 
	 id="transactionbox" 
	 width="100%" 
	 height="99%" 
	 marginwidth="0" 
	 marginheight="0" 
	 scrolling="0" 
	 style="overflow-x:hidden;overflow-y:hidden"
	 frameborder="0"></iframe>
	
</cfoutput>
	

