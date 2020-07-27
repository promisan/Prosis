
<cfparam name="Attributes.DateFormatShow"  	default="#client.dateformatshow#">
<cfparam name="attributes.value"    		default="#dateformat(now(),Attributes.DateFormatShow)#">
<cfparam name="Attributes.Year"     		default="">
<cfparam name="Attributes.Status"   		default="0">
<!--- driven by the fact that MS SQL does not allow for dates earlier than 1753 --->
<cfparam name="Attributes.SQLLimit" 		default="No">

<cfparam name="Attributes.DateFormat"   	default="#APPLICATION.DateFormat#">
<cfparam name="Attributes.DateFormatSQL"   	default="#APPLICATION.DateFormatSQL#">
<cfparam name="Attributes.output" 			default="Yes">

<cfset val = replace(attributes.value,".","/","ALL")>
<cfset val = replace(val,".","/","ALL")>
<cfset val = replace(val,"-","/","ALL")>

<cfif val eq "">
  <cfset val = "01/01/1900">
</cfif>

<cfif len(val) gt 10>

	<cf_tl id="You entered an invalid date" var="invalid">

	<cfoutput>
		<script>
			alert('#invalid# : #val#. #len(val)#');
		</script>		
		<cfabort>
	</cfoutput>

</cfif>

<cfif Attributes.Status eq "1">
	
	<script language="JavaScript">
		status = "date:<cfoutput>#Attributes.Value#</cfoutput>"
	</script>

</cfif>

<cfif Attributes.DateFormat is "EU" and Attributes.DateFormatSQL eq "EU">

  <cfif mid(Attributes.Value,2,1) eq "/">
      
	       <cfset d      = '0'&left(val,1)>
           <cfif mid(Attributes.Value,4,1) eq "/">
                <cfset m      = '0'&mid(Attributes.Value,3,1)>
           <cfelse>
                <cfset m      = mid(val,3,2)>
           </cfif>
	
	   <cfelse>
	
	       <cfset d      = left(val,2)>
	       <cfif mid(val,5,1) eq "/">
	            <cfset m      = '0'&mid(val,4,1)>
	       <cfelse>
	            <cfset m      = mid(val,4,2)>
	       </cfif>
			
	   </cfif>
	  	       
	   <cfset y      = mid(val,len(val)-3,4)>

	   <cfif IsNumeric(y) is not "TRUE">
	   
	       <cfset y  = mid(val,len(val)-1,2)>
		   
		   <cfset st = FindOneOf("./-", y, 1)>
		   
		   <cfif st eq 1>
	           <cfset y      = '0'&mid(val,len(val),1)>
		   </cfif>	 
		   
		   <cfif y gte 35>
	     		 <cfset y = "19#y#"> 
		   <cfelse>
	   			 <cfset y = "20#y#"> 
		   </cfif>  
		   
	   </cfif>
	     
	   <cfset dte   = "{d '"&#y#&"-"&#m#&"-"&#d#&"'}">
	   
	   <cfif attributes.year neq "">
		   <cfset yr = #year(dte)#-#Attributes.Year#-1>
		   <cfset dte = Replace("#dte#", "#year(dte)#", "#yr#")>
	   </cfif>

<cfelseif Attributes.DateFormat is "EU" and Attributes.DateFormatSQL eq "xxxUS">

	  <cfif mid(val,2,1) eq "/">
          
		    <cfset d      = '0'&left(val,1)>
            <cfif mid(val,4,1) eq "/">
                   <cfset m      = '0'&mid(val,3,1)>
            <cfelse>
                   <cfset m      = mid(val,3,2)>
            </cfif>
	
	   <cfelse>
	
	       <cfset d      = left(val,2)>
	       <cfif mid(val,5,1) eq "/">
	               <cfset m      = '0'&mid(val,4,1)>
	       <cfelse>
	               <cfset m      = mid(val,4,2)>
	       </cfif>
		   
	   </cfif>
	   
	   <cfif len(val) lte 3>
	   
	   		<cfset dte = "">
	   
	   <cfelse>
	         
		   <cfset y      = mid(val,len(val)-3,4)>
		   	   	   
		   <cfif IsNumeric(y) is not "TRUE">
		  
		       <cfset y  = mid(val,len(val)-1,2)>
			   <cfset st = FindOneOf("./-", y, 1)>
			   <cfif st eq 1>
		           <cfset y      = '0'&mid(val,len(val),1)>
			   </cfif>	 
			   <cfif y gte 35>
		     		<cfset y = "19#y#"> 
			   <cfelse>
		   			<cfset y = "20#y#"> 
			   </cfif>  
		   </cfif>
		  	     
		   <cfset dte   = "{d '"&#y#&"-"&#m#&"-"&#d#&"'}">
		    <cfif attributes.year neq "">
			   <cfset yr = #year(dte)#-#Attributes.Year#-1>
			   <cfset dte = Replace("#dte#", "#year(dte)#", "#yr#")>
		   </cfif>
	   
	   </cfif>

