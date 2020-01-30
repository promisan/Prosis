
<cfparam name="url.entrymode"        default="edition">		
<cfparam name="url.programcode" default="">			 

<cf_tl id="Release requirements for allotment" var="vTitle">
<cf_tl id="Associate Objects of Expenditure that will be released for allotment" var="vOption">

<cfif url.entrymode eq "edition">
	
	<cf_screentop height="100%" 
				  scroll="no" 
				  layout="webapp" 
				  label="#vTitle#" 
				  option="#vOption#" 				  
				  banner="gray" 
				  bannerheight="50px"
				  bannerforce="yes"
				  menuAccess="No" 
				  jquery="yes"
				  user="No"
				  systemfunctionid="#url.systemfunctionid#">
			  
<cfelse>
	
	<cfquery name="get"
		datasource="appsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT	 P.*, Pe.Reference
			FROM  	 Program P, ProgramPeriod Pe 
			WHERE  	 P.ProgramCode = Pe.ProgramCode
			AND      Pe.Period = '#url.Period#'		
			AND       P.ProgramCode = '#url.programcode#'
		</cfquery>
		
	<cf_screentop height="100%" 
				  scroll="no" 
				  layout="webapp" 
				  label="#get.Reference#: #vTitle#" 
				  option="<br>#vOption#" 
				  bannerheight="50px"
				  menuAccess="No" 
				  jquery="yes"
				  user="No"
				  systemfunctionid="#url.systemfunctionid#">

</cfif>			  
		 			  
<cfajaximport tags="cfform">
<cf_calendarScript>

<cf_tl id="All selected objects must have a defined date." var="msgDirtyDates">

<script>

	function selectObject(co,ci) {
		if (co.checked) {
			$('.clsReqDate_'+ci).css('display','');
		}else {
			$('.clsReqDate_'+ci).css('display','none');
		}
	}
	
	function validateDates() {
		var isDirty = false;
		$('.clsCBObject').each(function() {
			if ($(this).is(':checked')) {
				var thisVal = $(this).val();
				if ($.trim($('#RequirementDate_'+thisVal).val()) == '') {
					// isDirty = true;
				}
			}
		});
		
		if (isDirty) {
			alert('<cfoutput>#msgDirtyDates#</cfoutput>');
			return false;
		}else {
		    document.getElementById('btnSubmit').click()			
		}
		
	}
	
</script>

<cfquery name="Edition"
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT	E.EditionId, 
				E.Period, 
				E.Version, 
				V.ObjectUsage
		FROM  	Ref_AllotmentEdition AS E 
				INNER JOIN Ref_AllotmentVersion AS V ON E.Version = V.Code
		WHERE  	E.EditionId = '#url.editionId#'
</cfquery>

<cfquery name="Funds"
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT	 F.*
		FROM  	 Ref_AllotmentEditionFund AS F 
		WHERE  	 F.EditionId = '#url.editionId#'
		ORDER BY F.FundDefault DESC
</cfquery>

<table width="98%" height="100%" align="center">

	<tr><td height="5"></td></tr>
	
	<cfif url.entrymode eq "edition">
		<tr class="line">
			<td colspan="2" class="labelmedium"><font color="808080">Attention: Applies to all programs/projects unless this is overruled</td>
		</tr>
	<cfelse>
	
	<cfoutput>
		<tr class="line">
			<td colspan="2" class="labelit"><font color="808080">Attention: ONLY <font size="4"><b>#get.ProgramName# #get.Reference#</b></td>
		</tr>	
	</cfoutput>
	
	</cfif>
	<tr>
		<td style="padding-left:10px;height:40px;min-width:100px" class="labellarge" width="40"><cf_tl id="Fund">:</td>
		<td width="95%" style="padding-left:10px">
			<select name="fundselect" id="fundselect" class="regularxl">
				<cfoutput query="Funds">
					<option value="#Fund#"> #Fund#
				</cfoutput>
			</select>
		</td>
	</tr>
	
	<tr><td colspan="2" style="height:1px" class="line"></td></tr>	
	
	<tr>
		<td colspan="2" height="99%" style="padding-left:10px;padding-bottom:4px">			
			<cf_divscroll style="height:100%">
				<cfdiv id="divFund"
				  bind="url:FundObjectDetail.cfm?entrymode=#url.entrymode#&programcode=#url.programcode#&systemfunctionid=#url.systemfunctionid#&period=#url.period#&editionId=#url.editionId#&objectUsage=#Edition.ObjectUsage#&fund={fundselect}">			  
			</cf_divscroll>			  
		</td>
	</tr>
	
	<tr><td height="5"></td></tr>
					
		<tr>
			<td colspan="4" align="center" style="padding-bottom:5px">
				<cfoutput>
					<cf_tl id="Save" var="1">
					<input type="button" style="width:200px" class="button10g" value="#lt_text#" onclick="return validateDates();">
				</cfoutput>
			</td>
		</tr>
	
</table>