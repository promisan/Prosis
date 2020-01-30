<!--- 
	DocumentEditCandidate_Action.cfm
	
	List all candidates that have reached a particular step
	
	Included by: Travel\Template\DocumentEdit_Lines.cfm
	
	Modification History:
	08Mar04 - marks discontinuance of synchronization of this template with Vacancy module
	08Mar04 - added #CurrentRow# before each record printed
	        - modified spActionCandidates stored proc in PMSS-02\Travel Db to sort records by VC.LastName + VC.FirstName
			- modified ActionCandidate query below to sort by LastName, FirstName
	14June04 - added code to specific to TRAVEL module
	30Aug04 - added code to add column headers 
			- added new column Expected Deployment
			- added graphical icon indicators
--->
<!--- 14June04 - added do_nothing() and query WhichModule to control code block specific to TRAVEL module --->
<script language="JavaScript">
function do_nothing() {
	//do nothing
}
</script>

<cfquery name="WhichModule" datasource="#CLIENT.Datasource#"
 username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT TOP 1 DocumentLibrary AS Name
    FROM Parameter
</cfquery>

<!--- Get the field values from DocumentFlow of this workflow step for this request --->
<cfstoredproc procedure="spActionProperties" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
      <cfprocparam type="In"    
	   cfsqltype="CF_SQL_INTEGER"       
	   dbvarname="@DOCUMENTNO"     
	   value="#DocumentNo#" null="No">
	   
      <cfprocparam type="In"    
	  cfsqltype="CF_SQL_INTEGER"       
	  dbvarname="@ACTIONID"       
	  value="#ActionId#" null="No">
	  
      <cfprocresult name="Action" resultset="1">
</cfstoredproc>

<cfif Action.ActionShowAllCandidates eq "0">			<!--- so far FlowAction.ActionShowAllCandidates is "0" for all records 25Apr04 --->

	<!--- Note: ActionCandidateCurrent is result#4 in spActionLines which is called in DocumentEdit_Lines.cfm --->
   <cfquery name="ActionCandidate" dbtype="query">
    SELECT * FROM  ActionCandidateCurrent
    WHERE ActionOrderSub = #Action.ActionOrderSub#
	ORDER BY LastName, FirstName						<!--- added 8Mar04 MBM --->
   </cfquery>

<cfelse>

   <!--- Get candidates (who are not revoked) WHO HAVE COMPLETED the specified workflow step for this request --->
   <cfstoredproc procedure="spActionCandidates" datasource="#CLIENT.Datasource#" 
    username="#SESSION.login#" password="#SESSION.dbpw#">
      <cfprocparam type="In"       
	  cfsqltype="CF_SQL_INTEGER"       
	  dbvarname="@DOCUMENTNO"  
	  value="#DocumentNo#" null="No">
	  
      <cfprocparam type="In"       
	   cfsqltype="CF_SQL_INTEGER"       
	   dbvarname="@ACTIONID"    
	   value="#Action.ActionId#" null="No">
	   
      <cfprocresult name="ActionCandidate" resultset="1">
   </cfstoredproc>

</cfif>

<cfif ActionCandidate.recordCount gt 0> 

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left" bordercolor="#111111" style="border-collapse: collapse">

	<!--- added 30Aug04 --->
	<cfif #WhichModule.Name# EQ "travel">
		<tr><td class="top2" width="20">&nbsp;</td>
			<td class="top2" width="50%" align="left">&nbsp;Name - IMIS number</td>
			<td class="top2" width="12%"  align="left">Person No</td>			
			<td class="top2" width="20%" align="left">Expected Deployment</td>
			<td class="top2" width="*" colspan="3" align="right">Indicators</td>
			<td class="top2" width="20"></td>								
		</tr>
	</cfif>
	<!--- added 30Aug04 --->	
	 
	<cfoutput query="ActionCandidate">
			
	<tr>
		
	<td width="20" align="left" class="regular">	
		<button class="button3" onClick="javascript:showdocumentcandidate('#Get.DocumentNo#','#PersonNo#')" 
		onMouseOver="javascript:mouseHand();" 
		onMouseOut="javascript:mouseNormal();">
		<img src="../../Images/function.JPG" alt="" width="18" height="15" border="0">
		</button>	
	</td>
	
	<!--- ************** 14June04 -- added TRAVEL module specific code block ************ --->
	<cfif #WhichModule.Name# EQ "vacancy">
	    <td align="left" class="regular">&nbsp;<A HREF ="javascript:ShowCandidate('#PersonNo#')">#CurrentRow#. #FirstName# #LastName#</a></td>
		<td>&nbsp;</td>
	<cfelse>

		<cfif #Status# EQ "6">
		<td align="left" class="regular" width="50%">&nbsp;<i><a href="javascript:do_nothing()" title="Index numbers in green indicate a validated IMIS number. 
Name shown in italics for revoked nominations.">#CurrentRow#. #FirstName# #LastName#&nbsp;&nbsp;(not travelling)</a></i>
		</td>
		<cfelse>
			<cfif #IndexNo# EQ #StfIndexNo#>
		    	<td align="left" class="regular" width="50%">&nbsp;<a href="javascript:do_nothing()" title="Index numbers in green indicate a validated IMIS number. 
Name shown in italics for revoked nominations.">#CurrentRow#. #FirstName# #LastName#&nbsp;&nbsp;(<font color="006600">#IndexNo#</font>)</a>
			 	</td>
			<cfelse>
			    <td align="left" class="regular" width="50%">&nbsp;<a href="javascript:do_nothing()" title="Index numbers in green indicate a validated IMIS number. 
Name shown in italics for revoked nominations.">#CurrentRow#. #FirstName# #LastName#&nbsp;&nbsp;(#IndexNo#)</a>
				</td>
			</cfif>
		</cfif>
		
		<td align="left" class="regular">&nbsp;#PersonNo#</td>
		<td align="left" class="regular">&nbsp;#Dateformat(PlannedDeployment, "#CLIENT.dateformatshow#")#</td>		
				
	</cfif>
	<!--- ********************** End of 14 June 04 addition *********************** --->
	
	<cfif Action.ActionShowAllCandidates eq "1">
		<td align="left" class="regular">#ActionMemo# #ActionReference#</td>
	</cfif>
	
	<!--- added 30Aug04 --->
	<!---td align="right" class="regular"><A HREF ="javascript:ShowPost('#PostNumber#')">&nbsp;#PostNumber#</a></td--->			

	<cfif #WhichModule.Name# EQ "vacancy">
		<td colspan="4" width="*" align="right" class="regular"><A HREF ="javascript:ShowPost('#PostNumber#')">&nbsp;#PostNumber#</a></td>
	<cfelse>
		<td width="*" ></td>
		<td width="20" align="right">
			<cfif #IncidentInd#><img src="../../Images/stop.JPG" alt="" width="20" height="15" border="0">&nbsp;</cfif>
		</td>		
		<td width="20" align="right">			
			<cfif #ActionCandidate.MedicalPassInd#><img src="../../Images/redcross.JPG" alt="" width="20" height="13" border="0">&nbsp;</cfif>
			<cfif #ActionCandidate.MedicalFailInd#><img src="../../Images/failed_medical.JPG" alt="" width="20" height="13" border="0">&nbsp;</cfif>
		</td>
		<td width="20" align="right">		
			<cfif #SatPassInd#><img src="../../Images/satpass.JPG" alt="" width="20" height="13" border="0"></cfif>						
		</td>
	</cfif>
	<!--- added 30Aug04 --->
	
	</tr>	
	
	</cfoutput>
	
</table>	

</cfif>