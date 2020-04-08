
<cfparam name="umojaindexno" default="">
<cfparam name="imisindexno"  default="">

<cfif umojaindexno neq "">
	<cfset url.indexUmoja = umojaindexno>
	<cfset url.indexImis  = imisindexno>
</cfif>	

<table width="100%" height="100%">

<tr class="line"><td height="30">
		
		<cf_tl id="Amendment History" var="lblEffective">
		<cf_tl id="Consecutive" var="lblStatus">
		<cf_tl id="Transactional Log" var="lblHistory">
		
		<cfoutput>
			<table>
				<tr>
				    <td class="labellarge">
						<input type="Radio" name="transactionlevel" class="radiol" value="2" onclick="palevel('#umojaindexno#',this.value,'#url.systemfunctionid#')"  style="cursor:pointer;" checked> 
						<label style="cursor:pointer;">#lblEffective#</label>									
					</td>
					<td style="padding-left:10px;" class="labellarge">
						<input type="Radio" name="transactionlevel" class="radiol" value="1" onclick="palevel('#umojaindexno#',this.value,'#url.systemfunctionid#')" style="cursor:pointer;"> 
						<label style="cursor:pointer;">#lblStatus#</label>
					</td>
					
					<td style="padding-left:10px;" class="labellarge">
						<input type="Radio" name="transactionlevel" class="radiol" value="3" disabled onclick="palevel('#umojaindexno#',this.value,'#url.systemfunctionid#')"  style="cursor:pointer;">
						<label style="cursor:pointer;">#lblHistory#</label>									
					</td>
					
					<td style="padding-left:4px"><font color="FF0000">: NOT COMPLETED WIP 30th sep 2017</td>
				</tr>
			</table>
		</cfoutput>
		
	</td>
</tr>

<tr><td height="100%" valign="top" id="pacontent"><cfinclude template="AppointmentContentL2.cfm"></td></tr>

</table>
