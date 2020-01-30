
<cfparam name="attributes.DocumentPath" default="">
<cfparam name="attributes.subdirectory" default="">
<cfparam name="attributes.filter"       default="Picture_">
<cfparam name="attributes.width"        default="120">
<cfparam name="attributes.height"       default="150">
<cfparam name="attributes.mode"         default="view">

<cfparam name="url.path"     default="#attributes.documentpath#">
<cfparam name="url.dir"      default="#attributes.subdirectory#">
<cfparam name="url.filter"   default="#attributes.filter#">
<cfparam name="url.width"    default="#attributes.width#">
<cfparam name="url.height"   default="#attributes.height#">
<cfparam name="url.mode"     default="#attributes.mode#">
<cfparam name="url.scope"   default="view">

<cfif url.scope eq "DIALOG">

	<cfset url.width = "700">
	<cfset url.height = "540">

</cfif>

<cfoutput>


<cfif url.mode eq "edit">

   <cfset edt = "pictureedit('#url.path#','#url.dir#','#url.filter#','#url.width#','#url.height#')">
    
<cfelse>

	<cfset edt = "">
			
</cfif>

<table width="100%" cellspacing="0" cellpadding="0" border="0">

<tr>

    <td align="center">
	
	 <cfif FileExists("#SESSION.rootDocumentPath#/#path#/#dir#/#filter##dir#.jpg")>		 
		 		   						
			  <cf_assignid>
						
			  <cfif url.width neq "0">		
			  		  										
				  <img src="#SESSION.rootDocument#/#path#/#dir#/#filter##dir#.jpg?id=#rowguid#"
					     alt=""
						 style="cursor:pointer"
						 onclick="#edt#"
					     height="#url.height#" width="#url.width#"
					     border="0"
					     align="absmiddle">
					 
			  <cfelse>
			  
			    <img src="#SESSION.rootDocument#/#path#/#dir#/#filter##dir#.jpg?id=#rowguid#" height="#url.height#" width="#url.width#"
				     alt="" border="0" align="absmiddle" style="cursor:pointer"
						 onclick="#edt#">
			  
			  </cfif>	
			  					 
  	 <cfelse>		 
				
	  <img src="#SESSION.root#\Images\logos\no-picture-male.png" 
			 title="Picture" name="EmployeePhoto"  
			 id="EmployeePhoto" 
			 width="130" style="cursor:pointer"
						 onclick="#edt#"
			 height="#url.Height#" 
			 align="absmiddle"> 
					
			  
	 </cfif>
</td>

</tr>

</table>	
 
</cfoutput>	 
