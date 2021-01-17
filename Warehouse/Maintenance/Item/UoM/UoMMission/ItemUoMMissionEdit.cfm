<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	ItemUoMMission
	WHERE	ItemNo = '#URL.ID#'
	AND		UoM = '#URL.UoM#'
	<cfif url.mission neq "">AND Mission = '#URL.mission#'<cfelse>AND 1=0</cfif>
</cfquery>

<cfquery name="Item" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	I.ItemDescription, U.UoMDescription
	FROM 	Item I,
			ItemUoM U
	WHERE 	I.ItemNo = U.ItemNo
	AND		I.ItemNo = '#URL.ID#'
	AND		U.UoM = '#URL.UoM#'
</cfquery>

<cfif url.mission neq "">
	<cf_screentop height="100%" html="no" scroll="Yes" layout="webapp" jquery="yes" label="Unit of Measure" option="UoM Entity [#Item.ItemDescription# - #Item.UoMDescription#]" banner="yellow">
<cfelse>
	<cf_screentop height="100%" html="no" scroll="Yes" layout="webapp" jquery="yes" label="Unit of Measure" option="UoM Entity [#Item.ItemDescription# - #Item.UoMDescription#]">
</cfif>

<script language="JavaScript">
	
	function ask() {
		if (confirm("Do you want to remove this record ?")) {	
		return true 	
		}	
		return false	
	}	

</script>

<cf_calendarscript>

<!--- edit form --->

<table class="hide">
	<tr><td colspan="2"><iframe name="processItemUoMMission" id="processItemUoMMission" frameborder="0"></iframe></td></tr>
</table>
	
<cfform action="ItemUoMMissionSubmit.cfm" method="POST" name="frmItemUoMMission" target="processItemUoMMission">

<table width="92%" class="formpadding formspacing" align="center">

	<tr><td colspan="2" align="center" height="3"></tr>
	
    <cfoutput>
	
	<cfinput type="hidden" name="ItemNo" value="#url.id#">
	<cfinput type="hidden" name="UoM" value="#url.uom#">
	<cfinput type="hidden" name="MissionOld" value="#url.mission#">		
	
    <TR>
    <TD width="25%" class="labelmedium"><cf_tl id="Entity">:</TD>
    <TD class="regular">

   		<cfquery name="getLookup" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_ParameterMission
			WHERE	Mission IN (SELECT Mission 
			                    FROM   Organization.dbo.Ref_MissionModule 
								WHERE  SystemModule = 'Warehouse')
			AND     (Mission NOT IN (SELECT Mission 
			                        FROM   ItemUoMMission 
									WHERE  ItemNo = '#url.id#' 
									AND    UoM = '#url.uom#') or Mission = '#url.mission#')					
		</cfquery>
		
		<select name="mission" id="mission" class="regularxxl" style="width:200px">
			<cfloop query="getLookup">
			  <option value="#getLookup.mission#" <cfif getLookup.mission eq #get.mission#>selected</cfif>>#getLookup.mission#</option>
		  	</cfloop>
		</select>		
    </TD>
	</TR>	
	
    <TR>
    <TD width="25%" class="labelmedium"><cf_tl id="Transaction UoM">:</TD>
    <TD class="regular">

   		<cfquery name="getUoM" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	ItemUoM
			WHERE	ItemNo = '#URL.ID#'
		</cfquery>
		
		<select name="TransactionUoM" id="TransactionUoM" class="regularxxl" style="width:200px">
			<option value="">Standard</option>
			<cfloop query="getUoM">
			  <option value="#getUoM.UoM#" <cfif getUoM.UoM eq get.TransactionUoM>selected</cfif>>#UoMDescription#</option>
		  	</cfloop>
		</select>		
    </TD>
	</TR>	
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Standard Cost Price">:</TD>
    <TD>
  	   <cfinput type   = "text"
	         name      = "StandardCost" 
			 value     = "#LSNumberFormat(get.StandardCost, "_.__")#" 
			 size      = "10" 
			 required  = "yes" 
			 message   = "Please, enter a standard cost" 
			 validate  = "numeric" 
			 style     = "text-align:right;padding-right:2px" 
			 maxlength = "20" 
			 class     = "regularxxl">
    </TD>
	</TR>
	
	<TR>
		<TD class="labelmedium"><cf_tl id="Selfservice">:</TD>
	    <TD class="labelmedium">
		   <table>
			   <tr class="labelmedium">
			   <td style="padding-left:4px"><input class="radiol" type="radio" name="Selfservice" id="Selfservice" value="0" <cfif get.Selfservice eq 0>checked</cfif>></td><td style="padding-left:4px">No</td>
			   <td style="padding-left:8px"><input class="radiol" type="radio" name="Selfservice" id="Selfservice" value="1" <cfif get.Selfservice eq 1 or url.mission eq "">checked</cfif>></td><td style="padding-left:4px">Yes</td>	
			   </tr>
		   </table>
	    </TD>
	</TR>
	
	<TR>
		<TD class="labelmedium"><cf_tl id="Enable Stock Level definition">:</TD>
	    <TD class="labelmedium">
		 <table>
			   <tr class="labelmedium">
			   <td style="padding-left:4px"><input class="radiol" type="radio" name="EnableStockClassification" id="EnableStockClassification" value="0" <cfif get.EnableStockClassification eq 0 or url.mission eq "">checked</cfif>></td><td style="padding-left:4px">No</td>
			   <td style="padding-left:8px"><input class="radiol" type="radio" name="EnableStockClassification" id="EnableStockClassification" value="1" <cfif get.EnableStockClassification eq 1>checked</cfif>></td><td style="padding-left:4px">Yes</td>	
			   </tr>
		   </table>	  	
	    </TD>
	</TR>	
		
	<TR>
		<TD class="labelmedium"><cf_tl id="Operational">:</TD>
	    <TD class="labelmedium">
		<table>
			   <tr class="labelmedium">
			   <td style="padding-left:4px"><input class="radiol" type="radio" name="Operational" id="Operational" value="0" <cfif get.operational eq 0>checked</cfif>></td><td style="padding-left:4px">No</td>
			   <td style="padding-left:8px"><input class="radiol" type="radio" name="Operational" id="Operational" value="1" <cfif get.operational eq 1 or url.mission eq "">checked</cfif>></td><td style="padding-left:4px">Yes</td>	
			   </tr>
		   </table>	  
	    </TD>
	</TR>	
	
	<cfif url.mission neq "">
		<tr>
			<TD class="labelmedium" valign="top" style="padding-top:3px;"><cf_tl id="Lots">:</TD>
			<td valign="top" style="padding-top:3px;">
				<cfinclude template="ItemUoMMissionLot.cfm">
			</td>
		</tr>
	</cfif>
		
	</cfoutput>
		
	<tr><td colspan="2" align="center" height="6"></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="6"></tr>
	
	<tr><td align="center" colspan="2" height="40">
	<cfif url.mission neq "">
	    <input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()">
	    <input class="button10g" type="submit" name="Update" id="Update" value="Update">
	<cfelse>
		<input class="button10g" type="submit" name="Save" id="Save" value="Save">
	</cfif>
	</td>	
	
	</tr>

</TABLE>

</CFFORM>