<!--- adjust the prepared query for reserved words used in the query --->

<!--- temp table to be use from the preparation query --->
<cfloop index="t" from="1" to="10">		
		<cfset sc = replaceNoCase("#sc#","@answer#t#","#evaluate('answer#t#')#")>  					  
</cfloop>
		
<!--- user name --->		
<cfset sc = replaceNoCase("#sc#","@user","#SESSION.acc#","ALL")> 	

<cfparam name="url.mission" default="">
<!--- mission added 29/7/2013 --->		
<cfset sc = replaceNoCase("#sc#","@mission","#url.mission#","ALL")> 							


<!--- today --->
<cfloop index="itm" from="1" to="30">
    
	<cfif itm lt 10>
	   <cfset d = "0#itm#">
	<cfelse>
	   <cfset d = "#itm#">
	</cfif>  
	 
	<cfset sc = replaceNoCase("#sc#","@today-#d#","#dateformat(now()-itm,client.dateSQL)#","ALL")>	
</cfloop>

<cfset sc = replaceNoCase("#sc#","@today","#dateformat(now(),client.dateSQL)#","ALL")>		
	
<!--- now() --->	
<cfset sc = replaceNoCase("#sc#","@now","#dateformat(now(),client.dateSQL)# #timeformat(now(),'HH:MM:SS')#","ALL")>