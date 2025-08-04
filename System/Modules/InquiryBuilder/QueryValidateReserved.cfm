<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<!--- adjust the prepared query for reserved words used in the query --->

<!--- temp table to be use from the preparation query --->
<cfloop index="t" from="1" to="10">		
		<cfset sc = replaceNoCase("#sc#","@answer#t#","#evaluate('answer#t#')#")>  					  
</cfloop>
		
<!--- user name --->		
<cfset sc = replaceNoCase("#sc#","@user","#SESSION.acc#","ALL")> 	

<cfparam name="url.mission" default="">
<!--- mission added 29/7/2013 --->		
<cfif url.mission neq "">
	<cfset sc = replaceNoCase("#sc#","@mission","#url.mission#","ALL")> 	
<cfelse>
    <cfset sc = replaceNoCase("#sc#","@mission","","ALL")>   
</cfif>

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