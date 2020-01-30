
<!--- year, month, moments --->

<cfquery name="Year" 
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT   DISTINCT YEAR(Created) as Year
      FROM     ReportBatchLog
	  WHERE    ProcessClass != 'Trial'
	  AND      YEAR(Created) >= '#year(now())#'	  
	  ORDER BY Year DESC
</cfquery>

<cftree name="root"
	   font="calibri"
	   fontsize="12"		
	   bold="No"   
	   format="html"    
	   required="No">  	

	<cfoutput>
	
	  <cfloop query="Year">
	  
	  <cfif YEAR(now())>
	      <cfset exp = "Yes">
	  <cfelse>
	      <cfset exp = "No"> 
	  </cfif>
	  
	  <cftreeitem value="#year#"
		   display="<font face='Calibri' size='4'><b>#Year#"
		   parent="Root"					
		   expand="#exp#">		
	    
	     <cfset yr = year>
	    
		 <cfquery name="Month" 
		  datasource="AppsSystem" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		      SELECT   DISTINCT Month(Created) as Month 
		      FROM     ReportBatchLog
			  WHERE    YEAR(Created) = #yr#
			  AND      ProcessClass != 'Trial'
			  ORDER BY Month DESC
		 </cfquery>
		  	         	   	  	  
		 <cfloop query="Month">
		 
		    <cfset mt  = Month.Month>
		    <cfset mtS = monthAsString(Month.Month)>
			
			<cftreeitem value="#yr##mts#"
		        display="<font face='Calibri' size='3'>#mtS#</font>"
				parent="#yr#"					
		        expand="No">		
				
			 <cfquery name="Date" 
		    datasource="AppsSystem" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		      SELECT DISTINCT DAY(Created) as DAY
		      FROM ReportBatchLog
			  WHERE YEAR(Created) = #yr#
			  AND MONTH(Created) = #mt#
			  AND    ProcessClass != 'Trial'
			  ORDER BY DAY DESC
		   </cfquery>	
		   
		    <cfloop query="Date">
			
			    <cfset dy   = Date.Day>
									
			    <cfquery name="Check" 
			    datasource="AppsSystem" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			      SELECT *
			      FROM ReportBatchLog
				  WHERE YEAR(Created) = #yr#
				  AND MONTH(Created) = #mt#
				  AND DAY(Created) = #dy#
				  AND    ProcessClass != 'Trial'
			   </cfquery>	
			   
			    <cfif len(dy) eq "1">
				  <cfset dy = "0#dy#">
				</cfif>
			   		    
				<cfset dyS  = dayOfWeek(Check.Created)>
				<cfset dyS  = dayOfWeekAsString(dyS)>
			   
			   <cfif Check.recordcount eq "1">	
			   
				   	<cftreeitem value="#yr##mts##dy#"
		            display="<font face='Calibri' size='2'>#dy# [#dys#]</font>"
		            parent="#yr##mts#"
					target="right"
		            href="DistributionLog.cfm?ID=#Check.BatchId#"
		            queryasroot="No"
		            expand="No">	    
			  			
				<cfelse>
				
						<cftreeitem value="#yr##mts##dy#"
		            display="#dy# [#dys#]"
		            parent="#yr##mts#"
					target="right"
		            href="DistributionLog.cfm?ID=#Check.BatchId#"
		            queryasroot="No"
		            expand="No">	  
												
					<cfloop query="Check">
					
						<cftreeitem value="#yr##mts##dy#_#currentrow#"
		            display="#timeformat(ProcessEnd, "HH:MM")#"
		            parent="#yr##mts##dy#"
					target="right"
		            href="DistributionLog.cfm?ID=#Check.BatchId#"
		            queryasroot="No"
		            expand="No">	  
									
					</cfloop>
				
				</cfif>
			
			</cfloop>  
			
			</cfloop>  
						   
		   </cfloop>  
		   		 
	</cfoutput>

</cftree>




