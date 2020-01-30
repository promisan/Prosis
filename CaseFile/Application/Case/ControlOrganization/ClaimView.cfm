
<cfparam name="URL.mission" default="UN">

<cfquery name="GetMission" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		 	SELECT *
			FROM   Ref_Mission
			WHERE  Mission = '#URL.Mission#'
		 
</cfquery> 

<cf_screentop height="100%" layout="innerbox" jQuery="Yes" html="No" border="0" title="Case registration #GetMission.MissionName#" menuAccess="Yes" validateSession="Yes">

	<cfinclude template="ClaimScript.cfm">
	
	<cf_layoutscript>
		
	<cfset attrib = {type="Border",name="container",fitToWindow="Yes"}>

	<cf_layout attributeCollection="#attrib#">
	   	   
	<cf_layoutarea 
          position="header"
          name="controltop"
		  source="ClaimMenu.cfm?mission=#url.mission#&systemfunctionid=#url.systemfunctionid#"/>		
	
	   <cf_tl id="Folders" var="1">

	   <cf_layoutarea 
	          position="left"
	          name="controltree"
	          source="ClaimTree.cfm?ID2=#url.mission#"	         
			  size="280"
			  minsize="280"
			  maxsize="280"          
	          overflow="auto"
	          collapsible="true"			  
	          splitter="true"/>
		
	   <cf_layoutarea  
		    position="center" 
			name="controllist">
			
			<table height="100%" width="100%">
				<tr>
					<td valign="middle">
						<cfinclude template="../../../../Tools/Treeview/TreeViewInit.cfm">	
					</td>
				</tr>
			</table> 
			
		</cf_layoutarea>	
	
	   <cf_tl id="Detail" var="1">
		
	   <cf_layoutarea
	          position="bottom"
	          name="controldetail"         
	          size="200"
			  title="#lt_text#"
			  maxsize="300"			 
	          source="ClaimDetail.cfm?id2=#url.mission#"
	          overflow="auto"
	          collapsible="true"
	          initcollapsed="true"	          
	          splitter="true"/> 
	
</cf_layout>
