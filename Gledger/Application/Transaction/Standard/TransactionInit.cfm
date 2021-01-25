<!--- create temp tables --->

<cf_tl id="Add" var="1">

<cf_screentop 
   height       = "100%" 
   band         = "No"    
   banner       = "blue" 
   bannerforce  = "Yes"
   html         = "yes" 
   jquery       = "Yes"
   line         = "no"
   label        = "#lt_text#: #url.mission#/#url.Journal#" 
   systemmodule = "Accounting" 
   layout       = "webapp" 
   scroll       = "no">
   
<cfoutput>

<iframe src="TransactionPrepare.cfm?#CGI.QUERY_STRING#" 
	     name="transactionbox" 
		 id="transactionbox" 
		 width="100%" 
		 height="100%" 		
		 style="overflow-x:hidden;overflow-y:hidden"
		 frameborder="0"></iframe>
	
</cfoutput>
	

