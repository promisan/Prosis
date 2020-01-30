<cfquery name="qJournal"
 datasource="AppsLedger" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT Journal, Description
	FROM Journal
	WHERE 1=1
	<cfif URL.iJournal neq "">
		AND Journal in (#PreserveSingleQuotes(URL.iJournal)#)
	</cfif>
	<cfif mode eq "AP">
	AND TransactionCategory IN ('DirectPayment','Payables')
	</cfif>
	<cfif mode eq "PO">
	AND TransactionCategory IN ('Payment')
	</cfif>
	ORDER BY Journal
</cfquery>

<cfoutput>

<table width="100%">			

   <tr class="line">
   <td width="50%">
	   <table width="100%">
	   <tr>	
	   
	   	<td style="padding-left:10px">	
			<table align="center">
			<tr>
				<td align="right" class="labelit" style="white-space: nowrap;"><cf_tl id="Search">:</td>				
				<td style="padding-left:10px">
				<input type="text" 
					onkeyup = "if (event.keyCode==13){Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('TransactionDetailReconcileResult.cfm?mode=#url.mode#&ID1=#URL.ID1#&find='+this.value+'&tax='+$('##taxvalue').val()+'&ijournal='+$('##tjournal').val()+'&period='+$('##tperiod').val(),'reconcileresult')}"
					style   = "width:100;border:1px solid silver" 
					class   = "regularxl" 
					id      = "findvalue" 
					name    = "findvalue">
				</td>	
				<td>
				<img style="cursor:pointer" src="#session.root#/images/search.png" height="25" alt="" border="0" onclick="Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('TransactionDetailReconcileResult.cfm?mode=#url.mode#&ID1=#URL.ID1#&find='+$('##findvalue').val()+'&tax='+$('##taxvalue').val()+'&ijournal='+$('##tjournal').val()+'&period='+$('##tperiod').val(),'reconcileresult')">
				</td>
			</tr>	
			</table>	
	
		</td>	
		
			<td style="padding-left:10px">	
			<table align="center">
			<tr>
				<td align="right" class="labelit" style="white-space: nowrap;"><cf_tl id="Tax Reference">:</td>				
				<td style="padding-left:10px">
				<input type="text" 
					onkeyup = "if (event.keyCode==13){Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('TransactionDetailReconcileResult.cfm?mode=#url.mode#&ID1=#URL.ID1#&find='+$('##findvalue').val()+'&tax='+this.value+'&ijournal='+$('##tjournal').val()+'&period='+$('##tperiod').val(),'reconcileresult')}"
					style   = "width:100;border:1px solid silver" 
					class   = "regularxl" 
					id      = "taxvalue" 
					name    = "taxvalue">
				</td>	
				<td>
				<img style="cursor:pointer" src="#session.root#/images/search.png" height="25" alt="" border="0" onclick="Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('TransactionDetailReconcileResult.cfm?mode=#url.mode#&ID1=#URL.ID1#&find='+$('##findvalue').val()+'&tax='+$('##taxvalue').val()+'&ijournal='+$('##tjournal').val()+'&period='+$('##tperiod').val(),'reconcileresult')">
				</td>
			</tr>	
			</table>	
	
		</td>	
		
		<td style="padding-left:10px">
			<table align="center">
			<tr>
				<td align="right" class="labelit" style="white-space: nowrap;"><cf_tl id="Journal">:</td>
				<td style="padding-left:10px">
				<select id="tjournal" name="tjournal" class="regularxl" onchange="Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('TransactionDetailReconcileResult.cfm?mode=#url.mode#&ID1=#URL.ID1#&find='+$('##findvalue').val()+'&tax='+$('##taxvalue').val()+'&ijournal='+$('##tjournal').val()+'&period='+$('##tperiod').val(),'reconcileresult')">
					<option value="">Any</option>
					<cfloop query="qJournal">
						<option value="'#Journal#'">#Description#</option>
					</cfloop>
				</select>
				</td>
			</tr>
			</table>
		</td>	
	
		<td style="padding-left:10px">
			<table align="center">	
			<tr>	
			<td align="right" class="labelit" style="white-space: nowrap;"><cf_tl id="Period">:</td>
			<td style="padding-left:10px">
			<select id="tperiod" name="period" class = "regularxl" onchange="Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('TransactionDetailReconcileResult.cfm?mode=#url.mode#&ID1=#URL.ID1#&find='+$('##findvalue').val()+'&tax='+$('##taxvalue').val()+'&ijournal='+$('##tjournal').val()+'&period='+$('##tperiod').val(),'reconcileresult')">
					<option value="">Any</option>
					<cfloop list="#URL.Period#" index="p">
							<option value="#p#">#p#</option>
					</cfloop> 
			</select>
			</td>
			</tr>
			</table>
		</td>
				
		<td style="padding-left:10px">		
		<table align="center">
			<tr>
				<td  align="right" class="labelit" style="white-space: nowrap;"><cf_tl id="Sort">:</td>
				<td style="padding-left:10px">
		
				<SELECT name="group" id="group" onChange="Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('TransactionDetailReconcileResult.cfm?mode=#url.mode#&ID1='+this.value+'&find='+$('##findvalue').val()+'&tax='+$('##taxvalue').val()+'&ijournal='+$('##tjournal').val()+'&period='+$('##tperiod').val(),'reconcileresult')" class="regularxl">
			     	<OPTION value="Journal"              <cfif URL.ID1 eq "Journal">selected</cfif>><cf_tl id="Journal">
		     		<OPTION value="ReferenceName"        <cfif URL.ID1 eq "ReferenceName">selected</cfif>><cf_tl id="Customer">/<cf_tl id="Vendor">
					<OPTION value="JournalTransactionNo" <cfif URL.ID1 eq "JournalTransactionNo">selected</cfif>><cf_tl id="Invoice No">
		     		<OPTION value="TransactionDate"      <cfif URL.ID1 eq "TransactionDate">selected</cfif>><cf_tl id="Transaction Date">
				</SELECT> 
				
				</td>
			</tr>		
		</table>		
		</td>
		
	</tr>	
	</table>
	</td>	

	<td align="right">
	
		<table class="formpadding">
		<tr>
		<td style="padding-left:10px">
			<SELECT name="page" id="page" onChange="Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('TransactionDetailReconcileResult.cfm?mode=#url.mode#&Page='+this.value+'&ID1='+$('##group').val()+'&find='+$('##findvalue').val()+'&tax='+$('##taxvalue').val()+'&ijournal='+$('##tjournal').val()+'&period='+$('##tperiod').val(),'reconcileresult')" class="regularxl"/>
		</td>
		</tr>	
		</table>
		
	</td>	
	
	<td>
	
        <input type="button" class="button10g hide" id="refreshcontent" onclick="ptoken.navigate('TransactionDetailReconcileResult.cfm?mode=#url.mode#&ID1='+$('##group').val()+'&find='+$('##findvalue').val()+'&tax='+$('##taxvalue').val()+'&ijournal='+$('##tjournal').val()+'&period='+$('##tperiod').val(),'reconcileresult')">

	</td>
	
</tr>	

</table>	
</cfoutput>
	