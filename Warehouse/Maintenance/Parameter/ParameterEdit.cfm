
<cf_screentop height="100%" scroll="Yes" html="No">
 
<cfquery name="MissionList" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM    Ref_ParameterMission
	WHERE   Mission IN (SELECT Mission 
	                    FROM   Organization.dbo.Ref_MissionModule 
					    WHERE  SystemModule = 'Warehouse') 
</cfquery>

<!--- create detaul item lot table --->

<cfquery name="setProductionLot" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO ProductionLot (Mission,TransactionLot,TransactionLotDate,OfficerUserId,OfficerLastName,OfficerFirstName)
	SELECT Mission,
	       '0',
		   '01/01/2001',
		   '#SESSION.acc#',
		   '#SESSION.last#',
		   '#SESSION.first#' 
	
	FROM    Ref_ParameterMission P
	WHERE   Mission NOT IN (SELECT Mission 
	                        FROM   ProductionLot
							WHERE  Mission = P.Mission) 				   
</cfquery>

<cfparam name="URL.Mission" default="#MissionList.Mission#">

<cfif url.mission eq "">
	<cfset url.mission = MissionList.Mission>
</cfif>
 
<cfquery name="Get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_ParameterMission
	 WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cf_dialogAsset>
<cf_dialogOrganization>
<cf_calendarscript>

<cfinclude template="InsertData.cfm">


<script>
	 function reload(mis) {
		 window.location = "ParameterEdit.cfm?idmenu=<cfoutput>#url.idmenu#</cfoutput>&mission="+mis
	 }
</script>

<cfset Page         = "0">
<cfset add          = "0">

<cfinclude template = "../HeaderMaintain.cfm"> 		

<cfoutput query="get">

<!--- Entry form --->


<table width="96%" align="center" class="formpadding">

<tr><td height="20"></td></tr>

<cfform action="ParameterSubmit.cfm?idmenu=#URL.Idmenu#&mission=#URL.mission#"
        method="POST"
        name="parameter">
  	
	<tr><td height="5"></td></tr>
	
	<TR>
    <td colspan="3">
	
	<table width="97%" cellspacing="0" cellpadding="0" class="formpadding">
	<tr>
	<td width="100" class="labelit" style="padding-left:20px"><cf_tl id="Entity">:</td>
		<td>
		 <select name="Mission" id="Mission" class="regularxl" onchange="reload(this.value)">
		
		<cfloop query="MissionList">
		 <option value="#Mission#" <cfif mission eq "#URL.mission#">selected</cfif>>#Mission#
		</cfloop>
		
		</select>
		
		</td>
	</tr>
	
	</table>
		
	</td></tr>
	
	<tr><td height="5"></td></tr>
		
	<tr><td colspan="1">		
	
	<table width="96%" align="center"><tr><td>
	
	<tr><td height="1" class="line"></td></tr>
	
	<tr>	
	<td valign="top">
	
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
			
			<tr><td height="2"></td></tr>
			<tr><td class="labelit"><b><font color="6688aa">Attention:</td></tr>
			
			<tr><td  class="labelit"><font color="808080">
			(Non-) Expendables Setup Parameters are applied per Entity (Mission) and should <b>only</b> be changed if you are absolutely certain of their effect on the system.
			</td></tr>
				
			<tr><td  class="labelit"><font color="808080">In case you have any doubt always consult your assignated focal point.</td></tr>
			<tr><td height="3"></td></tr>
			
		</table>
		
	</td>	
	</tr>
	
	<tr><td height="1" class="line"></td></tr>
	
	<cf_menuscript>
	
	<tr>
	
	<td colspan="1" height="30" align="center">		
	
			
		<!--- top menu --->
				
		<table width="100%" height="100%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">		  		
						
			<cfset ht = "64">
			<cfset wd = "64">
			
			<cfset add = 1>
					
			<tr>					
						
					<cf_menutab item       = "1" 
					            iconsrc    = "Inventory.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								class      = "highlight1"
								name       = "Asset control">			
									
					<cf_menutab item       = "2" 
					            iconsrc    = "Warehouse.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 								
								name       = "Stock Transactions">
								
								
					<cf_menutab item       = "3" 
					            iconsrc    = "Maintenance.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 								
								name       = "Request Management">		
								
					<cf_menutab item       = "4" 
					            iconsrc    = "Supply.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 								
								name       = "Supply Tasks">						
								
													
					<td width="20%"></td>
														 		
				</tr>
		</table>
		
		</td>
		</tr>
		<tr><td class="line"></td></tr>		
		
		<tr><td height="100%">
			
			<table width="100%" 
			      border="0"
				  height="100%"
				  cellspacing="0" 
				  cellpadding="0" 
				  align="center" 
			      bordercolor="d4d4d4">	  	 		
								
					<cf_menucontainer item="1" class="regular">
					     <cfinclude template="ParameterEditAsset.cfm">		
					<cf_menucontainer>
					
					<cf_menucontainer item="2" class="hide">
					     <cfinclude template="ParameterEditStock.cfm">		
					<cf_menucontainer>
															
					<cf_menucontainer item="3" class="hide">
					     <cfinclude template="ParameterEditPortal.cfm">		
					<cf_menucontainer>
					
					<cf_menucontainer item="4" class="hide">
					     <cfinclude template="ParameterEditTasking.cfm">		
					<cf_menucontainer>
										
								
			</table>
			</td>
	</tr>				
		
	<tr><td colspan="3" class="line"></td></tr>	
	
	<tr><td colspan="3" height="35" align="center">
	
		 <input 
			mode        = "silver"
			value       = "Update" 
			class       = "button10g"
			style       = "height:28;width:170;font-size:13px"
			type        = "Submit"	
			id          = "Save"					
			width       = "170px" 					
			color       = "636334"
			fontsize    = "11px">   
		
	</td></tr>
	
	<tr><td colspan="3" class="line"></td></tr>	
	
	</table>
	
	</td></tr>
	
	</CFFORM>
				
</table>

</cfoutput>
