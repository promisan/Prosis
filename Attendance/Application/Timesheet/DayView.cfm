<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="url.date" default="01/01/2010">
<cfparam name="url.id" default="1000">
<cfparam name="url.mode" default="view">

<cfoutput>

<cfif url.mode eq "view">
	
	<table width="98%" height="100%" align="center">
	
	<tr><td id="list" style="height:100%;min-width:100%">		
		<cfinclude template="DayViewListing.cfm">
	</td></tr>
	
	
	</table>

<cfelse>

	<!--- print mode 

	<cfoutput>
	
	<cfset dateob  = CreateDate(URL.startyear,URL.startmonth,1)>
	<cfset thedate = Createdate(URL.startyear, URL.startmonth, url.day)>
	<cfset url.date = dateFormat(thedate,CLIENT.DateFormatShow)>

	<head>
		<title>Portal</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />		
		<link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 	
	</head>
	</cfoutput>
	<br>
		
	<table width="93%" align="center" border="0" cellspacing="0" cellpadding="0">
	
	<tr><td>
	
		<cfquery name="Employee" 
		         datasource="AppsEmployee" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
	             SELECT *
	             FROM   Person
	             WHERE  PersonNo = '#URL.ID#'
	    </cfquery>      
	      	
	    <cfif Employee.recordcount eq "0">         
	         
	         <cfquery name="Employee" 
			     datasource="AppsEmployee" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
	               	SELECT *
	                FROM   Person
	                WHERE  PersonNo = '#URL.ID1#'
	         </cfquery>      	
	         	            
	         <cfif Employee.recordcount eq "0">                      
	            	
	            <cfquery name  = "Employee" 
				     datasource= "AppsEmployee" 
					 username  = "#SESSION.login#" 
					 password  = "#SESSION.dbpw#">               
		               	SELECT TOP 1*
	               	    FROM   Person
	               	    WHERE  IndexNo = '#URL.ID#'
	            </cfquery>
	                	            	            
	            <cfset URL.ID = "#Employee.PersonNo#">
		
	         </cfif>         
	         
	    </cfif>  
		  
		<font size="4" color="black"><cfoutput>#Employee.FirstName# #Employee.LastName#</cfoutput></font>    
	
	</td></tr>
	
	<tr><td class="line"></td></tr>
	
	<tr><td id="list">	
			<cfinclude template="DayViewListing.cfm">
	</td></tr>
	
	</table>
	
	<script>
	    window.print()
	</script>
	
	--->
		
</cfif>


</cfoutput>

