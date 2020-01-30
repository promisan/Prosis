<cfquery name="ServiceItem" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   ServiceItem
		WHERE  Code = '#URL.ID2#'		
</cfquery>


<cf_screentop 
	height="100%" 
	label="Item Tab Order #serviceitem.description#" 
	option="Service Item Tab Maintenance [#url.id2#]" 
	jquery="yes"
	scroll="Yes" 
	close="parent.ColdFusion.Window.destroy('mydialog',true)"
	layout="webapp" 
	banner="yellow">

	<script language="JavaScript">
		
		function ask() {
			if (confirm("Do you want to remove this record ?")) {
			
			return true 
			
			}
			
			return false
			
		}
		
	
	</script>
	
	<cfquery name="Get" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	ServiceItemTab
		WHERE  	mission = '#URL.ID1#'
		AND 	code = '#URL.ID2#'
		<cfif url.id3 eq "">
		AND    	1 = 0
		<cfelse>
		AND    	tabName = '#URL.ID3#'
		</cfif>	
	</cfquery>	 	

	<table class="hide">
		<tr ><td><iframe name="tabprocess" id="tabprocess" frameborder="0"></iframe></td></tr>
	</table>
	
	
<CFFORM action="ServiceItemTabSubmit.cfm" target="tabprocess" method="post" name="formunittab">
	
	<!--- edit form --->
	<table width="94%" cellspacing="3" cellpadding="2" align="center" class="formpadding formspacing">		
	
		 <cfoutput>
		 
		 <cfinput type="Hidden" name="code"    value="#URL.ID2#">		 
		 <cfinput type="Hidden" name="missionOld"    value="#URL.ID1#">	
		 <cfinput type="Hidden" name="tabNameOld"    value="#URL.ID3#">	
		
		 <tr><td></td></tr>		 
		 <!--- Field: Mission --->
		 <TR class="labelmedium">
			 <TD>Mission *:&nbsp;</b></TD>  
			 <TD>
			 	<cfquery name="getLookup" 
					datasource="AppsWorkorder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM Ref_ParameterMission
					WHERE    Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE SystemModule = 'WorkOrder')
					</cfquery>
					
				<select name="mission" id="mission" class="regularxl">
					<cfloop query="getLookup">
					  <option value="#getLookup.mission#" <cfif get.mission eq getLookup.mission>selected</cfif>>#getLookup.mission#</option>
				  	</cfloop>
				</select>	
			 </TD>			 
		 </TR>
		 
		 <!--- Field: tabName --->
		 <TR class="labelmedium">
			 <TD>Tab Label *:&nbsp;</b></TD>  
			 <TD>
			 	<cfinput type="Text" name="tabName" value="#get.tabName#" message="Please enter a Tab Name" required="Yes" size="50" maxlength="50" class="regularxl">
			 </TD>
		 </TR>
		 
		 <!--- Field: tabOrder --->
		 <TR class="labelmedium">
			 <TD>Tab Order:&nbsp;</TD>  
			 <TD>
			 	<cfinput type="Text" name="tabOrder" value="#get.tabOrder#" message="Please enter a numeric Tab Order" validate="integer" required="No" size="3" maxlength="3" class="regularxl">
			 </TD>
		 </TR>
		 
		 <!--- Field: tabIcon --->
		 <TR class="labelmedium">
			 <TD>Icon:&nbsp;</TD>  
			 <TD>
			    #SESSION.root#/Images/
			 	<cfset iconDirectory = "Images/">
				
			 	<cfinput type="Text" 
					name="tabIcon" 
					value="#get.tabIcon#" 
					message="Please enter a Tab Icon" 
					onblur= "ColdFusion.navigate('CollectionTemplate.cfm?template=#iconDirectory#'+this.value+'&container=iconValidationDiv&resultField=validateIcon','iconValidationDiv')"
					required="No" 
					size="50" 
					maxlength="60" 
					class="regularxl">										
			 </TD>
			 <td valign="middle">
			 	<cfdiv id="iconValidationDiv" bind="url:CollectionTemplate.cfm?template=#iconDirectory##get.tabIcon#&container=iconValidationDiv&resultField=validateIcon">				
			 </td>
		 </TR>
		 		 
		 <!--- Field: tabTemplate --->
		 <TR class="labelmedium">
			 <TD>Template Content:&nbsp;</TD>  
			 <TD>
			 	#SESSION.root#/WorkOrder/Application/WorkOrder
			 	<cfset templateDirectory = "Workorder/Application/WorkOrder/">
				
			 	<cfinput type="Text" 
					name="tabTemplate" 
					value="#get.tabTemplate#" 
					message="Please enter a Tab Template" 
					onblur= "ColdFusion.navigate('CollectionTemplate.cfm?template=#templateDirectory#'+this.value+'&container=templateValidationDiv&resultField=validateTemplate','templateValidationDiv')"
					required="No" 
					size="30" 
					maxlength="60" 
					class="regularxl">										
			 </TD>
			 <td valign="middle">
			 	<cfdiv id="templateValidationDiv" bind="url:CollectionTemplate.cfm?template=#templateDirectory##get.tabTemplate#&container=templateValidationDiv&resultField=validateTemplate">				
			 </td>
		 </TR>
		 
		  <!--- Field: modeOpen --->
		 <TR class="labelmedium">
			 <TD>Open Mode *:&nbsp;</TD>  
			 <TD>
			 	<select name="modeOpen" id="modeOpen" class="regularxl">
					<option value="Embed" <cfif get.modeOpen eq "Embed">selected</cfif>>Embed</option>
					<option value="Bind" <cfif get.modeOpen eq "Bind">selected</cfif>>Bind</option>
				</select>
			 </TD>
		 </TR>
		 
		 
		 <!--- Field: accessLevelRead --->
		 <TR class="labelmedium">
			 <TD>Read Level *:&nbsp;</TD>  
			 <TD>
			  <table><tr class="labelmedium">
			  <td>
			 	<input type="radio" class="radiol" name="accessLevelRead" id="accessLevelRead" value="0" <cfif get.accessLevelRead eq "0">checked</cfif>></td>
				<td style="padding-left:4px">No</td>
				<td style="padding-left:7px">
				<input type="radio" class="radiol" name="accessLevelRead" id="accessLevelRead" value="1" <cfif get.accessLevelRead eq "1" or url.id3 eq "">checked</cfif>>
				</td>
				<td style="padding-left:4px">Yes</td>					
				</td>			  
			  </tr></table>
			 </TD>
		 </TR>
		 
		 <!--- Field: accessLevelEdit --->
		 <TR class="labelmedium">
			 <TD>Edit Level *:&nbsp;</TD>  
			 <TD>
			 <table><tr class="labelmedium">
			  <td>
			 	<input type="radio" class="radiol" name="accessLevelEdit" id="accessLevelEdit" value="0" <cfif get.accessLevelEdit eq "0">checked</cfif>></td>
				<td style="padding-left:4px">No</td>
				<td style="padding-left:7px">
				<input type="radio" class="radiol" name="accessLevelEdit" id="accessLevelEdit" value="1" <cfif get.accessLevelEdit eq "1" or url.id3 eq "">checked</cfif>>
				</td>
				<td style="padding-left:4px">Yes</td>					
				</td>			  
			  </tr></table>
			 </TD>
		 </TR>
		 
		
		 <!--- Field: Operational --->
		 <TR class="labelmedium">
			 <TD>Operational *:&nbsp;</TD>  
			 <TD>
			 <table><tr class="labelmedium">
			  <td>
			 	<input type="radio" class="radiol" name="Operational" id="Operational" value="0" <cfif get.Operational eq "0">checked</cfif>></td>
				<td style="padding-left:4px">No</td>
				<td style="padding-left:7px">
				<input type="radio" class="radiol" name="Operational" id="Operational" value="1" <cfif get.Operational eq "1" or url.id3 eq "">checked</cfif>>
				</td>
				<td style="padding-left:4px">Yes</td>					
				</td>			  
			  </tr></table>
		 </td>
		 </TR>
		 		
		<tr><td height="6"></td></tr>
		<tr><td colspan="4" class="line"></td></tr>
		<tr><td height="6"></td></tr>
		
		<tr><td colspan="4" align="center" height="30">
		
		<cfif url.id3 eq "">				
		
			<input class="button10g" type="submit" name="Save" id="Save" value="Save">
			
		<cfelse>			
			<input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()">			
			<input class="button10g" type="submit" name="Update" id="Update" value="Update">
		
		</cfif>
		
		
		</td></tr>
		
	</cfoutput>
	    	
</TABLE>

</CFFORM>