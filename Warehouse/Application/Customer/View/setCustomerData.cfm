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
<cfparam name="url.mode"       default="ajax">
<cfparam name="url.scope"      default="customer">
<cfparam name="url.scopeid"    default="">
<cfparam name="url.field"      default="">
<cfparam name="url.value"      default="%">
<cfparam name="url.input"      default="">

<cfif url.input eq "" or url.input eq "undefined">
	<cfset inputfield = "#url.field#_#url.scopeid#">
<cfelse>
    <cfset inputfield = "#url.input#">
</cfif>

<cfset val = url.value> 

<cfswitch expression="#url.field#">

	<cfcase value="customerdob">	
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#val#">
		<cfset DTE = dateValue>		
	
	    <cfif val eq "">
		    <cfset result = "1">
		<cfelseif not isValid("date",dte)>		
			<cfset result = "0">				
		<cfelse>		
			<cfset result = "1">		
		</cfif> 
		
		<cfset val = dateformat(dte,client.dateSQL)>
	
	</cfcase>
	
	<cfcase value="emailaddress">	
	
	    <cfif val eq "">
		    <cfset result = "1">
		<cfelseif not isValid("email",val)>		
			<cfset result = "0">				
		<cfelse>		
			<cfset result = "1">		
		</cfif> 
	
	</cfcase>
	
	<cfcase value="phonenumber">
	
		<cfinvoke component = "Service.Process.System.RegEx"  
		   method           = "Customer" 
		   scope            = "#url.scope#" 
		   scopeid          = "#url.scopeid#" 
		   element          = "PhoneNumber" 
		   returnvariable   = "regex">	
		
		<!--- obtain regex otherwise we take default --->
		
		<cfif val eq "">
		
		    <cfset result = "1">
		
		<cfelse>
										
			<cfif regex neq "">
				
				<cfif val eq "">
				    <cfset result = "1">
				<cfelseif not isValid("regex",val,regex)>				
					<cfset result = "0">											
				<cfelse>				
					<cfset result = "1">						
				</cfif> 
			
			<cfelse>	
	
				<cfif val eq "">
				    <cfset result = "1">
				<cfelseif not isValid("telephone",val)>				
					<cfset result = "0">			
				<cfelse>				
					<cfset result = "1">		
				</cfif> 
				
			</cfif>	
		
		</cfif>
	
	</cfcase>
	
	<cfcase value="mobilenumber">
	
		<cfinvoke component = "Service.Process.System.RegEx"  
		   method           = "Customer" 
		   scope            = "#url.scope#" 
		   scopeid          = "#url.scopeid#" 
		   element          = "MobileNumber" 
		   returnvariable   = "regex">	
		   
		<cfif val eq "">		
		    <cfset result = "1">			
		<cfelse>    
		   
			<cfif regex neq "">									
				<cfif not isValid("regex",val,regex)>				
					<cfset result = "0">											
				<cfelse>				
					<cfset result = "1">						
				</cfif> 			
			<cfelse>				
				<cfif not isValid("telephone",val)>		
					<cfset result = "0">			
				<cfelse>		
					<cfset result = "1">				
				</cfif> 				
			</cfif>	
			
		</cfif>	
	
	</cfcase>
	
	<cfdefaultcase>
		
		<cfset result = "1">				
		 	
	</cfdefaultcase>

</cfswitch>
		
<cfoutput>

<cfif result eq "1">
		
	<script>
		se = document.getElementById('#inputfield#')					
		if (se) {
			se.style.backgroundColor = "white"		
		}	
	</script>
	
	<cfif url.mode eq "ajax" and url.scope eq "customer">
			
		<cfquery name="UpdateCustomer" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				 UPDATE Customer
				 SET    #url.field#   = '#val#'
				 WHERE  CustomerId   = '#URL.scopeid#'	    					   
		</cfquery>
	
	</cfif>
				
<cfelse>
	
	<script>		
		se = document.getElementById('#inputfield#')		
		if (se) {
		se.style.backgroundColor = "FF8080"
		}
	</script>			

</cfif>

</cfoutput>
