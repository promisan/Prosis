
<cfquery name="Class" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMissionEntryClass R, 
    	   Ref_EntryClass C
	WHERE  Mission    = '#URL.Mission#'
	AND    Period     = '#URL.Period#' 
	AND    R.EntryClass = C.Code 
	AND    R.EntryClass IN (
				SELECT DISTINCT EntryClass
				FROM   ItemMaster
				WHERE  Operational = 1
				AND    (
							(Mission = '#url.Mission#' or Mission is NULL ) 
							OR
							Code IN 
							(
								SELECT ItemMaster
								FROM ItemMasterMission
								WHERE Mission='#url.Mission#' 
							)
						) 
 				) 
 
</cfquery>


<cfif Class.recordcount eq "0">
	
	<cfquery name="Class" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ParameterMissionEntryClass R, 
			       Ref_EntryClass C
			WHERE  Mission    = '#URL.Mission#'
			AND    Period     = '#URL.Period#' 
			AND    R.EntryClass = C.Code 		
	</cfquery>

</cfif>

<table border="0" cellspacing="0" cellpadding="0" class="formspacing">

<tr><td height="4"></td></tr>
<tr class="line">
    <td class="labelit">Entry Class</td>	
	<td class="labelit">
	<cf_UIToolTip tooltip="<b>Attention:</b><br>Adding a user account will mean that a requisition after it has been reviewed <br> will go straight to the buyer for Job processing and will skip the buyer assignment process.">
	Buyer 1
	</cf_UIToolTip>
	</td>	
	<td  style="padding-left:8px" class="labelit">Buyer 2</td>
</tr>	
	
</tr>


<cfoutput query="Class">

<tr>

<td class="labelit">#Description#:</td>

<td>

	<table cellspacing="0" cellpadding="0" class="formspacing">
	<tr><td>
			<cfset link="ParameterEditJobEntryClassBuyer.cfm?serialno=0&entryclass=#entryClass#&defaultbuyer=#BuyerDefault#">

			<cf_selectlookup
			    box          = "sBuyerDefault_#entryClass#"
			    link         = "#link#"
				button       = "yes"
				icon         = "contract.gif"
				iconwidth    = "13"
				iconheight   = "14"
				close        = "Yes"
				class        = "user"
				des1         = "account">	
	
		</td>	
		<td>	  
	    	<table width="100%">
					    		
	    		<tr>
	    			<td>
						<cfdiv id="sBuyerDefault_#entryClass#" bind="url:ParameterEditJobEntryClassBuyer.cfm?serialno=0&entryclass=#entryClass#&defaultbuyer=#BuyerDefault#">
					</td>
				</tr>
			</table>		

		</td>
		<td style="padding-left:4px"><img height="17" width="17" style="cursor:pointer" onclick="document.getElementById('BuyerDefault_#entryClass#').value='@requester'" 
	     src="#session.root#/images/request.jpg" alt="Requester" border="0"></td>
		 <td style="padding-left:8px" class="labelit">#application.basecurrency#</td>
		 <td style="padding-left:4px">		 
			 <cfinput  validate="float" style="text-align:right" tooltip="Threshold : if requisition exceeds the threshold amount the buyer will not receive the action" class="regularxl" type="Text" id="BuyerDefaultThreshold_#entryClass#" name="BuyerDefaultThreshold_#entryClass#" value="#BuyerDefaultThreshold#" required="No" size="4" maxlength="10">				 
		 </td>
	</tr>		
	</table>		

</td>

<TD  style="padding-left:8px">

	<table cellspacing="0" cellpadding="0" class="formspacing">
	<tr><td>			  
			<cfset link="ParameterEditJobEntryClassBuyer.cfm?serialno=1&entryclass=#entryClass#&defaultbuyer=#BuyerDefaultBackup#">

			<cf_selectlookup
			    box          = "sBuyerDefaultBackup_#entryClass#"
			    link         = "#link#"
				button       = "yes"
				icon         = "contract.gif"
				iconwidth    = "13"
				iconheight   = "14"
				close        = "Yes"
				class        = "user"
				des1         = "account">	

		
		</td>			
		<td>		  					  
	    	<table width="100%">
					    		
	    		<tr>
	    			<td>
						<cfdiv id="sBuyerDefaultBackup_#entryClass#" bind="url:ParameterEditJobEntryClassBuyer.cfm?serialno=1&entryclass=#entryClass#&defaultbuyer=#BuyerDefaultBackup#">
					</td>
				</tr>
			</table>		
		</td>
	 	<td style="padding-left:4px">
	 		<img height="17" width="17" style="cursor:pointer" onclick="document.getElementById('BuyerDefaultBackup_#entryClass#').value='@requester'" 
	     	src="#session.root#/images/request.jpg" alt="Requester" border="0">
	    </td>
	 	<td style="padding-left:8px" class="labelit">
	 		#application.basecurrency#
	 	</td>	 
	 	<td style="padding-left:4px">
			 <cfinput  validate="float" style="text-align:right"  class="regularxl" type="Text" id="BuyerDefaultBackupThreshold_#entryClass#" name="BuyerDefaultBackupThreshold_#entryClass#" value="#BuyerDefaultBackupThreshold#" required="No" size="4" maxlength="10">				 
		 </td>	 
	 </tr>
		
	</table>

</tr>
</cfoutput>

</table>

