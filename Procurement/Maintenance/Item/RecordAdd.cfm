<cf_textareascript>

<cf_screentop  layout="webapp" html="No" JQuery="Yes" height="100%" scroll="Yes" >
  
<cfparam name="URL.Mode"     default="entry">
<cfparam name="URL.Mission"  default="">
<cfparam name="URL.Period"   default="">
<cfparam name="URL.Object"   default="">

<cfquery name="Param" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Parameter
</cfquery>

<!--- add form --->

<CFFORM action="RecordSubmit.cfm?object=#url.object#" method="post" name="dialog" target="result">

<table width="91%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td height="5"></td></tr>
	<tr class="hide"><td colspan="2"><iframe name="result" id="result"></iframe></td></tr>

	 <cfif getAdministrator(url.mission) eq "1">
	 	 
	 	<cfquery name="Mis" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">			
			SELECT 	*
			FROM 	Ref_ParameterMission			
			WHERE 	Mission IN (SELECT Mission 
                                FROM   Organization.dbo.Ref_MissionModule 
				                WHERE  SystemModule = 'Procurement')
			AND    	MissionPrefix is not NULL
			<cfif url.mission neq "">
			AND     Mission = '#url.mission#'
			</cfif>
			
		</cfquery>
		
		<cfif mis.recordcount eq "0">
		
			<cfquery name="Mis" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				SELECT 	*
				FROM 	Ref_ParameterMission			
				WHERE 	Mission IN (SELECT Mission 
	                                FROM   Organization.dbo.Ref_MissionModule 
					                WHERE  SystemModule = 'Procurement')
				AND    	MissionPrefix is not NULL
							
			</cfquery>
				
		</cfif>
		
	 <cfelse>
	 
		 <cfquery name="Mis" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				SELECT 	*
				FROM 	Ref_ParameterMission	
				WHERE   Mission IN
						(
						  SELECT DISTINCT Mission
					      FROM   Organization.dbo.OrganizationAuthorization
						  WHERE  UserAccount = '#SESSION.acc#'
						  AND    Role        = 'AdminProcurement'	
						)
				<cfif url.mission neq "">
				AND     Mission = '#url.mission#'
				</cfif>		
		</cfquery>
		
		<cfif mis.recordcount eq "0">
			
			<cfquery name="Mis" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
					SELECT 	*
					FROM 	Ref_ParameterMission	
					WHERE   Mission IN
							(
							  SELECT DISTINCT Mission
						      FROM   Organization.dbo.OrganizationAuthorization
							  WHERE  UserAccount = '#SESSION.acc#'
							  AND    Role        = 'AdminProcurement'	
							)				
			</cfquery>
				
		</cfif>
	
	</cfif>		 
	
	
	 
	 <TR>
	 <TD width="150" class="labelmedium"><cf_tl id="Managed by">: <font color="FF0000">*</font>&nbsp;</TD>  
	 <TD class="labelmedium">
	 	<cfselect name="mission" id="mission" class="regularxl" query="Mis" value="mission" display="mission" required="Yes" message="Please, select a valid entity">
		</cfselect> &nbsp;&nbsp; <span style="font-size:12px; color:gray;">(<cf_tl id="You must have granted ""AdminProcurement"" role for the selected entities">)</span>
	 </TD>
	 </TR>	
	 
	 <tr>
	 	<td class="labelmedium"><cf_tl id="Enabled for">:</td>
		<td class="labelmedium">
			<cfif Mis.recordcount eq 1>
			 	<cfset isChecked = "checked">
			<cfelse>
				<cfset isChecked = "">
			</cfif>
			 
			<cfoutput query="Mis">
				<input type="Checkbox" class="radiol"
					   name="Mission_#MissionPrefix#" 
					   id="Mission_#MissionPrefix#"
					   #isChecked#>#Mission#
			</cfoutput>
		</td>
	</tr>
	  
	<TR>
	 <TD class="labelmedium"><cf_tl id="Code">:<font color="FF0000">*</font>&nbsp;</TD>  
	 <TD>
	 	<cfinput type="Text" name="Code" message="Please enter a code" required="Yes" visible="Yes" enabled="Yes" size="10" maxlength="20" class="regularxl">
	 </TD>
	</TR>
	
	<tr class="hide"><td id="checkme"></td></tr>
	
	 <!--- Field: Description --->
    <TR>
    <TD class="labelmedium" valign="top" style="padding-top:5px"><cf_tl id="Description">:<font color="FF0000">*</font> &nbsp;</TD>
    <TD >	
	
	<cf_LanguageInput
			TableCode       = "ItemMaster" 
			Mode            = "Edit"
			Name            = "Description"
			Type            = "Input"
			Required        = "Yes"
			Value           = ""
			Key1Value       = ""
			Message         = "Please enter a description"
			MaxLength       = "80"
			Size            = "50"
			Class           = "regularxl">
				
    </TD>
	</TR>
	 
	
	<TR>
    <td class="labelmedium" style="cursor:help"><cf_UIToolTip tooltip="Interface"><cf_tl id="Requisition Interface">:<font color="FF0000">*</font></cf_UIToolTip></b></td>
    <TD>
		
		<!--- Query returning search results --->
		
		<cfquery name="Parameter" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   Ref_ParameterMission
				WHERE  Mission  = '#url.Mission#'		
			</cfquery>
		
			<cfquery name="EntryList" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   Ref_EntryClass
				WHERE  1=1				            				  
												
						<cfif url.mission neq "" and url.period neq "">
						
						
						AND Code IN (
					                    SELECT EntryClass 
					                    FROM   Ref_ParameterMissionEntryClass 
										WHERE  Mission = '#url.Mission#'
										AND    Operational = 1 
										AND    Period  = '#url.period#'
										
										UNION 
										
										SELECT DISTINCT EntryClass
				                        FROM   ItemMaster I, ItemMasterMission IM
							            WHERE  I.Code = IM.ItemMaster
			             			    AND    I.Operational = 1
				                        AND    IM.Mission = '#url.Mission#' 
																					
									  )
											
											
						
						</cfif>
				
						<cfif getAdministrator(url.mission) eq "0">
						
						AND Code IN (SELECT DISTINCT ClassParameter 
								     FROM   Organization.dbo.OrganizationAuthorization
									 WHERE  UserAccount = '#SESSION.acc#'
									 AND    Role IN ('ProcReqEntry','ProcReqReview')
									) 
										  
						</cfif>		
						
						
						
						<cfif Parameter.FilterItemMaster eq "1">
												
						AND Code IN (SELECT ItemMaster 
						             FROM   Program.dbo.ProgramAllotmentDetail A, ItemMasterObject O
									 WHERE  A.ObjectCode = O.ObjectCode
									 AND    A.Period = '#URL.Period#'
									 AND    A.ProgramCode IN (SELECT ProgramCode 
										                      FROM   Program.dbo.Program
												 		      WHERE  Mission = '#url.Mission#')
									)						   
																			 
						</cfif>	
					
											  
					
				ORDER BY ListingOrder 
			</cfquery>
				
		<select name="EntryClass" id="EntryClass" class="regularxl" onchange="ColdFusion.navigate('getEntryClass.cfm?code='+this.value,'checkme')">		
		
			<cfoutput query="entryList">
				<option value="#code#" <cfif currentrow eq "1">checked</cfif>>#Description#</option>
			</cfoutput>
		
		</select>
			
	</td>
    </tr>	

	<cfif entryList.customdialog eq "Materials">
	  <cfset cl = "regular">
	<cfelse>
	  <cfset cl = "hide">
	</cfif>
		
	<TR id="material" class="<cfoutput>#cl#</cfoutput>">
    <td class="labelmedium" style="cursor:help"><cf_UIToolTip tooltip="Enforce selection of a warehouse item"><cf_tl id="Classified Item">:</cf_UIToolTip></b></td>
    <TD class="labelmedium">
		<table><tr>
		<td><input type="radio" class="radiol" name="EnforceWarehouse" id="EnforceWarehouse" value="1"></td>
		<td class="labelmedium" style="padding-left:5px"><cf_tl id="Yes, at Request stage"></td>
		<td style="padding-left:5px"><input type="radio" class="radiol" name="EnforceWarehouse" id="EnforceWarehouse" value="2"></td>
		<td class="labelmedium" style="padding-left:5px"><cf_tl id="Yes, at Receipt stage"></td>
		<td style="padding-left:5px"><input type="radio" class="radiol" name="EnforceWarehouse" id="EnforceWarehouse" value="0" checked></td>
		<td class="labelmedium" style="padding-left:5px"><cf_tl id="No"></td>
		</tr></table>
    </td>
    </tr>
	 
	
	
	 <!--- Field: Description --->
    <TR>
    <TD class="labelmedium"><cf_tl id="Cost price">:&nbsp;</TD>
    <TD class="labelmedium">
  	  	<cfinput type="Text"
       name="CostPrice"
       message="Please enter a price"
       validate="float"
       required="No"      
       size="5"
       maxlength="10"
       class="regularxl"> <cfoutput>#Param.BaseCurrency#</cfoutput>
				
    </TD>
	</TR>
	
	<TR>
    <td class="labelmedium" style="cursor:help"><cf_UIToolTip tooltip="Custom Dialog defined by entry class"><cf_tl id="Custom Dialog">:</cf_UIToolTip></b></td>
    <TD class="labelmedium">
	<input type="radio" class="radiol" name="CustomDialog" id="CustomDialog" checked value="1"><cf_tl id="Enabled">
	<input type="radio" class="radiol" name="CustomDialog" id="CustomDialog" value="0"><cf_tl id="Suppressed">
    </td>
    </tr>	
			
	<TR class="<cfoutput>#cl#</cfoutput>">
	    <td class="labelmedium" style="cursor:help"><cf_UIToolTip tooltip="Enforce show in list"><cf_tl id="Enforce Listing">:</cf_UIToolTip></b></td>
	    <TD class="labelmedium">
		<input type="radio" class="radiol" name="EnforceListing" id="EnforceListing" value="1"><cf_tl id="Yes">
		<input type="radio" class="radiol" name="EnforceListing" id="EnforceListing" checked value="0"><cf_tl id="No">
	    </td>
    </tr>
	
	<TR><td class="labelmedium"><cf_tl id="Is UoM Each">:</td>
	    <TD class="labelmedium">
		  <table>
		  <tr><td><input type="radio" class="radiol" name="IsUoMEach" id="IsUoMEach" value="1"></td><td class="labelmedium"><cf_tl id="Yes, item/uoms can be treated as one"></td></tr>
		  <tr><td><input type="radio" class="radiol" name="IsUoMEach" id="IsUoMEach" checked value="0"></td><td class="labelmedium"><cf_tl id="No, each item/uom may be different"></td></tr>
		  </table>			
	    </td>
    </tr>	
	
 	<TR>	
       <TD class="labelmedium"><cf_tl id="Associated Object">:&nbsp;</TD>
	   <td>
	   <cfdiv bind="url:RecordAddObject.cfm?mission={mission}&object=#url.object#" id="object">	  
	   </td>
	</TR>
	
	 <!--- Field: Description --->
    <TR>
    <TD class="labelmedium" valign="top" style="padding-top:5px"><cf_tl id="Memo">:&nbsp;</TD>
    <TD><textarea style="padding;3px;font-size:13px;height:40px;width:90%" name="Memo" class="regular"></textarea></TD>
	</TR>		
		
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr>	
		<td align="center" colspan="2" height="30">
		<cf_tl id="Cancel" var="vCancel">
		<cf_tl id="Submit" var="vSubmit">
		<cfoutput>
			<input class="button10g" type="button" name="Cancel" id="Cancel" value="#vCancel#" onClick="window.close()">
			<input class="button10g" type="submit" name="Insert" id="Insert" value="#vSubmit#">
		</cfoutput>
		</td>
	</tr>
	    	
</TABLE>

</CFFORM>

