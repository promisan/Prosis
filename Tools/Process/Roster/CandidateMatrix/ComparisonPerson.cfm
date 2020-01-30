
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

<table width="200" cellspacing="0" cellpadding="0" class="formpadding">

	<tr>	
		<td class="labelmedium"><b>#LastName# #FirstName# [#Age#]</b></td>
	</tr>
	
	<tr>	
	
	  <td class="labelit" style="padding-left:5px">
	  
		  <table>
		  <tr>
		  	  <td class="labelit">#dateformat(DOB,client.dateformatshow)#</td>			
		  </tr>
		  </table>
	  
	  </td>
	</tr>
	
	<tr>
		<td class="labelit" style="padding-left:5px"><cfif gender eq "M">Male<cfelse>Female</cfif></td>		
	</tr>
	
	<cfquery name="Nation" 
     datasource="AppsSystem" 
  	 username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT   *
	 FROM     Ref_Nation
	 WHERE    Code = '#Nationality#'		
	</cfquery>	
	
	<tr>	
		<td class="labelit" style="padding-left:5px">#Nation.Name#</td>
	</tr>
</table>

</cfoutput>	