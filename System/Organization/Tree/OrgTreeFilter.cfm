
<input type="hidden" name="_PostClass"    id="_PostClass"    value="">		
<input type="hidden" name="_Fund"         id="_Fund"         value="">		
<input type="hidden" name="_AllDetails"   id="_AllDetails"   value="show">
<input type="hidden" name="_PrintDetails" id="_PrintDetails" value="show">
			
<table width="100%" height="100%">

<tr class="line"><td bgcolor="white">
	
	<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr>
	
	<td width="70" class="labelit">Fund:</td>
	<td colspan="3">
	
			<cfquery name="qFund" datasource="AppsEmployee">
				SELECT Distinct F.FundType
				FROM vwPosition P, Program.dbo.Ref_Fund F
				WHERE
				P.Mission='#url.Mission#'
				AND
				P.Fund=F.Code
			</cfquery>
			
			<select name="Fund" id="Fund" class="regularxl" onChange="setFund(this.value)">
 			    <option value="">All</option>
				<cfoutput query="qFund">
				  <option value="#qFund.FundType#">#qFund.FundType#</option>
			   </cfoutput>
			</select>
			
	</td>
	
	</tr>
	
	<tr>
	
	<td class="labelit">Post class:</td>		
																
		<cfquery name="qPostClass" datasource="AppsEmployee">
			SELECT Distinct P.PostClass
			FROM   vwPosition P
			WHERE  P.Mission='#url.Mission#'
		</cfquery>
		
	<td colspan="3">		
		<select name="PostClass" id="PostClass" class="regularxl" onChange="setPostClass(this.value)">
	 	   <option value="">All</option>
			<cfoutput query="qPostClass">
			  <option value="#qPostClass.PostClass#">#qPostClass.PostClass#</option>
		    </cfoutput>
		</select>				
	</td>
	</tr>
			
	<tr>
	<td class="labelit">Expanded:</td>		
	<td style="height:27" ><input type="checkbox" class="radiol" name="AllDetails" id="AllDetails" checked value="show" onClick="setDetails(this)"> 
	</td>
	
	<td style="padding-left:4px" class="labelit">Print Details:</td>		
	<td style="height:27;padding-right:10px"><input type="checkbox" class="radiol" name="PrintDetails" id="PrintDetails" checked value="show" onClick="setPrint(this)"> 
	</td>
	</tr>
		
	</table>	

</td>
</tr>

</table>		
