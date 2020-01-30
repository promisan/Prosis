
<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM  #CLIENT.LanPrefix#Program
	WHERE ProgramCode = '#URL.Program#' 
</cfquery>

<cf_screentop height="100%" scroll="No" jQuery="Yes" layout="innerbox" html="No" border="0" label="#Program.ProgramName#">

<cf_layoutscript>

<cfif Program.ProgramAllotment eq "0">
	<table align="center"><tr><td style="height:150px" align="center" class="labellarge">
	<font color="FF0000">This program has not been enabled for budget preparation / allotment processing <br><br>Please contact your administrator</font></td></tr></table>
    <cfabort>
</cfif>

<cf_verifyOperational module="Budget" Warning="Yes">
<cfif Operational eq "0">
  <cfabort>
</cfif>

<!--- disabled 11/5/2009 
<cfif Program.ProgramScope eq "Global">
 <cf_message message = "This option is not enabled for global programs"
  return = "">
  <cfabort>
</cfif>
--->

<cfparam name="URL.Program" default="">	

<cfset CLIENT.Sort = "OrgUnit">

<cfoutput>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

<cf_layout attributeCollection="#attrib#">	
	
	<cf_layoutarea  position="top" name="tree" maxsize="30" size="30" overflow="hidden" collapsible="true" splitter="true">
	    
		    <cfinclude template="AllotmentViewTree.cfm">
				
	</cf_layoutarea>
	
	<cf_layoutarea  position="center" name="box">
		
			<iframe src="../../../../Tools/Treeview/TreeViewInit.cfm"
		     name="right" id="right" width="100%" height="100%" scrolling="no"
		     frameborder="0"></iframe>	
				
	</cf_layoutarea>			
			
</cf_layout>

</cfoutput>
