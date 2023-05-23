
<!--- Hanno improve performance we can move this to apply at the moment the tree is opened --->

<cfquery name="Mission"
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Mission
	WHERE  Mission = '#url.mission#'
</cfquery>

<cf_wfPending 
     EntityCode           = "VacDocument" 
	 EntityCodeIgnoreLast = "0"	
	 entityCode2          = "VacCandidate" 
	 mailfields           = "No" 
	 includeCompleted     = "No" 	 
	 Mission              = "#url.mission#"
	 Mode                 = "table"
	 Table                = "#session.acc#_#mission.MissionPrefix#_VacancyTrack">
	 
<cf_listingscript>
<cf_dialogstaffing>
<cf_layoutscript>

<cfoutput>
<script>
  
	function showdocument(vacno) {	
		  ptoken.open('#session.root#/Vactrack/Application/Document/DocumentEdit.cfm?ID=' + vacno, 'track'+vacno);
		}	
	
	</script>
	
</cfoutput>	

<cf_screentop html="No" jquery="Yes" height="100%">

<cfoutput>

<cf_layoutscript>	
	
	<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	
		
	<cf_layout attributeCollection="#attrib#">	
		   		
	    <cf_layoutarea  position="header" name="box11" collapsible = "false">
		
		   <table height="100%" width="100%" align="center">
				
			<tr>		
			    <td style="height:10px">		
				    <table width="100%">
					
						<tr>
					    <td align="left" class="labellarge" style="padding-left:20px;height:40px;font-size:34px;padding-top:4px">#URL.Mission# <font size="3">#url.orgunitname#</font></td>							
							
						<td align="right" class="fixlength" style="padding-top:10px;padding-right:10px;font-size:20px">
						Post selection date: <b>#dateformat(url.selectiondate,client.dateformatshow)#</b>
						
						</td>
																							    				
						</tr>						
										
					</table>			
			    </td>			
			</tr>	
			
			<!---
			<tr id="dBox" class="hide">		
				<td width="100%" colspan="3" id="dCriteria">
					<cfinclude template="ControlCriteria.cfm">
				</td>			
			</tr>
			--->	
			
			</table>
		
		</cf_layoutarea>
					
		<cf_layoutarea  position="top" name="box" collapsible = "true" initcollapsed="true">
		
		    <table height="100%" width="98%" align="center">			
			<tr class="line">
				<td colspan="3" valign="top" id="dDetails" style="height:100%">	
			        <cfinclude template="ControlListingPositionResult.cfm">	
				</td>
			</tr>					
			</table>					
				
		</cf_layoutarea>
		
		<cf_layoutarea  position="center" name="centerbox">		
		    
		      <table height="100%" width="98%" align="center"">					  
				<tr>
					<td colspan="2" valign="top" id="tracklistingcontent" style="height:100%">
					<cfinclude template="ControlListingPositionContent.cfm">
					</td>
				</tr>				
			  </table>			       			
		
		</cf_layoutarea>			
			
	</cf_layout>	

</cfoutput>

<!---

<cfoutput>
		
	<table style="width:100%;height:100%">	
	<tr><td style="height:600px" valign="top">
	 <cfinclude template="ControlListingPositionContent.cfm">
	 <!---
	 <cf_securediv id="content" bind="url:ControlListingPositionContent.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&hierarchycode=#url.hierarchycode#">
	 --->
	</td></tr>
	</table>

</cfoutput>

--->
