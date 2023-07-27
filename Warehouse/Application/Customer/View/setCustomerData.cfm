
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
