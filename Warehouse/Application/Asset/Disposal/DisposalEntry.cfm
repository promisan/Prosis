
<cf_tl id="Disposal Request" var="1">

<cf_screentop height="100%" scroll="Yes" banner="gray" jquery="Yes" enforcebanner="Yes"			
			systemmodule="Warehouse"
			FunctionClass="Window"  FunctionName="Asset Disposal" option="Initiate request for disposal of items" layout="webapp" label="#lt_text#" icon="logos/warehouse/recycle.png">

<cfset save = 1>

<cfparam name="url.AssetId" default="">

<cfif url.AssetId eq "">

	<cf_tl id="No items to be transferred were selected" Class="Message" var="1">
	<cf_message message="#lt_text#" return="close">
	<cfabort>

</cfif>

<cfquery name="Check" 
	 datasource="appsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * FROM Ref_EntityClassPublish
	 WHERE EntityCode = 'AssDisposal'
	 AND   EntityClass = 'Standard'	 
</cfquery>

<cfif Check.recordcount eq "0">
	<cf_tl id="No workflow has been defined" var="1" Class="Message">
	<cf_message message="#lt_text#" return="close">
	<cf_screenbottom>
	<cfabort>

</cfif>

<cf_assignId>

<cfform action="DisposalEntrySubmit.cfm?mission=#url.mission#&disposalid=#rowguid#&tbl=#url.tbl#&id=#url.id#&id1=#url.id1#&id2=#url.id2#&page=#url.page#&sort=#url.sort#&view=#url.view#&mde=#url.mde#" method="POST" target="items" name="movement" id="movement">

<cfparam name="Form.AssetId" default="{00000000-0000-0000-0000-000000000000}">

<cfquery name="Parameter" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM   Parameter
</cfquery>

<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Parameter
	SET DisposalNo = DisposalNo+1
</cfquery>

<cfquery name="Clean" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE AssetDisposal
	WHERE ActionStatus = '0'
	AND   OfficerUserId = '#SESSION.acc#'	
</cfquery>

<cfquery name="Insert" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO AssetDisposal
	(DisposalId,
	 Mission,
	 DisposalReference,
	 ActionStatus,
	 OfficerUserId,
	 OfficerLastName,
	 OfficerFirstName)
	VALUES
	('#rowguid#',
	 '#url.mission#',
	 '#Parameter.DisposalPrefix#-#Parameter.DisposalNo+1#',
	 '0',
	 '#SESSION.acc#',
	 '#SESSION.last#',
	 '#SESSION.first#')	
</cfquery>

<table width="94%" align="center"  border="0" cellspacing="0" cellpadding="0" class="formpadding formspacing">

<tr><td height="4"></td></tr>
<tr>
 <td height="20" width="20%" class="labelmedium"><cf_tl id="Reference No">:</td>
 <td class="labelmedium"><b><cfoutput>#Parameter.DisposalPrefix#-#Parameter.DisposalNo+1#</cfoutput></b></td>
 <input type="hidden" name="Reference" id="Reference" value="<cfoutput>#Parameter.DisposalPrefix#-#Parameter.DisposalNo+1#</cfoutput>">
</tr>

<cfquery name="Method" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     Ref_Disposal
</cfquery>

<tr>
 <td height="20" width="20%" class="labelmedium"><cf_tl id="Disposal Method">:</td>
 <td>
 <select name="DisposalMethod" id="DisposalMethod" class="regularxl enterastab">
    <cfoutput query="method">
	<option value="#Code#">#Description#</option>
	</cfoutput>
 </select> 
 </td>
</tr>


<!--- select relevant workflows --->

<cfquery name="Class" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   DISTINCT R.*
	FROM     Ref_EntityClassPublish P, Ref_EntityClass R
	WHERE    R.EntityCode = 'assDisposal'
	AND      P.EntityCode = R.EntityCode
	AND      P.EntityClass = R.EntityClass	
</cfquery>

