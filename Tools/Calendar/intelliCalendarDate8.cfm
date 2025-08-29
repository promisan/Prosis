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
<cfparam name="Attributes.AllowBlank" 		default="True">
<cfparam name="Attributes.Script"     		default="">	
<cfparam name="Attributes.Style"      		default="">	
<cfparam name="Attributes.Class"      		default="regular">	
<cfparam name="Attributes.fldid"      		default="#Attributes.fieldname#">	
<cfparam name="Attributes.Calendar"   		default="show">	
<cfparam name="attributes.ValidationScript" default="No">	

<cfset mask = "99/99/9999">

<cfif attributes.allowblank eq "false">
   <cfset req = "Yes">	  
<cfelse>
   <cfset req = "No">	
</cfif>

<cfif Attributes.Default eq "0">
	<cfset Attributes.Default = "TODAY">
</cfif>

<cfif Attributes.Default eq "TODAY">
      <cfset Attributes.default = #Dateformat(now(), CLIENT.DateFormatShow)#>
</cfif>

<cfparam name="Attributes.tooltip" default="Enter Date">
<cfparam name="Attributes.default" default="today">

<!--- received default value for calendar --->

<cfset def = Attributes.Default>

<cfif attributes.ValidationScript eq "yes">
	<cfset vValidationScript = "javascript: validateDate(this, '#req#', 0);">
<cfelse>	
	<cfset vValidationScript = "">
</cfif>

<cfif attributes.calendar eq "show">

	<!--- this function expects delivery of the default in the US format, however Prosis delivers this in the
	format of CLIENT.DateFormatShow as defined.	So the below routine will make a conversion.
	--->
	
	<cfquery name="Dformat" 
	   	 datasource="AppsSystem" 
		 maxrows=1>
		 SELECT *
		 FROM Parameter
	</cfquery>	
																
	<cfif dformat.DateFormat eq dFormat.DateFormatSQL>
			
		   <!--- do nothing, SQL will understand --->
											
	<cfelse>		
	
		<cftry>					
															
		<!--- reverse --->
		<cfif mid(def,2,1) eq "/">
	            <cfset d      = '0'&left(#def#,1)>
				
	            <cfif mid(#val.Value#,4,1) eq "/">
	                 <cfset m      = '0'&mid(#def#,3,1)>
	            <cfelse>
	                 <cfset m      = mid(#def#,3,2)>
	            </cfif>
		<cfelse>
	           <cfset d      = left(#def#,2)>
			   <cfif mid(#def#,5,1) eq "/">
	                 <cfset m      = '0'&mid(#def#,4,1)>
	           <cfelse>
	                 <cfset m      = mid(#def#,4,2)>
	           </cfif>
		</cfif>
	         
		<cfset y      = mid(#def#,len(#def#)-1,2)>
	   	<cfset st = FindOneOf("./-", #y#, 1)>
	   	<cfif st eq 1>
	         <cfset y      = '0'&mid(#def#,len(#def#),1)>
	    </cfif>
	   
		<cfif y gte 20>
		    <cfset y = "19"&#y#> 
		<cfelse>
		  	<cfset y = "20"&#y#> 
		</cfif>
	   
		<cfset def   = "#d#/#m#/#y#">
		
		<cfcatch>
				
		<cfset def = Attributes.Default>
		
		</cfcatch>
		
		</cftry>
											
	</cfif>		

	<!--- mask caused conversion of dates --->
	
	<cfset mask = "yyyy-MM-dd">
	
	<table cellspacing="0" cellpadding="0"><tr><td>
	
	<cfif attributes.tooltip neq "">
		
		<cfinput type = "DateField"
		   id         = "#Attributes.FieldName#"
    	   name       = "#Attributes.FieldName#"
	       message    = "Problem with #Attributes.FieldName# format #CLIENT.DateFormatShow#"	   
    	   validate   = "eurodate"
	       required   = "#req#"	  
		   mask       = "#Mask#" 
		   value      = "#def#"	  
    	   size       = "10"	  	   
		   onchange   = "#Attributes.script#"
    	   visible    = "Yes"
	       enabled    = "Yes"
    	   tooltip    = "#Attributes.ToolTip#"
	       class      = "#Attributes.Class#"
    	   style      = "text-align:center;#attributes.style#"
		   onblur     = "#vValidationScript#">
	   
	   <cfelse>	   
	   	   
	   <cfinput type = "DateField"
		   id         = "#Attributes.FieldName#"
    	   name       = "#Attributes.FieldName#"
	       message    = "Problem with #Attributes.FieldName# format #CLIENT.DateFormatShow#"	   
    	   validate   = "eurodate"
	       required   = "#req#"	  
		   mask       = "#Mask#" 
		   value      = "#def#"	  
    	   size       = "10"	  	   
		   onchange   = "#Attributes.script#"
	       visible    = "Yes"
	       enabled    = "Yes"       
	       class      = "#Attributes.Class#"
	       style      = "text-align:center;#attributes.style#"
		   onblur     = "#vValidationScript#">
	   
	   
	   
	   </cfif>
	   
	   </td></tr></table>	
	   
<cfelse>

	<cfset mask = "99/99/9999">
	
	<cfif attributes.tooltip neq "">
	
	<cfinput type     = "Text" 
       name       = "#Attributes.FieldName#"
       message    = "Problem with #Attributes.FieldName# format #Mask#"
       validate   = "eurodate"
       required   = "#req#"
	   value      = "#def#"	 
	   mask       = "#Mask#"  
       size       = "10"
	   onchange   = "#Attributes.script#"
       visible    = "Yes"
       enabled    = "Yes"
       tooltip    = "#Attributes.ToolTip#"
       class      = "#Attributes.Class#"
       style      = "text-align:center;#attributes.style#"
	   onblur     = "#vValidationScript#">  
	   
	  <cfelse>
	  
	  <cfinput type     = "Text" 
       name       = "#Attributes.FieldName#"
       message    = "Problem with #Attributes.FieldName# format #Mask#"
       validate   = "eurodate"
       required   = "#req#"
	   value      = "#def#"	 
	   mask       = "#Mask#"  
       size       = "10"
	   onchange   = "#Attributes.script#"
       visible    = "Yes"
       enabled    = "Yes"       
       class      = "#Attributes.Class#"
       style      = "text-align:center;#attributes.style#"
	   onblur     = "#vValidationScript#">  
	  
	  </cfif> 

</cfif>