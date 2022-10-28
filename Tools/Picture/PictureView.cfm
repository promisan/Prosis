
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

	<cfset url.width  = "700">
	<cfset url.height = "640">

</cfif>

<cfoutput>

<cfif url.mode eq "edit">
   <cfset edt = "pictureedit('#url.path#','#url.dir#','#url.filter#','#url.height#','#url.width#')">    
<cfelse>
   <cfset edt = "">			
</cfif>

<table width="100%" border="0">

<tr>

    <td align="center">
	
	 <cfif FileExists("#SESSION.rootDocumentPath#/#path#/#dir#/#filter##dir#.jpg")>			 
		
		    <cftry>
		    <cfdirectory action = "create" directory="#SESSION.rootDocumentPath#\CFRStage\EmployeePhoto"/>
			<cfcatch></cfcatch>
			</cftry>
		
    		<cffile action="COPY" 
				source="#SESSION.rootDocumentPath#/#path#/#dir#/#filter##dir#.jpg" 
 			   	destination="#SESSION.rootDocumentPath#\CFRStage\EmployeePhoto\#dir#.jpg" nameconflict="OVERWRITE">
								
	 		<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
			<cfset mid = oSecurity.gethash()/> 		
			 
			  <img src="#SESSION.root#/CFRStage/getFile.cfm?id=#dir#.jpg&mode=EmployeePhoto&mid=#mid#"
				     alt     = "Photo of #dir#"
				     border  = "0"
					 onclick = "#edt#"
				     align   = "absmiddle"
					 style   = "cursor:pointer"
					 height  = "#url.height#" 
					 width   = "#url.width#">
			  					 
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
