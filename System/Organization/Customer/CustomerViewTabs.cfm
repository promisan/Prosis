
<cf_screentop height="100%" scroll="No" jQuery="Yes" band="No" border="0" html="No" busy="busy10.gif">
 
<cfparam name="URL.mission" default="">

<cf_dialogOrganization>
<cf_dialogStaffing>
<cf_dialogWorkOrder>
<cf_ListingScript>
<cf_dialogLedger>
<cf_CustomerScript>
<cf_layoutscript>
<cf_MenuScript>

<cfajaximport tags="cfform,cfdiv">

<cfset attrib = {type="Border",name="container",fitToWindow="Yes"}>

<cfoutput>	
	<input type="hidden"  name="selecteditem"     id="selecteditem"     value="">
	<input type="hidden"  name="systemfunctionid" id="systemfunctionid" value="#url.systemfunctionid#">
</cfoutput>

<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
	   position="left"
	   name="search"					
	   source="CustomerSearch.cfm?systemfunctionid=#url.systemfunctionid#&dsn=#url.dsn#&mission=#url.mission#"	      	       
	   overflow="hidden"
	   style="border-right:1px solid ##b0b0b0;"
	   size="340" 	
	   minsize="340" 	  
	   collapsible="true"        
	   maxsize="400"
	   splitter="true"/>
	
	<cf_layoutarea position="center" style="height:100%" name="maincontainer">
			
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">										  
				  <tr id="boxlistcustomer" class="hide">
				     <td id="listcustomer" width="100%" style="height:0%; min-height:0%;"></td>
				  </tr>				  
				  <tr>
				     <td height="100%" valign="top" width="100%">
					 <cfdiv id="detail" style="height:100%; min-height:100%;">
					 	<table height="100%" width="100%">
							<tr>
								<td valign="middle">
									<cfinclude template="../../../Tools/Treeview/TreeViewInit.cfm">	
								</td>
							</tr>
						</table>
					 </cfdiv>
					 </td>
				 </tr>
			</table>			
											
	</cf_layoutarea>				
					
</cf_layout>			



