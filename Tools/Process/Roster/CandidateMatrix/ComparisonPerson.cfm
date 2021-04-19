
<cfoutput>
	
 <cfif dob neq "">
	 
	 <cfset age =  year(now()) - year(DOB)>
	 <cfif dayOfYear(DOB) gt dayOfYear(Now())>
	  <cfset age = age-1>
	 </cfif>
	 
	 <cfif age gte "90">
	 
		 <cfset age = "">
		 
	 <cfelse>
	 
		 <cfset age = "#age#">
	 
	 </cfif>			 
	 
 <cfelse>
 
 	<cfset age = "">
 	 
 </cfif>	 

<table style="width:100%" class="formpadding">

	<tr><td class="labelmedium"><b>#LastName# #FirstName# [#Age#]</b></td></tr>
	
	<cfquery name="Nation" 
     datasource="AppsSystem" 
  	 username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT   *
	 FROM     Ref_Nation
	 WHERE    Code = '#Nationality#'		
	</cfquery>	
	
	<tr>	
	
	  <td style="padding-left:5px">
	  
		  <table style="width:100%">
		  <tr class="labelmedium2">
		  	  <td>#dateformat(DOB,client.dateformatshow)#</td>		
			  <td style="padding-left:5px"><cfif gender eq "M">Male<cfelse>Female</cfif></td>	
			  <td align="right" style="padding-right:2px">#Nation.Name#</td>		
		  </tr>
		  </table>
	  
	  </td>
	</tr>
	
</table>

</cfoutput>	