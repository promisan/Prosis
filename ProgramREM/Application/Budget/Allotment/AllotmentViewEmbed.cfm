
<!--- used from within program maintenenace --->

<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     *
FROM  #CLIENT.LanPrefix#Program
WHERE ProgramCode = '#URL.Program#'
</cfquery>

<cf_screentop jQuery="Yes" height="100%" scroll="No" html="No" layout="innerbox" label="#Program.ProgramName#">
<cf_layoutscript>

<cfif Program.ProgramAllotment eq "0">
	<table align="center"><tr><td style="height:150px" align="center" class="labellarge">
	<font color="FF0000">This program has not been enabled for budget prepration and allotment processing <br><br>Please contact your administrator</font></td></tr></table>
    <cfabort>
</cfif>

<cf_verifyOperational module="Budget" Warning="Yes">
<cfif Operational eq "0">
  <cf_tl id="Option not enabled">
  <cfabort>
</cfif>

<cfif Program.ProgramScope eq "Global">
	 <cfoutput>
		 <cf_tl id="This option is not enabled for global programs" var="1"> 
		 <cf_message message = "#lt_text#"  return = "">
  	 </cfoutput>	  	 
	 <cfabort>
</cfif>

<cfparam name="URL.Program" default="">	

<cfset CLIENT.Sort = "OrgUnit">

<cfoutput>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	

	<cf_layout attributeCollection="#attrib#">	
		
		<cf_layoutarea  
		    position="top" 
			name="tree" 			
			maxsize="30" 
			size="30"
			minsize="30"
			overflow="hidden" 
			collapsible="true" 
			splitter="true">
			
			<cfinclude template="AllotmentViewTree.cfm">
										
		</cf_layoutarea>
		
		<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
		<cfset mid = oSecurity.gethash()/>  		
		
		<cf_layoutarea size="100%" position="center" name="box" overflow="hidden">
		
				<iframe src="AllotmentInquiry.cfm?Mode=embed&Program=#url.program#&EditionId=66&Period=#url.period#&mid=#mid#"
				     name="right" id="right" width="100%" height="100%" scrolling="no"
				     frameborder="0"></iframe>	
					
		</cf_layoutarea>			
			
	</cf_layout>

</cfoutput>