<tr><td class="labelmedium"><cf_tl id="Classification">:</td>
    <td>
	<cfif Class.recordcount gte "1">
	    <select name="EntityClass" id="EntityClass" class="regularxl enterastab">
	    <cfoutput query="Class">
		<option value="#EntityClass#">#EntityClassName#</option>
		</cfoutput>
	    </select>
	<cfelse>
	<cfset save = "0">
	<font size="1" color="FF0000"><cf_tl id="Workflow not configured"></font>	
	</cfif>	
	</td>
</tr>


<cfquery name="Group" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     Ref_EntityGroup
		WHERE    EntityCode = 'AssDisposal'		
</cfquery>

<tr>
 <td height="20" width="20%" class="labelmedium"><cf_tl id="Authorization Group">:</td>
 <td>
 <cfif Group.recordcount gte "1">
	 <select name="Workgroup" id="Workgroup" class="regularxl enterastab">
	    <cfoutput query="group">
		<option value="#EntityGroup#">#EntityGroupName#</option>
		</cfoutput>
	 </select> 
<cfelse>
	<cfset save = "0">
	<font color="FF0000"><cf_tl id="Authorization group not configured"></font>	
	</cfif>		 
 </td>
</tr>

<tr>
 <td height="20" width="20%" class="labelmedium"><cf_tl id="Instruction">:</td>
 <td>
 <input type="text" style="width:90%" class="regularxl enterastab" name="DisposalRemarks" id="DisposalRemarks" maxlength="100">
 </td>
</tr>


<tr>
 <td height="20" width="20%" class="labelmedium"><cf_tl id="Sale Value">:</td>
 <td>
 <cfinput type="Text"
       name="DisposalValue"
       validate="float"
       required="No"
       visible="Yes"
       enabled="Yes"
       maxlength="20"
	   class="regularxl enterastab"	   
       style="width:100">
 </td>
</tr>

<cf_dialogAsset>


<!--- -------------------------------------------- --->
<!--- -----------------get assets  --------------- --->
<!--- -------------------------------------------- --->

<cfinvoke component = "Service.Process.Materials.Asset"  
   method           = "AssetList" 
   mission          = "#url.mission#"
   children         = "1"
   disposal         = "0"
   assetid          = "#url.AssetId#"		
   table            = "#SESSION.acc#AssetDisposal">		

<cfquery name="PrepareDisposalset" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO AssetItemDisposal (DisposalId,AssetId)
	SELECT '#rowguid#',assetid 
	FROM   userquery.dbo.#SESSION.acc#AssetDisposal	
</cfquery>


<CF_DropTable dbName="AppsQuery"  tblName="#SESSION.acc#Asset2">	

<cfquery name="Prepare" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *			 
  	INTO     userQuery.dbo.#SESSION.acc#Asset2 			 
  	FROM     userquery.dbo.#SESSION.acc#AssetDisposal I						 
    WHERE    I.AssetId IN (SELECT AssetId FROM AssetItemDisposal WHERE DisposalId = '#rowguid#')		 							
</cfquery>				

<tr><td height="4"></td></tr>
<tr><td colspan="2" height="1" class="linedotted"></td></tr>
<tr><td height="4"></td></tr>

<tr>
<td colspan="2">
	<cfoutput>
		<iframe src="DisposalItems.cfm?DisposalId=#rowguid#&table=2" id="items" name="items" width="100%" height="200" scrolling="yes" frameborder="0"></iframe>
	</cfoutput>
</td></tr>

<tr><td colspan="2" height="1" class="linedotted"></td></tr>
<tr><td height="4"></td></tr>

<tr><td colspan="2" align="center">

	<cfoutput>
	<cfif Form.AssetId neq "">
		<cf_tl id="Close" var="1">
		<input type="button" name="Submit" id="Submit" value="#lt_text#" class="button10g" onclick="window.close()" style="width:120">
		<cfif save eq "1">
			<cf_tl id="Submit" var="1">
			<input type="submit" name="Submit" id="Submit" value="#lt_text#" class="button10g" style="width:120">
		</cfif>
	</cfif>
	</cfoutput>

</td></tr>

</table>

</cfform>

<cf_screenbottom layout="webapp">