<cfelseif Attributes.DateFormat is "US" and Attributes.DateFormatSQL eq "EU">

	<!--- to be tested --->

<cfelse> 

	<!--- default euro, with American server --->

	<cfif mid(Attributes.Value,2,1) eq "/">
      
	       <cfset d      = '0'&left(val,1)>
           <cfif mid(Attributes.Value,4,1) eq "/">
                <cfset m      = '0'&mid(Attributes.Value,3,1)>
           <cfelse>
                <cfset m      = mid(val,3,2)>
           </cfif>
	
	   <cfelse>
	
	       <cfset d      = left(val,2)>
	       <cfif mid(val,5,1) eq "/">
	            <cfset m      = '0'&mid(val,4,1)>
	       <cfelse>
	            <cfset m      = mid(val,4,2)>
	       </cfif>
			
	   </cfif>
	  	       
	   <cfset y      = mid(val,len(val)-3,4)>

	   <cfif IsNumeric(y) is not "TRUE">
	   
	       <cfset y  = mid(val,len(val)-1,2)>
		   
		   <cfset st = FindOneOf("./-", y, 1)>
		   
		   <cfif st eq 1>
	           <cfset y      = '0'&mid(val,len(val),1)>
		   </cfif>	 
		   
		   <cfif y gte 35>
	     		 <cfset y = "19#y#"> 
		   <cfelse>
	   			 <cfset y = "20#y#"> 
		   </cfif>  
		   
	   </cfif>
	     
	   <cfset dte   = "{d '"&#y#&"-"&#m#&"-"&#d#&"'}">
	   
	   <cfif attributes.year neq "">
		   <cfset yr = #year(dte)#-#Attributes.Year#-1>
		   <cfset dte = Replace("#dte#", "#year(dte)#", "#yr#")>
	   </cfif>

	<!---

     <cfset dte   = "{d '"&#Dateformat(val, "yyyy-mm-dd")#&"'}">
	 <cfif attributes.year neq "">
		  <cfset yr = year(dte)-Attributes.Year-1>
		  <cfset dte = Replace("#dte#", "#year(dte)#", "#yr#")>
	 </cfif>	
	 
	 --->
		 	 
</cfif>

<cfset ValidDate = true>
<cfset Numbers = Replace(dte,"'","","ALL")>
<cfset Numbers = Replace(Numbers,"{","","ALL")>
<cfset Numbers = Replace(Numbers,"}","","ALL")>
<cfset Numbers = Replace(Numbers,"d","","ALL")>
<cfset err = "">

<cfset j = 1>

<cfloop index="k" list="#Numbers#" delimiters="-">

	<cfset k = trim(k)>

	<cfswitch expression = "#j#">
	<cfcase value="1">
	<!--- year --->
		<cfset err = err & "Year: #k# ">			
		<cfif NOT IsValid("integer",k)>
			<cfset ValidDate  = false> 
			<cfbreak>	
		</cfif>
		
	</cfcase>
	<cfcase value="2">
	<!--- month --->
		<cfset err = err & "Month: #k# ">
		<cfif NOT IsValid("integer",k) or k gt 12>
			<cfset ValidDate  = false> 
			<cfbreak>	
		</cfif>	
	</cfcase>
	<cfcase value="3">
	<!--- day --->	
		<cfset err = err & "Day: #k# ">			
		<cfif NOT IsValid("integer",k) or k gt 31>
			<cfset ValidDate  = false> 
			<cfbreak>	
		</cfif>	
	</cfcase>
	</cfswitch>
	<cfset j = j + 1> 	
</cfloop>

<cfif IsDate(dte) and ValidDate>
	
	<cfif Attributes.SQLLimit eq "Yes">
	
		<cfif year(dte) gte 1753>
		
			<CFSET Caller.DateValue = dte>
			
		<cfelse>
		
			<cfif trim(lcase(Attributes.output)) eq "yes">
				<cfoutput>
					<cf_tl id="You entered a date earlier than 1753, which is not permitted" var="invalidDate">
					<script>
						alert('#invalidDate#.');
					</script>		
				</cfoutput>
			</cfif>
			<cfabort>	
		
		</cfif>
		
	<cfelse>
	
		<CFSET Caller.DateValue = dte>
	
	</cfif>
	
<cfelse>
 	 
	<cfif trim(lcase(Attributes.output)) eq "yes">
		<cfoutput>
			<cf_tl id="Detected a problem with the date" var="invalid">
			<script>
				alert('#invalid# : #err#');
			</script>		
		</cfoutput>
	</cfif>	
	
	<cfabort>	
		
</cfif>

