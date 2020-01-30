
<cfparam name="url.memoid"   default="">
<cfparam name="form.Memo"    default="">
<cfparam name="url.Action"   default="">

<cfquery name="Parameter" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ParameterMission
	WHERE Mission = '#url.Mission#'	
</cfquery>

<cfif url.action eq "purge">

	<cfquery name="Clear" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM  ElementMemo
		WHERE  ElementId = '#URL.elementid#'
		AND    MemoId = '#url.memoid#'		
	</cfquery>
	
</cfif>

<cfif url.memoid neq "">

	<cfset memoid = url.memoid>

</cfif>

<cfif form.Memo neq "">

	<cfquery name="Check" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ElementMemo
		WHERE  ElementId = '#URL.elementid#'
		AND    MemoId = '#memoid#'		
	</cfquery>
	
	<cfif Check.recordcount eq "0">

		<cfquery name="Memo" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO ElementMemo
			(ElementId, MemoId, ElementMemo, OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES
			('#URL.ElementId#','#memoid#','#form.Memo#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')			
		</cfquery>
			
	<cfelse>
	
		<cfquery name="update" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE ElementMemo
			SET    ElementMemo    = '#form.Memo#'
			WHERE  ElementId      = '#URL.ElementId#'
			AND    MemoId = '#memoid#'						
		</cfquery>	
	
	</cfif>
	
	<cfset url.memoid = "">
	
</cfif>

<cfquery name="Memo" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   ElementMemo
	WHERE  ElementId = '#URL.ElementId#'
	ORDER BY Created 
</cfquery>

<cfinvoke component="Service.Presentation.Presentation"
	       method="highlight" class="highlight4"
	       returnvariable="stylescroll"/>		   

<cfform method="post" name="memoform" id="memoform">
	
	<table width="95%" 
	  align="center" 	
	  border="0" 	
	  cellspacing="0" 
	  cellpadding="0">
	  
	 <tr><td height="14"></td></tr> 
	
	<tr class="linedotted">
	    <td width="16"></td>
		<td class="labelit" width="70%"><cf_tl id="Memo"></td>
		<td class="labelit"><cf_tl id="Officer"></td>
		<td class="labelit"><cf_tl id="Date/Time"></td>
		<td align="center"></td>
	
	</tr>
				
	<cfoutput query="Memo">
	
		<cfif url.memoid eq memoid and form.Memo eq "" and SESSION.acc eq OfficerUserId>
		
			<tr bgcolor="ffffff">
			    <td class="labelit" height="20">#currentrow#.<cf_space spaces="10"></td>
				<td height="140" colspan="4">
				<cf_textarea name="Memo" class="regular" style="width:95%;height:95%;word-wrap: break-word; word-break: break-all;"
				onKeyUp="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/tools/input/text/memolength.cfm?field=Memo&size=2000','mcount','','','POST','memoform')">#ElementMemo#</cf_textarea>
				</td>
			</tr>
			<!--- attachments --->
			
			<tr>
				<td></td>
				<td colspan="4" id="mcount" height="20"> </td>
			</tr>
			
			<tr>
			    <td></td>
				<td colspan="4">						
												
					<cf_filelibraryN				    	
					    DocumentHost="#SESSION.rootDocumentPath#\"
						DocumentPath="#parameter.claimLibrary#"
						SubDirectory="#url.elementid#" 
						Box="box_#currentrow#"
						loadscript="no"
						Filter="#left(memoid,8)#"						
						Insert="yes"
						Remove="yes"
						reload="true">										
				
				</td>
			</tr>
			
			<tr><td height="3"></td></tr>
			<tr><td colspan="5" align="center">
			<input type="button" name="Save" value="Save" class="button10s" style="width:100px;" onclick="ColdFusion.navigate('../Memo/MemoView.cfm?tabno=#url.tabno#&elementid=#url.elementid#&memoid=#memoid#&mission=#url.mission#','contentbox#url.tabno#','','','POST','memoform')">
			</td></tr>
			<tr><td height="3"></td></tr>
		
		<cfelse>
		
		    <cfif SESSION.acc eq OfficerUserId>
			
			    <tr #stylescroll# onclick="ColdFusion.navigate('../Memo/MemoView.cfm?tabno=#url.tabno#&elementid=#url.elementId#&memoid=#memoid#&mission=#url.mission#','contentbox#url.tabno#')">
				
			<cfelse>
			
			    <tr>
			
			</cfif>
			
			    <td class="labelit" height="23">#currentrow#.<cf_space spaces="10"></td>
				<td class="labelit" width="70%" style="word-wrap: break-word; word-break: break-all">#paragraphformat(ElementMemo)#</td>
				<td class="labelit">#OfficerFirstName# #OfficerLastName#</td>
				<td class="labelit">#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>
				<td align="center">
				
				   <table cellspacing="0" cellpadding="0">
				   <tr><td style="padding-left:4px">
				   <cf_img icon="edit" onclick="ColdFusion.navigate('../Memo/MemoView.cfm?tabno=#url.tabno#&elementid=#url.elementid#&memoid=#memoid#&mission=#url.mission#&action=edit','contentbox#url.tabno#')" border="0">
				   </td>
				   <td style="padding-left:4px">
				   <cf_img icon="delete" onclick="ColdFusion.navigate('../Memo/MemoView.cfm?tabno=#url.tabno#&elementid=#url.elementid#&memoid=#memoid#&mission=#url.mission#&action=purge','contentbox#url.tabno#')" border="0">
				   </td>
				   </tr></table>
			   </td>
			   
			</tr>
			
			<!--- attachments --->
			
			<cf_filelibraryCheck		
			    DocumentHost="#SESSION.rootDocumentPath#\"	
			    DocumentPath="#parameter.claimLibrary#"
				SubDirectory="#url.elementid#" 			
				Filter="#left(memoid,8)#">		
				
			<cfif files gte "1">
			
			<tr><td></td><td colspan="4" class="line"></tr>
			<tr>
			    <td></td>
				
				<td colspan="3">
																
					<cf_filelibraryN		
					    DocumentHost="#SESSION.rootDocumentPath#\"		    	
						DocumentPath="#parameter.claimLibrary#"
						SubDirectory="#url.elementid#" 
						Box="box_#currentrow#"
						loadscript="no"
						Filter="#left(memoid,8)#"						
						Insert="no"
						Remove="no"
						reload="true">							
								
				
				</td>
			</tr>
			
			</cfif>	
		
		</cfif>		
		
		<tr><td colspan="4" height="3"></td></tr>
		<tr><td colspan="5" height="1" class="linedotted"></td></tr>
		<tr><td height="3"></td></tr>
	
	</cfoutput>
	
	<cfif url.memoid eq "" or memo.recordcount eq "0">
	
		<cf_assignId>
		
		<cfset memoid = rowguid>	
		
		<tr bgcolor="ffffff">
		<td class="labelit"> <cfoutput>#memo.recordcount+1#.</cfoutput></td>
		<td colspan="4">
			<cftextarea name="Memo" class="regular" style="width:99%;font-size:14px;padding:4px;height:150"
			onKeyUp="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/tools/input/text/memolength.cfm?field=Memo&size=2000','memcount','','','POST','memoform')"></cftextarea>
		</td>
		</tr>
		<tr><td></td><td colspan="4" id="memcount" height="20"></td></tr>
		
		<tr><td height="3"></td></tr>
		
		<!--- attachments --->
			
		<tr>
			    <td></td>
				<td colspan="4">						
												
					<cf_filelibraryN				    	
					    DocumentHost="#SESSION.rootDocumentPath#\"
						DocumentPath="#parameter.claimLibrary#"
						SubDirectory="#url.elementid#" 
						Box="box_0"
						loadscript="no"
						Filter="#left(memoid,8)#"						
						Insert="yes"
						Remove="yes"
						reload="true">										
				
				</td>
			</tr>
		
		
		<tr><td colspan="5" align="center">
			<cf_tl id="Save" var="1">
		    <cfoutput>		
				<input type = "button" 
				  name    = "Save" 
				  value   = "#lt_text#" 
				  style   = "width:140px" 
				  class   = "button10s" 
				  onclick = "ColdFusion.navigate('../Memo/MemoView.cfm?tabno=#url.tabno#&elementid=#url.elementId#&memoid=#memoid#&mission=#url.mission#','contentbox#url.tabno#','','','POST','memoform')">
			</cfoutput>
		</td></tr>
		<tr><td height="3"></td></tr>

	</cfif>

	</cfform>

</table>




