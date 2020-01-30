
<cfoutput>

<cfif url.reviewid eq "undefined">
	  
	  <script>
	  document.getElementById("line#url.templateid#").style.backgroundColor = "yellow"
	  </script>
	  	
	  <cfabort>
</cfif>

<cfquery name="Check" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   SiteVersionReview
	   WHERE  ReviewId = '#url.reviewid#'
</cfquery>	

<!--- determine of this template may be deployed --->

<cfif check.actionStatus eq "3">
  	  <script>	  
	  document.getElementById("line#url.templateid#").style.backgroundColor = "##C9F5D2"
	  </script>
<cfelseif check.actionStatus eq "2">	  
	  <script>	 
	  document.getElementById("line#url.templateid#").style.backgroundColor = "yellow"
	  </script>
<cfelseif check.actionStatus eq "1">	  
	  <script>	 
	  document.getElementById("line#url.templateid#").style.backgroundColor = "yellow"
	  </script>
<cfelseif check.actionStatus eq "0">	  
	  <script>	  
	  document.getElementById("line#url.templateid#").style.backgroundColor = "white"
	  </script>	 
</cfif>	

<cfif Check.actionStatus eq "3">

 <img onclick="deployclient('#url.templateId#','#url.TemplateCompareId#','#Check.destinationserver#','#check.reviewid#')" 
         src="#SESSION.root#/Images/refresh4.gif" 
		 alt="Deploy template on #check.destinationserver# with master copy." 
		 border="0" 
		 align="absmiddle" 
		 style="cursor: pointer;">&nbsp;	
		 							 
	<a href="javascript:deployclient('#url.templateId#','#url.TemplateCompareId#','#Check.destinationserver#','#check.reviewid#')" 
	     title="Deploy template on #check.destinationserver# with master copy.">Deploy</a>

</cfif>

</cfoutput>
							