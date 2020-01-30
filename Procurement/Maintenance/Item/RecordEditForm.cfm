
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM ItemMaster
	WHERE Code = '#URL.ID1#'
</cfquery>

<cfquery name="Param" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Parameter
</cfquery>

<cfquery name="Parameters" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterMission
	WHERE Mission = '#url.mission#'
</cfquery>

<cfquery name="Usage" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 ItemMaster
	FROM   RequisitionLine
	WHERE  ItemMaster = '#URL.ID1#'
</cfquery>

<cfquery name="ObjectList" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM      Ref_Object
	WHERE     Procurement = 1
</cfquery>

<CFFORM action="RecordSubmit.cfm" method="post" target="result" name="dialog">

	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		
	<tr><td style="padding-top:5px;padding-left:20px">
	
	<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td class="labellarge" style="height:39px;font-size:26px"><cf_tl id="Identification"></td>
	
	
	<td align="right" style="padding-right:4px">
		<table cellspacing="1" cellpadding="1">
		<tr>
			<td style="padding-right:7px" class="labelmedium"><cf_tl id="Operational">:</td>
		    <TD class="labelmedium">
				<input type="radio" class="radiol" name="OperationalItem" id="OperationalItem" <cfif get.Operational eq "1">checked</cfif> value="1"><cf_tl id="Yes">&nbsp;
				<input type="radio" class="radiol" name="OperationalItem" id="OperationalItem" <cfif get.Operational eq "0">checked</cfif> value="0"><cf_tl id="No">
		    </td>
	    </tr>
		</table>
	</td>
	
	</tr>	
	<tr><td colspan="2" class="linedotted"></td></tr>	
	
	<cfoutput>
				 
	<cfquery name="Mis" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	M.*,
				(SELECT Mission 
				 FROM  ItemMasterMission 
				 WHERE Mission = M.Mission 
				 AND   ItemMaster = '#get.Code#') as Selected
		FROM 	Ref_ParameterMission M
		WHERE 	M.Mission IN (SELECT Mission 
                              FROM   Organization.dbo.Ref_MissionModule 
				              WHERE  SystemModule = 'Procurement')
		AND     M.MissionPrefix is not NULL					  
	</cfquery>
			 
	<TR>
	 <TD style="padding-left:7px" class="labelmedium" width="100"><cf_tl id="Managed by">:&nbsp;<cf_space spaces="60"></TD>  
	 <TD width="75%">
	 
	 	<cfselect name="mission" id="mission" class="regularxl" query="Mis" value="mission" display="mission" selected="#get.Mission#" required="Yes" message="Please, select a valid entity"></cfselect> &nbsp;&nbsp;
		<span style="font-style:italic; font-size:10px; color:808080;">(<cf_tl id="You must have granted ""AdminProcurement"" role for the selected entities">)</span>
		
	 </TD>
	</TR> 
	
	<TR>
	 <TD style="padding-left:7px" class="labelmedium"><cf_tl id="Item Code">:&nbsp;</TD>  
	 <TD>
	    <cfif usage.recordcount eq "1">
			<input type="Text" name="code" id="code" value="#get.Code#" size="10" maxlength="20" class="regularxl">
		<cfelse>
		 	<input type="Text" name="code" id="code" value="#get.Code#" size="10" maxlength="20" class="regularxl">
		</cfif>
			<input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#" size="10" maxlength="20" class="regular">
	 </TD>
	</TR>
	
	<TR>
	 <TD style="padding-left:7px" class="labelmedium"><cf_tl id="Display">:&nbsp;</TD>  
	 <TD>
	    <cfif usage.recordcount eq "1">
			<input type="Text" name="codedisplay" id="codedisplay" value="#get.CodeDisplay#" size="10" maxlength="20" class="regularxl">
		<cfelse>
		 	<input type="Text" name="codedisplay" id="codedisplay" value="#get.CodeDisplay#" size="10" maxlength="20" class="regularxl">
		</cfif>
		
	 </TD>
	</TR>
	 
	<!--- Field: Description --->
    <TR>
    <TD style="padding-left:7px;padding-top:7px" class="labelmedium" valign="top"><cf_tl id="Descriptive">:&nbsp;</TD>
    <TD>
	
		<cf_LanguageInput
			TableCode       = "ItemMaster" 
			Mode            = "Edit"
			Name            = "description"
			Type            = "Input"
			Required        = "Yes"
			Value           = "#get.Description#"
			Key1Value       = "#get.Code#"
			Message         = "Please enter a description"
			MaxLength       = "80"
			Size            = "50"
			Class           = "regularxl">
  			
    </TD>
	</TR>	
	
	<tr class="hide"><td id="result"></   td></tr>		
	
	<tr><td colspan="2" class="labellarge" style="height:49px;font-size:26px"><cf_tl id="Procurement Settings"></td></tr>	
	<tr><td colspan="2" class="linedotted"></td></tr>		
	
	<tr>
	 	<td valign="top" style="padding-top:4px;padding-left:7px" class="labelmedium"><cf_tl id="Enable for entities">:</td>
		<td><table>
		    
		    <cfset cnt = 1>
			
			<cfloop query="Mis">	
			
				
				<cfif cnt eq "1"><tr></cfif>		    
			
				<cfset cnt = cnt+1>
				<label>
					<td><input type="Checkbox" class="radiol" name="Mission_#MissionPrefix#" id="Mission_#MissionPrefix#" <cfif Selected eq Mission>checked</cfif>></td>
					<td style="padding-left:5px;padding-right:8px" class="labelmedium">#Mission#</td>
				</label>				
				<cfif cnt gte "7">			
				<cfset cnt = 1>
				</tr>
				</cfif>
				
			</cfloop>
						
			
			
			</table>
		</td>
	</tr>
	
	<TR>
    <td style="height:25;padding-left:7px" class="labelmedium" style="cursor:help"><cf_UIToolTip tooltip="Enforce listing for procurement of the item for selection even if the Item Master is not used in the budget preparation"><cf_tl id="Enforce Selection in Requisition">:</cf_UIToolTip></b></td>
    <TD class="labelmedium">
		<input type="radio" class="radiol" name="EnforceListing" id="EnforceListing" <cfif get.EnforceListing eq "1">checked</cfif> value="1"><cf_tl id="Yes">
		<input type="radio" class="radiol" name="EnforceListing" id="EnforceListing" <cfif get.EnforceListing eq "0">checked</cfif> value="0"><cf_tl id="No, depends on budget formulation">
    </td>
    </tr>
	
	<TR>
	    <td style="padding-left:7px" class="labelmedium" style="cursor:help"><cf_UIToolTip tooltip="Procurement Requisition Interface and Authorization Class"><cf_tl id="Entry Class"> <font color="FF0000">*)</font>:</cf_UIToolTip></b></td>
	    <TD>
		
		<cfquery name="Entry" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Ref_EntryClass
			ORDER BY ListingOrder
			</cfquery>		
			
			<select name="EntryClass" id="EntryClass" class="regularxl" 
			   onchange="ColdFusion.navigate('getEntryClass.cfm?code='+this.value,'result')">		
				<cfloop query="entry">
					<option value="#code#"  <cfif get.EntryClass eq "#code#">selected</cfif>>#Description#</option>
				</cfloop>
			</select>
			
		</td>
    </tr>
		
	<cfquery name="Entry" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_EntryClass
		WHERE   Code = '#get.entryclass#'
	</cfquery>
	
	<cfif entry.customdialog eq "Materials">
	 	<cfset cl = "regular">
	<cfelse>
	  	<cfset cl = "hide">
	</cfif>
	
	<cfif entry.customdialog eq "Travel">
		<cfset ct = "regular">
	<cfelse>
		<cfset ct = "hide">
	</cfif>
	
		
	<TR>
	    <td style="height:25;padding-left:7px" class="labelmedium" style="cursor:help"><cf_UIToolTip tooltip="Custom Dialog defined by the entry class"><cf_tl id="Dialog">:</cf_UIToolTip></b></td>
	    <TD class="labelmedium">
		   <table>
		   <tr>
		   <td><input type="radio" class="radiol" name="CustomForm" id="CustomForm" <cfif get.CustomForm eq "1">checked</cfif> value="1" onclick="document.getElementById('cform').className='hide'"></td>
		   <td class="labelmedium" style="padding-left:5px"><cf_tl id="Inherited from entry class"></td>
		   <td class="labelmedium" style="padding-left:10px"><input type="radio" class="radiol" name="CustomForm" id="CustomForm" <cfif get.CustomForm eq "0">checked</cfif> value="0" onclick="document.getElementById('cform').className='regular'"></td>
		   <td class="labelmedium" style="padding-left:5px"><cf_tl id="Overrule"></td>
		   </tr>
		   </table>
	    </td>
    </tr>
		
	<cfif get.CustomForm eq "1">
	   <cfset cf = "hide">
	<cfelse>
	   <cfset cf = "regular">
	</cfif>
	
	<!--- Field: Listing Order --->
    <TR id="cform" class="#cf#">
    <TD style="height:25;padding-left:7px" class="labelmedium"><cf_tl id="Interface">:</TD>
    <TD>
	   <table width="100%" cellspacing="0" cellpadding="0">
	   <tr><td class="labelmedium">
		<input type="radio" class="radiol" name="CustomDialog" id="CustomDialog" value="Materials" <cfif get.CustomDialogOverwrite eq "Materials">checked</cfif>><cf_tl id="Select Warehouse">/<cf_tl id="Asset item">
		</td>
		</tr>
		<tr><td class="labelmedium">
		<input type="radio" class="radiol" name="CustomDialog" id="CustomDialog" value="Contract" <cfif get.CustomDialogOverwrite eq "Contract">checked</cfif>><cf_tl id="Identify Staffing Positions">
		</td></tr>
		<tr><td class="labelmedium">
		<input type="radio" class="radiol" name="CustomDialog" id="CustomDialog" value="Travel" <cfif get.CustomDialogOverwrite eq "Travel">checked</cfif>><cf_tl id="Travel Itinerary and cost">
		</td></tr>
		<tr><td class="labelmedium">
		<input type="radio" class="radiol" name="CustomDialog" id="CustomDialog" value="" <cfif get.CustomDialogOverwrite eq "">checked</cfif>><cf_tl id="N/A">
		</td></tr>
		</table>
	</TD>
	</TR>	
	
	<!--- Field: Description --->
    <TR>
    <TD style="height:25;padding-left:7px" class="labelmedium" style="cursor:help"><cf_tl id="Default Request Price">:&nbsp;</TD>
    <TD>
	
  	  	<cfinput type = "Text"
	       name       = "CostPrice"
	       value      = "#numberformat(get.CostPrice,'__,__.__')#"
	       message    = "Please enter a price"
	       validate   = "float"
	       required   = "No"    	
		   style      = "text-align:right;padding-right:2px"     
	       size       = "10"
	       maxlength  = "10"
	       class      = "regularxl"> <cfoutput>#Param.BaseCurrency#</cfoutput>
				
    </TD>
	</TR>	
	
	<TR id="material" class="<cfoutput>#cl#</cfoutput>">
    <td style="height:25;cursor:help;padding-left:7px" class="labelmedium">
	   <cf_UIToolTip tooltip="Enforce selection of a detailed item when entering a requisition if this item is associated the materials class."> <cf_tl id="Enforce Selection Supplies/Asset">:</cf_UIToolTip></b></td>
    <TD class="labelmedium">
	    <table cellspacing="0" cellpadding="0"><tr>
		<td class="labelmedium"><input type="radio" class="radiol" name="EnforceWarehouse" id="EnforceWarehouse" <cfif get.EnforceWarehouse eq "1">checked</cfif> value="1"></td><td style="padding-left:4px" class="labelmedium"><cf_tl id="Yes, at Requisition stage"></td>
		<td style="padding-left:4px"  class="labelmedium"><input class="radiol" type="radio" name="EnforceWarehouse" id="EnforceWarehouse" <cfif get.EnforceWarehouse eq "2">checked</cfif> value="2"></td><td style="padding-left:4px"  class="labelmedium"><cf_tl id="Yes, at Receipt stage"></td>
		<td style="padding-left:4px"  class="labelmedium"><input class="radiol" type="radio" name="EnforceWarehouse" id="EnforceWarehouse" <cfif get.EnforceWarehouse eq "0">checked</cfif> value="0"></td><td style="padding-left:4px"  class="labelmedium"><cf_tl id="No"></td>
		</tr>
		</table>
    </td>
    </tr>	
			
	<tr id="travel" class="<cfoutput>#ct#</cfoutput>">
    <td style="cursor:help;padding-left:7px" class="labelmedium">
	   <cf_UIToolTip tooltip="Associate the requisition to an employee."><cf_tl id="Employee Lookup">:</cf_UIToolTip></b></td>
    <TD class="labelmedium">
		<input type="radio" class="radiol" class="radiol" name="EmployeeLookup" id="EmployeeLookup" <cfif get.EmployeeLookup eq "1">checked</cfif> value="1"><cf_tl id="Yes">
		<input type="radio" class="radiol" class="radiol" name="EmployeeLookup" id="EmployeeLookup" <cfif get.EmployeeLookup eq "0">checked</cfif> value="0"><cf_tl id="No">
    </td>
    </tr>
	
	<tr><td height="5"></td></tr>
	<tr><td colspan="2" class="labellarge" style="height:49px;font-size:26px"><cf_tl id="Project Financial Requirement Settings"></td></tr>	
	<tr><td colspan="2" class="linedotted"></td></tr>		
	
	<TR id="budget">
    <td style="height:24;;padding-left:7px" class="labelmedium"><cf_tl id="Labels">:</td>
    <TD>	
		<cfset row = 0>
		<cfloop index="itm" list="#get.BudgetLabels#" delimiters="|">
		   <cfset row = row+1>
	       <cfset lbl[row] = itm>
		</cfloop>
		
		<table cellspacing="0" cellpadding="0">
		<tr>
			<td class="labelsmall"><cf_tl id="Item">:</td>
			<cfparam name="lbl[1]" default="">
			<td style="padding-left:4px"><input type="text" name="ReqLabel" value="#lbl[1]#" size="10" class="regularxl" maxlength="20"></td>
			<td style="padding-left:4px" class="labelsmall"><cf_tl id="Qty-1">:</td>
			<cfparam name="lbl[2]" default="">
			<td style="padding-left:4px"><input type="text" name="ReqLabel" value="#lbl[2]#" size="10" class="regularxl" maxlength="20"></td>
			<td style="padding-left:4px" class="labelsmall"><cf_tl id="Memo">:</td>
			<cfparam name="lbl[3]" default="">
			<td style="padding-left:4px"><input type="text" name="ReqLabel" value="#lbl[3]#" size="10" class="regularxl" maxlength="20"></td>
			<td style="padding-left:4px" class="labelsmall"><cf_tl id="Qty-2">:</td>
			<cfparam name="lbl[4]" default="">
			<td style="padding-left:4px"><input type="text" name="ReqLabel" value="#lbl[4]#" size="10" class="regularxl" maxlength="20"></td>			
			<td style="padding-left:4px" class="labelsmall"><cf_tl id="Memo-2">:</td>
			<cfparam name="lbl[5]" default="">
			<td style="padding-left:4px"><input type="text" name="ReqLabel" value="#lbl[5]#" size="10" class="regularxl" maxlength="20"></td>		
		
		</tr>
		</table>
	
	</td>
    </tr>	
		
	<TR id="budget">
    <td style="padding-left:7px;height:25px" class="labelmedium"><cf_tl id="Sub-items"></td>
    <TD class="labelmedium">
		<input type="radio" class="radiol" name="BudgetTopic" <cfif get.BudgetTopic eq "Text">checked</cfif> value="Text"><cf_tl id="Free text">
		<input type="radio" class="radiol" name="BudgetTopic" <cfif get.BudgetTopic eq "Standard">checked</cfif> value="Standard"><cf_tl id="Definable Topic Listing">
		<input type="radio" class="radiol" name="BudgetTopic" <cfif get.BudgetTopic eq "DSA">checked</cfif> value="DSA"><cf_tl id="DSA Locations">
	</td>
    </tr>		
		
	<TR id="budget">
    <td style="padding-left:7px;height:25px;cursor:pointer" class="labelmedium">
	   <cf_UIToolTip tooltip="Option to define which periods (audit) will be shown for data entry in Program Requirement Period Definition."><cf_tl id="Period Class">:</cf_UIToolTip></b>
    </td>
    <TD class="labelmedium">
	    <table cellspacing="0" cellpadding="0">
		<tr>
		<td><input type="radio" class="radiol" name="BudgetAuditClass" id="BudgetAuditClass" <cfif get.BudgetAuditClass eq "">checked</cfif> value=""></td>
		<td style="padding-left:3px;padding-right:8px" class="labelmedium"><cf_tl id="N/A"></td>
		<td><input type="radio" class="radiol" name="BudgetAuditClass" id="BudgetAuditClass" <cfif get.BudgetAuditClass eq "A">checked</cfif> value="A"></td>
		<td style="padding-left:3px;padding-right:8px" class="labelmedium">A</td>
		<td class="labelmedium"><input type="radio" class="radiol" name="BudgetAuditClass" id="BudgetAuditClass" <cfif get.BudgetAuditClass eq "B">checked</cfif> value="B"></td>
		<td style="padding-left:3px;padding-right:8px" class="labelmedium">B</td>
		<td class="labelmedium"><input type="radio" class="radiol" name="BudgetAuditClass" id="BudgetAuditClass" <cfif get.BudgetAuditClass eq "C">checked</cfif> value="C"></td>
		<td style="padding-left:3px;padding-right:8px" class="labelmedium">C</td> 
 		<td class="labelmedium"><input type="radio" class="radiol" name="BudgetAuditClass" id="BudgetAuditClass" <cfif get.BudgetAuditClass eq "D">checked</cfif> value="D"></td>
		<td style="padding-left:3px;padding-right:8px" class="labelmedium">D</td> 		
		</tr>
		</table> 
    </td>
    </tr>		
	
	<TR id="service">
    <td style="padding-left:7px" class="labelmedium" style="cursor:help">
	   <cf_UIToolTip tooltip="Item (service) generated from the workorder service table so it can be used for budget requirement definition."><cf_tl id="is Service Item">:</cf_UIToolTip></b></td>
    <TD class="labelmedium">
		<input type="radio" class="radiol" name="isServiceItem" id="isServiceItem" <cfif get.isServiceItem eq "1">checked</cfif> value="1"><cf_tl id="Yes">
		<input type="radio" class="radiol" name="isServiceItem" id="isServiceItem" <cfif get.isServiceItem eq "0">checked</cfif> value="0"><cf_tl id="No">
		(<cf_tl id="Deprecated">) 
    </td>
    </tr>		
	
	
    <TR>
    <TD style="padding-top:5px;padding-left:7px" valign="top" class="labelmedium"><cf_tl id="Memo">:&nbsp;</TD>
    <TD>
	   <textarea style="width:100%;padding:3px;font-size:12px" rows="3" name="Memo" totlength="200" onkeyup="return ismaxlength(this)" class="regular">#get.Memo#</textarea>
  	  		
    </TD>
	</TR>		
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	 <cfquery name="Request" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT   top 1 *
	     FROM     RequisitionLine
	     WHERE    ItemMaster = '#get.Code#' 
	 </cfquery>
	 
	 <cfquery name="Allotment" 
     datasource="AppsProgram" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT    top 1 *
	     FROM     ProgramAllotmentRequest
	     WHERE    ItemMaster = '#get.Code#' 
	 </cfquery>	
	
	<tr>
		<td colspan="2" align="center" height="18">		
		
			<cf_tl id="Delete" var="vDelete">
			<cf_tl id="Save" var="vSave">
		
			<cfif Request.recordCount eq "0" and Allotment.recordcount eq "0">
				<input class="button10g" style="width:140;height:25" type="Button" name="Delete" id="Delete" value="#vDelete#" onclick="return ask()">
			</cfif>
			<input class="button10g" style="width:140;height:25" type="submit" name="Update" id="Update" value="#vSave#">
			
		</td>	
	</tr> 
	
	</table>
	
	</td></tr>
	
	</table>
	
	</cfoutput>
	
</CFFORM>	