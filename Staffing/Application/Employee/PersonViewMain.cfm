<!--- Create Criteria string for query from data entered thru search form --->

<cfparam name="URL.Order" default="DESC">

<cfset dependentshow = "0">

<cfajaximport tags="cfwindow,cfdiv">
<cf_FileLibraryScript>

<cf_screentop height="100%" scroll="Yes" html="No" menuAccess="context" jquery="Yes">

<table width="100%" border="0" ccellspacing="0" ccellpadding="0" align="center" class="formpadding">

<tr>
	<td height="10" style="padding-left:7px">	
	  <cfset ctr      = "1">		
	  <cfset openmode = "open"> 
	  <cfinclude template="PersonViewHeaderToggle.cfm">		  
	</td>
</tr>	

</table>
